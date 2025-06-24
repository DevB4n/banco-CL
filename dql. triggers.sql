-- TABLAS AUXILIARES

-- Tabla para auditoría de clientes (necesaria para trigger 10)
CREATE TABLE IF NOT EXISTS auditoria_cliente (
    auditoria_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    campo_modificado VARCHAR(50) NOT NULL,
    valor_anterior TEXT,
    valor_nuevo TEXT,
    fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id)
);

-- Tabla para notificaciones de vencimiento (necesaria para trigger 20)
CREATE TABLE IF NOT EXISTS notificaciones_vencimiento (
    notificacion_id INT AUTO_INCREMENT PRIMARY KEY,
    tarjeta_id INT NOT NULL,
    cuota_manejo_id INT NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    estado ENUM('vencida', 'notificada', 'resuelta') DEFAULT 'vencida',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id),
    FOREIGN KEY (cuota_manejo_id) REFERENCES cuota_manejo(cuota_manejo_id)
);

-- Agregar campo fecha_ultima_transaccion a la tabla tarjeta (necesario para trigger 12)
ALTER TABLE tarjeta ADD COLUMN fecha_ultima_transaccion DATETIME NULL;



-- 1. Al insertar un nuevo pago, actualizar automáticamente el estado de la cuota de manejo
DELIMITER $$
CREATE TRIGGER trg_actualizar_estado_cuota_pago
AFTER INSERT ON historial_pago
FOR EACH ROW
BEGIN
    UPDATE cuota_manejo 
    SET estado_pago = 'pagado'
    WHERE cuota_manejo_id = NEW.cuota_manejo_id;
END$$
DELIMITER ;

-- 2. Al modificar el monto de apertura de una tarjeta, recalcular la cuota de manejo correspondiente
DELIMITER $$
CREATE TRIGGER trg_recalcular_cuota_monto_apertura
AFTER UPDATE ON tarjeta
FOR EACH ROW
BEGIN
    DECLARE v_descuento DECIMAL(5,2);
    DECLARE v_nueva_cuota DECIMAL(10,2);
    
    IF OLD.monto_apertura != NEW.monto_apertura THEN
        
        SELECT descuento INTO v_descuento
        FROM tipo_tarjeta 
        WHERE tipo_tarjeta_id = NEW.tipo_tarjeta_id;
        
        
        SET v_nueva_cuota = (NEW.monto_apertura * 0.02) * (100 - v_descuento) / 100;
        
        
        UPDATE cuota_manejo 
        SET monto = v_nueva_cuota
        WHERE tarjeta_id = NEW.tarjeta_id AND estado_pago = 'pendiente';
    END IF;
END$$
DELIMITER ;

-- 3. Al registrar una nueva tarjeta, asignar automáticamente el descuento basado en el tipo de tarjeta
DELIMITER $$
CREATE TRIGGER trg_aplicar_descuento_nueva_tarjeta
AFTER INSERT ON tarjeta
FOR EACH ROW
BEGIN
    DECLARE v_descuento DECIMAL(5,2);
    DECLARE v_cuota_base DECIMAL(10,2);
    DECLARE v_cuota_final DECIMAL(10,2);
    
    
    SELECT descuento INTO v_descuento
    FROM tipo_tarjeta 
    WHERE tipo_tarjeta_id = NEW.tipo_tarjeta_id;
    
    
    SET v_cuota_base = NEW.monto_apertura * 0.02;
    
 
    SET v_cuota_final = v_cuota_base * (100 - v_descuento) / 100;
    
    
    INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
    (NEW.tarjeta_id, DATE_ADD(CURDATE(), INTERVAL 1 MONTH), v_cuota_final, 'pendiente'),
    (NEW.tarjeta_id, DATE_ADD(CURDATE(), INTERVAL 2 MONTH), v_cuota_final, 'pendiente'),
    (NEW.tarjeta_id, DATE_ADD(CURDATE(), INTERVAL 3 MONTH), v_cuota_final, 'pendiente');
END$$
DELIMITER ;

-- 4. Al eliminar una tarjeta, eliminar todas las cuotas de manejo asociadas a esa tarjeta
DELIMITER $$
CREATE TRIGGER trg_eliminar_cuotas_tarjeta
BEFORE DELETE ON tarjeta
FOR EACH ROW
BEGIN
    
    DELETE FROM historial_pago WHERE tarjeta_id = OLD.tarjeta_id;
    
    
    DELETE FROM cuota_manejo WHERE tarjeta_id = OLD.tarjeta_id;
    
    
    DELETE FROM pago_tarjeta WHERE tarjeta_id = OLD.tarjeta_id;
END$$
DELIMITER ;

-- 5. Al actualizar los descuentos, recalcular las cuotas de manejo de las tarjetas afectadas
DELIMITER $$
CREATE TRIGGER trg_recalcular_cuotas_descuento
AFTER UPDATE ON tipo_tarjeta
FOR EACH ROW
BEGIN
    DECLARE v_nueva_cuota DECIMAL(10,2);
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_tarjeta_id INT;
    DECLARE v_monto_apertura DECIMAL(10,2);
    

    DECLARE cur_tarjetas CURSOR FOR 
        SELECT tarjeta_id, monto_apertura 
        FROM tarjeta 
        WHERE tipo_tarjeta_id = NEW.tipo_tarjeta_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    IF OLD.descuento != NEW.descuento THEN
        OPEN cur_tarjetas;
        
        read_loop: LOOP
            FETCH cur_tarjetas INTO v_tarjeta_id, v_monto_apertura;
            IF done THEN
                LEAVE read_loop;
            END IF;
            

            SET v_nueva_cuota = (v_monto_apertura * 0.02) * (100 - NEW.descuento) / 100;
            
 
            UPDATE cuota_manejo 
            SET monto = v_nueva_cuota
            WHERE tarjeta_id = v_tarjeta_id AND estado_pago = 'pendiente';
        END LOOP;
        
        CLOSE cur_tarjetas;
    END IF;
END$$
DELIMITER ;

-- 6. Validar saldo suficiente antes de crear una tarjeta
DELIMITER $$
CREATE TRIGGER trg_validar_saldo_nueva_tarjeta
BEFORE INSERT ON tarjeta
FOR EACH ROW
BEGIN
    DECLARE v_saldo_cuenta DECIMAL(10,2);
    
    SELECT saldo INTO v_saldo_cuenta
    FROM cuenta 
    WHERE cuenta_id = NEW.cuenta_id;
    
    IF NEW.monto_apertura > v_saldo_cuenta THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Saldo insuficiente en la cuenta para crear la tarjeta';
    END IF;
END$$
DELIMITER ;

-- 7. Actualizar saldo de cuenta al crear una tarjeta
DELIMITER $$
CREATE TRIGGER trg_actualizar_saldo_cuenta_tarjeta
AFTER INSERT ON tarjeta
FOR EACH ROW
BEGIN
    UPDATE cuenta 
    SET saldo = saldo - NEW.monto_apertura
    WHERE cuenta_id = NEW.cuenta_id;
END$$
DELIMITER ;

-- 8. Registrar automáticamente el historial cuando se marca una cuota como pagada
DELIMITER $$
CREATE TRIGGER trg_registrar_historial_cuota_pagada
AFTER UPDATE ON cuota_manejo
FOR EACH ROW
BEGIN
    DECLARE v_pago_id INT;
    
    IF OLD.estado_pago = 'pendiente' AND NEW.estado_pago = 'pagado' THEN

        SELECT p.pago_id INTO v_pago_id
        FROM pago p
        INNER JOIN pago_tarjeta pt ON p.pago_id = pt.pago_id
        WHERE pt.tarjeta_id = NEW.tarjeta_id 
          AND p.estado = 'exitoso'
          AND p.monto_pagado >= NEW.monto
        ORDER BY p.fecha_pago DESC
        LIMIT 1;
        

        IF v_pago_id IS NOT NULL THEN
            INSERT INTO historial_pago (tarjeta_id, cuota_manejo_id, pago_id, fecha_pago)
            VALUES (NEW.tarjeta_id, NEW.cuota_manejo_id, v_pago_id, NOW());
        END IF;
    END IF;
END$$
DELIMITER ;

-- 9. Validar que el correo electrónico sea único al insertar cliente
DELIMITER $$
CREATE TRIGGER trg_validar_correo_unico
BEFORE INSERT ON cliente
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count
    FROM cliente 
    WHERE correo_electronico = NEW.correo_electronico;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado';
    END IF;
END$$
DELIMITER ;

-- 10. Auditar cambios en información de clientes
DELIMITER $$
CREATE TRIGGER trg_auditoria_cliente_update
AFTER UPDATE ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_cliente (cliente_id, campo_modificado, valor_anterior, valor_nuevo, fecha_modificacion)
    SELECT NEW.cliente_id, 'nombre', OLD.nombre, NEW.nombre, NOW()
    WHERE OLD.nombre != NEW.nombre
    UNION ALL
    SELECT NEW.cliente_id, 'apellido', OLD.apellido, NEW.apellido, NOW()
    WHERE OLD.apellido != NEW.apellido
    UNION ALL
    SELECT NEW.cliente_id, 'celular', OLD.celular, NEW.celular, NOW()
    WHERE OLD.celular != NEW.celular
    UNION ALL
    SELECT NEW.cliente_id, 'correo_electronico', OLD.correo_electronico, NEW.correo_electronico, NOW()
    WHERE OLD.correo_electronico != NEW.correo_electronico;
END$$
DELIMITER ;

-- 11. Prevenir eliminación de clientes con tarjetas activas
DELIMITER $$
CREATE TRIGGER trg_prevenir_eliminacion_cliente_activo
BEFORE DELETE ON cliente
FOR EACH ROW
BEGIN
    DECLARE v_tarjetas_activas INT;
    
    SELECT COUNT(*) INTO v_tarjetas_activas
    FROM tarjeta 
    WHERE cliente_id = OLD.cliente_id;
    
    IF v_tarjetas_activas > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se puede eliminar un cliente con tarjetas activas';
    END IF;
END$$
DELIMITER ;

-- 12. Actualizar fecha de última transacción al realizar un pago
DELIMITER $$
CREATE TRIGGER trg_actualizar_ultima_transaccion
AFTER INSERT ON pago
FOR EACH ROW
BEGIN
    UPDATE tarjeta t
    INNER JOIN pago_tarjeta pt ON t.tarjeta_id = pt.tarjeta_id
    SET t.fecha_ultima_transaccion = NEW.fecha_pago
    WHERE pt.pago_id = NEW.pago_id;
END$$
DELIMITER ;

-- 13. Generar número de tarjeta automáticamente
DELIMITER $$
CREATE TRIGGER trg_generar_numero_tarjeta
BEFORE INSERT ON tarjeta
FOR EACH ROW
BEGIN
    DECLARE v_ultimo_numero BIGINT;
    DECLARE v_nuevo_numero VARCHAR(20);
    
    IF NEW.numero_tarjeta IS NULL OR NEW.numero_tarjeta = '' THEN
        SELECT COALESCE(MAX(CAST(SUBSTRING(numero_tarjeta, -4) AS UNSIGNED)), 0) + 1 
        INTO v_ultimo_numero
        FROM tarjeta;
        
        SET v_nuevo_numero = CONCAT('4000123410', LPAD(v_ultimo_numero, 6, '0'));
        SET NEW.numero_tarjeta = v_nuevo_numero;
    END IF;
END$$
DELIMITER ;

-- 14. Validar que el monto de pago no sea negativo
DELIMITER $$
CREATE TRIGGER trg_validar_monto_pago_positivo
BEFORE INSERT ON pago
FOR EACH ROW
BEGIN
    IF NEW.monto_pagado <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El monto del pago debe ser mayor a cero';
    END IF;
END$$
DELIMITER ;

-- 15. Actualizar saldo de tarjeta al realizar transacciones
DELIMITER $$
CREATE TRIGGER trg_actualizar_saldo_tarjeta_pago
AFTER INSERT ON historial_pago
FOR EACH ROW
BEGIN
    DECLARE v_monto_pago DECIMAL(10,2);
    
    SELECT monto_pagado INTO v_monto_pago
    FROM pago 
    WHERE pago_id = NEW.pago_id;
    
    UPDATE tarjeta 
    SET saldo = saldo + v_monto_pago
    WHERE tarjeta_id = NEW.tarjeta_id;
END$$
DELIMITER ;

-- 16. Prevenir modificación de pagos exitosos
DELIMITER $$
CREATE TRIGGER trg_prevenir_modificacion_pago_exitoso
BEFORE UPDATE ON pago
FOR EACH ROW
BEGIN
    IF OLD.estado = 'exitoso' AND NEW.estado != 'exitoso' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se puede modificar un pago exitoso';
    END IF;
END$$
DELIMITER ;

-- 17. Validar fecha de cuota no sea en el pasado
DELIMITER $$
CREATE TRIGGER trg_validar_fecha_cuota_futura
BEFORE INSERT ON cuota_manejo
FOR EACH ROW
BEGIN
    IF NEW.fecha_cuota < CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La fecha de la cuota no puede ser en el pasado';
    END IF;
END$$
DELIMITER ;

-- 18. Crear cuenta automáticamente al insertar cliente
DELIMITER $$
CREATE TRIGGER trg_crear_cuenta_nuevo_cliente
AFTER INSERT ON cliente
FOR EACH ROW
BEGIN
    DECLARE v_numero_cuenta VARCHAR(20);
    
    
    SET v_numero_cuenta = CONCAT('1001', LPAD(NEW.cliente_id, 6, '0'));
    
    INSERT INTO cuenta (numero_cuenta, tipo_cuenta, saldo, cliente_id)
    VALUES (v_numero_cuenta, 'ahorros', 0.00, NEW.cliente_id);
END$$
DELIMITER ;

-- 19. Validar que una cuenta no tenga saldo negativo
DELIMITER $$
CREATE TRIGGER trg_validar_saldo_no_negativo
BEFORE UPDATE ON cuenta
FOR EACH ROW
BEGIN
    IF NEW.saldo < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El saldo de la cuenta no puede ser negativo';
    END IF;
END$$
DELIMITER ;

-- 20. Notificar cuotas vencidas (actualizar estado)
DELIMITER $$
CREATE TRIGGER trg_marcar_cuotas_vencidas
BEFORE UPDATE ON cuota_manejo
FOR EACH ROW
BEGIN
    IF NEW.fecha_cuota < CURDATE() AND NEW.estado_pago = 'pendiente' THEN
        -- Crear registro de cuota vencida (asumiendo tabla de notificaciones)
        INSERT INTO notificaciones_vencimiento (tarjeta_id, cuota_manejo_id, fecha_vencimiento, estado)
        VALUES (NEW.tarjeta_id, NEW.cuota_manejo_id, NEW.fecha_cuota, 'vencida');
    END IF;
END$$
DELIMITER ;