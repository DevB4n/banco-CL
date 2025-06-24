USE banco;

--#1. Registrar una nueva cuota de manejo calculando automáticamente el descuento.


DELIMITER $$
CREATE PROCEDURE registrar_cuota_manejo (
    IN p_tarjeta_id INT,
    IN p_monto_base DECIMAL(10,2),
    IN p_fecha DATE
)
BEGIN
    DECLARE v_descuento DECIMAL(10,2);

    SELECT tt.descuento
    INTO v_descuento
    FROM tarjeta t
    JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE t.tarjeta_id = p_tarjeta_id;

    INSERT INTO cuota_manejo (tarjeta_id, monto, fecha_cuota, estado_pago)
    VALUES (
        p_tarjeta_id,
        p_monto_base - (p_monto_base * v_descuento / 100),
        p_fecha,
        'pendiente'
    );
END$$
DELIMITER ;

-- Ejecutar el procedimiento
CALL registrar_cuota_manejo();

--#2. Obtiene los empleados
DELIMITER $$
CREATE PROCEDURE obtener_clientes(IN id_cliente INT)
BEGIN 
    SELECT *
    FROM cliente 
    WHERE cliente_id = id_cliente;
END $$
DELIMITER ;
CALL obtener_clientes(1);


--#3. Procesar un pago para una tarjeta específica, actualizando el estado de la cuota de manejo.
DELIMITER $$
CREATE PROCEDURE procesar_pago_tarjeta (
    IN id_tarjeta INT,
    IN monto_pagado DECIMAL(10,2),
    IN fecha_pago DATETIME
)
BEGIN
    DECLARE v_cuota_id INT;
    DECLARE v_estado_pago ENUM('pendiente', 'pagado');

    SELECT cuota_manejo_id, estado_pago
    INTO v_cuota_id, v_estado_pago
    FROM cuota_manejo
    WHERE tarjeta_id = id_tarjeta AND estado_pago = 'pendiente'
    ORDER BY fecha_cuota DESC
    LIMIT 1;


    IF v_cuota_id IS NOT NULL THEN
   
        UPDATE cuota_manejo
        SET estado_pago = 'pagado'
        WHERE cuota_manejo_id = v_cuota_id;

        INSERT INTO pago (fecha_pago, monto_pagado, estado)
        VALUES (fecha_pago, monto_pagado, 'exitoso');

  
        INSERT INTO pago_tarjeta (pago_id, tarjeta_id)
        VALUES (LAST_INSERT_ID(), id_tarjeta);
        

        INSERT INTO historial_pago (tarjeta_id, cuota_manejo_id, pago_id, fecha_pago)
        VALUES (id_tarjeta, v_cuota_id, LAST_INSERT_ID(), fecha_pago);
    END IF;
END $$

CALL procesar_pago_tarjeta(1, 6000.00, '2023-10-01 10:00:00');


--#4. Generar reportes mensuales de cuotas de manejo.
DELIMITER $$ 
CREATE PROCEDURE reporte_menusual(
    IN mes INT,
    IN año INT
)
BEGIN
    SELECT cm.*
    FROM cuota_manejo cm
    JOIN tarjeta t 
    ON cm.tarjeta_id = t.tarjeta_id
    WHERE MONTH(cm.fecha_cuota) = mes
    AND YEAR(cm.fecha_cuota) = año
    ORDER BY cm.fecha_cuota;

END $$
DELIMITER ;

CALL reporte_menusual(10, 2023);

--#5. Actualizar los descuentos en caso de cambios en las políticas bancarias.
DELIMITER $$
CREATE PROCEDURE actualizar_descuento (
    IN tipo_tarjeta_int INT,
    IN nuevo_descuento DECIMAL(10,2)
)
BEGIN
    DECLARE existe INT;

    SELECT COUNT(*) INTO existe
    FROM tipo_tarjeta
    WHERE tipo_tarjeta_id = tipo_tarjeta_int;


    IF existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de tarjeta no encontrado';
    ELSE
    
        UPDATE tipo_tarjeta
        SET descuento = nuevo_descuento
        WHERE tipo_tarjeta_id = tipo_tarjeta_int;
    END IF;
END $$

DELIMITER ;


CALL actualizar_descuento(1, 15.00);



--#6. Registrar nuevos clientes y tarjetas automáticamente con los datos de apertura.DROP PROCEDURE IF EXISTS registrar_nuevo_cliente;
DELIMITER $$

CREATE PROCEDURE registrar_nuevo_cliente (
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_identificacion VARCHAR(100),
    IN p_celular VARCHAR(20),
    IN p_correo_electronico VARCHAR(50),
    IN p_numero_tarjeta VARCHAR(20),
    IN p_tipo_tarjeta_id INT,
    IN p_cuenta_id INT,
    IN p_fecha_apertura DATE,
    IN p_monto_apertura DECIMAL(10,2),
    IN p_saldo DECIMAL(10,2)
)
BEGIN
    DECLARE cliente_existente INT;
    DECLARE v_tipo_tarjeta_existente INT;
    DECLARE v_cuenta_existente INT;

   
    SELECT COUNT(*) INTO cliente_existente
    FROM cliente
    WHERE identificacion = p_identificacion;

  
    SELECT COUNT(*) INTO v_tipo_tarjeta_existente
    FROM tipo_tarjeta
    WHERE tipo_tarjeta_id = p_tipo_tarjeta_id;

    SELECT COUNT(*) INTO v_cuenta_existente
    FROM cuenta
    WHERE cuenta_id = p_cuenta_id;

   
    IF cliente_existente > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente ya está registrado con esa identificación.';
    ELSEIF v_tipo_tarjeta_existente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de tarjeta no válido.';
    ELSEIF v_cuenta_existente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cuenta no válida.';
    ELSE
       
        INSERT INTO cliente (nombre, apellido, identificacion, celular, correo_electronico)
        VALUES (p_nombre, p_apellido, p_identificacion, p_celular, p_correo_electronico);

       
        INSERT INTO tarjeta (numero_tarjeta, tipo_tarjeta_id, cliente_id, cuenta_id, fecha_apertura, monto_apertura, saldo)
        VALUES (p_numero_tarjeta, p_tipo_tarjeta_id, LAST_INSERT_ID(), p_cuenta_id, p_fecha_apertura, p_monto_apertura, p_saldo);
    END IF;
END $$

DELIMITER ;

CALL registrar_nuevo_cliente(
    'Juan',             -- nombre
    'Pérez',            -- apellido
    '1234567890',       -- identificacion
    '3001234567',       -- celular
    'juanperez@email.com', -- correo_electronico
    '4567890123456789', -- numero_tarjeta
    2,                  -- tipo_tarjeta_id (ajusta según los que existan)
    1,                  -- cuenta_id (debe existir en la tabla cuenta)
    '2025-06-22',       -- fecha_apertura
    500000.00,          -- monto_apertura
    500000.00           -- saldo
);

--#7. 