-- Active: 1748981230048@@127.0.0.1@3307@banco_cl
USE banco;

--#1. Registrar una nueva cuota de manejo calculando automáticamente el descuento.

USE banco;
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


CALL registrar_cuota_manejo();

--#2. Obtiene los empleados
USE banco;
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
USE banco;
DELIMITER $$
CREATE PROCEDURE procesar_pago_tarjeta (
    IN id_tarjeta INT,
    IN monto_pagado DECIMAL(10,2),
    IN fecha_pago DATETIME
)
BEGIN
    DECLARE cuota_id INT;
    DECLARE estado_pago ENUM('pendiente', 'pagado');

    SELECT cuota_manejo_id, estado_pago
    INTO cuota_id, estado_pago
    FROM cuota_manejo
    WHERE tarjeta_id = id_tarjeta AND estado_pago = 'pendiente'
    ORDER BY fecha_cuota DESC
    LIMIT 1;


    IF cuota_id IS NOT NULL THEN
   
        UPDATE cuota_manejo
        SET estado_pago = 'pagado'
        WHERE cuota_manejo_id = cuota_id;

        INSERT INTO pago (fecha_pago, monto_pagado, estado)
        VALUES (fecha_pago, monto_pagado, 'exitoso');

  
        INSERT INTO pago_tarjeta (pago_id, tarjeta_id)
        VALUES (LAST_INSERT_ID(), id_tarjeta);
        

        INSERT INTO historial_pago (tarjeta_id, cuota_manejo_id, pago_id, fecha_pago)
        VALUES (id_tarjeta, cuota_id, LAST_INSERT_ID(), fecha_pago);
    END IF;
END $$

CALL procesar_pago_tarjeta(1, 6000.00, '2023-10-01 10:00:00');


--#4. Generar reportes mensuales de cuotas de manejo.
USE banco;
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
USE banco;
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
USE banco;
DELIMITER $$

CREATE PROCEDURE registrar_nuevo_cliente (
    IN nombre VARCHAR(100),
    IN apellido VARCHAR(100),
    IN identificacion VARCHAR(100),
    IN celular VARCHAR(20),
    IN email VARCHAR(50),
    IN numero_tarjeta VARCHAR(20),
    IN tipo_tarjeta_id INT,
    IN cuenta_id INT,
    IN fecha_apertura DATE,
    IN monto_apertura DECIMAL(10,2),
    IN saldo DECIMAL(10,2)
)
BEGIN
    DECLARE cliente_existente INT;
    DECLARE tipo_tarjeta_existente INT;
    DECLARE cuenta_existente INT;

   
    SELECT COUNT(*) INTO cliente_existente
    FROM cliente
    WHERE identificacion = identificacion;

  
    SELECT COUNT(*) INTO tipo_tarjeta_existente
    FROM tipo_tarjeta
    WHERE tipo_tarjeta_id = tipo_tarjeta_id;

    SELECT COUNT(*) INTO cuenta_existente
    FROM cuenta
    WHERE cuenta_id = cuenta_id;

   
    IF cliente_existente > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente ya está registrado con esa identificación.';
    ELSEIF tipo_tarjeta_existente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de tarjeta no válido.';
    ELSEIF cuenta_existente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cuenta no válida.';
    ELSE
       
        INSERT INTO cliente (nombre, apellido, identificacion, celular, correo_electronico)
        VALUES (nombre, apellido, identificacion, celular, email);

       
        INSERT INTO tarjeta (numero_tarjeta, tipo_tarjeta_id, cliente_id, cuenta_id, fecha_apertura, monto_apertura, saldo)
        VALUES (numero_tarjeta, tipo_tarjeta_id, LAST_INSERT_ID(), cuenta_id, fecha_apertura, monto_apertura, saldo);
    END IF;
END $$

DELIMITER ;


CALL registrar_nuevo_cliente(
    'Juan',             
    'Pérez',           
    '1234567890',       
    '3001234567',       
    'juanperez@email.com', 
    '4567890123456789', 
    2,                  
    1,               
    '2025-06-22',      
    500000.00,         
    500000.00          
);

--#7. Actualiza el estado de las cuentas vencidas.
USE banco;
DELIMITER $$

CREATE PROCEDURE estado_cuotas()
BEGIN
    UPDATE cuota_manejo
    SET estado_pago = 'vencido'
    WHERE fecha_cuota < CURDATE() AND estado_pago = 'pendiente';
END $$

DELIMITER ;

CALL estado_cuotas();


--#8. listar las cuotas de manejo de un cliente según su identificación.
USE banco;
DELIMITER $$
CREATE PROCEDURE listar_cuotas_cliente(
    IN identificacion VARCHAR(100)
)
BEGIN
    SELECT cm.*
    FROM cliente c
    JOIN tarjeta t ON c.cliente_id = t.cliente_id
    JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
    WHERE c.identificacion = identificacion;
END $$
DELIMITER ;
CALL listar_cuotas_cliente('1078912345');

--9. Actualiza correo, celular o ambos de un cliente según su identificación.
USE banco;
DELIMITER $$

CREATE PROCEDURE actualizar_datos_cliente(
    IN a_identificacion VARCHAR(100),
    IN nuevo_celular VARCHAR(20),
    IN nuevo_correo VARCHAR(50)
)
BEGIN
    UPDATE cliente
    SET celular = nuevo_celular,
        correo_electronico = nuevo_correo
    WHERE identificacion = a_identificacion;
END$$

DELIMITER ;

CALL actualizar_datos_cliente('1078912345', '3009876543', 'nuevo@email.com');


--#10. 
USE banco;
DELIMITER $$
CREATE PROCEDURE reporte_cliente(
    IN monto_limite DECIMAL(10,2)
)
BEGIN
    SELECT c.nombre, c.apellido, t.saldo
    FROM cliente c
    JOIN tarjeta t ON c.cliente_id = t.cliente_id
    WHERE t.saldo < monto_limite;
END $$
DELIMITER ;

CALL reporte_cliente(260000.00);


--11. Transferir saldo entre cuentas de diferentes clientes
USE banco;
DELIMITER $$
CREATE PROCEDURE transferir_entre_cuentas(
    IN cuenta_origen VARCHAR(20),
    IN cuenta_destino VARCHAR(20),
    IN monto_transferencia DECIMAL(10,2),
    IN concepto VARCHAR(100)
)
BEGIN
    DECLARE saldo_origen DECIMAL(10,2);
    DECLARE cuenta_origen_id INT;
    DECLARE cuenta_destino_id INT;
    

    SELECT cuenta_id, saldo INTO cuenta_origen_id, saldo_origen
    FROM cuenta WHERE numero_cuenta = cuenta_origen;
    
    SELECT cuenta_id INTO cuenta_destino_id
    FROM cuenta WHERE numero_cuenta = cuenta_destino;
    
    IF cuenta_origen_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cuenta origen no existe';
    ELSEIF cuenta_destino_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cuenta destino no existe';
    ELSEIF saldo_origen < monto_transferencia THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente';
    ELSE

        UPDATE cuenta SET saldo = saldo - monto_transferencia WHERE cuenta_id = cuenta_origen_id;
        UPDATE cuenta SET saldo = saldo + monto_transferencia WHERE cuenta_id = cuenta_destino_id;
        
        SELECT 'Transferencia exitosa' as resultado, monto_transferencia as monto, concepto;
    END IF;
END $$
DELIMITER ;


CALL transferir_entre_cuentas('1001000001', '1001000002', 50000, 'Pago préstamo');


-- #12. Calcular comisiones por transacciones según tipo de cuenta
USE banco;
DELIMITER $$
CREATE PROCEDURE calcular_comision_transaccion(
    IN cuenta_id INT,
    IN tipo_transaccion ENUM('retiro', 'consignacion', 'transferencia'),
    IN monto DECIMAL(10,2)
)
BEGIN
    DECLARE tipo_cuenta ENUM('ahorros', 'corriente');
    DECLARE comision DECIMAL(10,2) DEFAULT 0;
    
    SELECT tipo_cuenta INTO tipo_cuenta
    FROM cuenta WHERE cuenta_id = cuenta_id;
    
   
    CASE 
        WHEN tipo_cuenta = 'ahorros' AND tipo_transaccion = 'retiro' THEN
            SET comision = monto * 0.002; 
        WHEN tipo_cuenta = 'corriente' AND tipo_transaccion = 'transferencia' THEN
            SET comision = monto * 0.001; 
        WHEN tipo_transaccion = 'consignacion' THEN
            SET comision = 1000; 
        ELSE
            SET comision = 0;
    END CASE;
    
    SELECT cuenta_id as cuenta, tipo_transaccion as transaccion, 
           monto as monto, comision as comision,
           (monto - comision) as monto_neto;
END $$
CALL calcular_comision_transaccion(3, 'consignacion', 50000);


--13. Genera un estado detallado de la cuenta de un cliente en específico durante un tiempo
USE banco;
DELIMITER $$
CREATE PROCEDURE generar_estado_cuenta(
  IN numero_cuenta VARCHAR(20),
  IN fecha_inicio DATETIME,
  IN fecha_fin DATETIME
)
BEGIN
  DECLARE cliente_id INT;
  DECLARE saldo_inicial DECIMAL(10,2);

  SELECT cliente_id, saldo INTO cliente_id, saldo_inicial
  FROM cuenta
  WHERE numero_cuenta = numero_cuenta;

  SELECT cl.nombre, cl.apellido, cl.identificacion, cl.correo_electronico,
         c.numero_cuenta, c.tipo_cuenta, c.saldo AS saldo_actual,
         ct.fecha_cuota, ct.monto, ct.estado_pago
  FROM cliente cl
  JOIN cuenta c ON cl.cliente_id = c.cliente_ids
  JOIN tarjeta t ON t.cuenta_id = c.cuenta_id
  JOIN cuota_manejo ct ON ct.tarjeta_id = t.tarjeta_id
  WHERE c.numero_cuenta = numero_cuenta
    AND ct.fecha_cuota BETWEEN fecha_inicio AND fecha_fin
  ORDER BY ct.fecha_cuota;
END $$
DELIMITER ;



CALL generar_estado_cuenta('1001000001', '2025-03-01 00:00:00', '2025-05-31 23:59:59');


--14. Calcular el descuento según el tipo de cuenta
USE banco;
DELIMITER $$
CREATE PROCEDURE calcular_descuento(
    IN num_tarjeta VARCHAR(20),
    IN monto_original DECIMAL(10,2),
    OUT descuento_aplicado DECIMAL (10,2),
    OUT monto_final DECIMAL (10,2)
)
BEGIN
    DECLARE descuento_porcentaje DECIMAL(5,2) DEFAULT 0;

    SELECT tt.descuento
    INTO descuento_porcentaje
    FROM tarjeta t
    JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE t.numero_tarjeta = num_tarjeta;

    SET descuento_aplicado = ROUND(monto_original * (descuento_porcentaje / 100),2);
    SET monto_final = monto_original - descuento_aplicado;
END$$

DELIMITER ;
CALL calcular_descuento('4000123410010001', 200000.00, @descuento, @total);
SELECT @descuento; --esto para imprimir el out
SELECT @total;

--15. Consultar tarjetas vinculadas a un cliente Devuelve todos los datos de tarjetas que posee un cliente específico.
USE banco;
DELIMITER $$
CREATE PROCEDURE tarjetas_vinculadas(
    IN cliente_id VARCHAR(10)
)
BEGIN
    SELECT 
    t.numero_tarjeta, 
    t.tipo_tarjeta_id, 
    t.cliente_id, 
    t.fecha_apertura,
    t.monto_apertura, 
    t.saldo
    FROM cliente cl
    JOIN tarjeta t ON cl.cliente_id = t.cliente_id
    WHERE cl.cliente_id = cliente_id;
END $$

DELIMITER;
CALL tarjetas_vinculadas('5');

--#16. Cuántas tarjetas hay por la categoría joven
USE banco;
DELIMITER $$

CREATE PROCEDURE tarjetas_activas_joven(
    IN nombre_tipo_tarjeta ENUM('joven', 'nomina', 'visa')
)
BEGIN
    SELECT 
        t.numero_tarjeta,
        tt.nombre AS tipo_tarjeta
    FROM tarjeta t
    JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE tt.nombre = nombre_tipo_tarjeta;
END $$

DELIMITER ;

CALL tarjetas_activas_joven('1');

--#17. Cuántas tarjetas hay por la categoría nomina con su fecha y saldo
USE banco;
DELIMITER $$

CREATE PROCEDURE tarjetas_activas_nomina(
    IN nombre_tipo_tarjeta ENUM('joven', 'nomina', 'visa')
)
BEGIN
    SELECT 
        t.numero_tarjeta,
        t.fecha_apertura,
        t.saldo,
        tt.nombre AS tipo_tarjeta
    FROM tarjeta t
    JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE tt.nombre = nombre_tipo_tarjeta;
END $$

DELIMITER ;

CALL tarjetas_activas_nomina('2');


--#18. Cuántas tarjetas hay por la categoría visa con el cliente_id, monto_apertura y saldo
USE banco;
DELIMITER $$

CREATE PROCEDURE tarjetas_activas_visa(
    IN nombre_tipo_tarjeta ENUM('joven', 'nomina', 'visa')
)
BEGIN
    SELECT 
        t.numero_tarjeta,
        t.monto_apertura,
        t.saldo,
        tt.nombre AS tipo_tarjeta
    FROM tarjeta t
    JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE tt.nombre = nombre_tipo_tarjeta;
END $$

DELIMITER ;
CALL tarjetas_activas_visa('3');

--·19. Generar reporte de ingresos por tipo de tarjeta sumando los pagos recibidios en c/u.
USE banco;
DELIMITER $$

CREATE PROCEDURE ingresos_por_tipo_tarjeta()
BEGIN
  SELECT 
    tt.nombre AS tipo_tarjeta,
    SUM(cm.monto) AS total_ingresos
  FROM cuota_manejo cm
  JOIN tarjeta t ON cm.tarjeta_id = t.tarjeta_id
  JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
  WHERE cm.estado_pago = 'pagado'
  GROUP BY tt.nombre
  ORDER BY total_ingresos DESC;
END $$

DELIMITER ;
CALL ingresos_por_tipo_tarjeta();

--#20. Listar transacciones por rango de fecha y por un cliente
USE banco;
DELIMITER $$
CREATE PROCEDURE listar_transacciones(
    IN cliente_ID INT,
    IN fecha_inicio DATETIME
)
BEGIN 
    SELECT 
        t.cliente_id, 
        t.fecha_apertura, 
        t.monto_apertura
    FROM tarjeta t
    WHERE t.cliente_id = cliente_ID
      AND t.fecha_apertura >= fecha_inicio
    ORDER BY t.fecha_apertura ASC;
END $$

DELIMITER ;

CALL listar_transacciones(1, '2024-01-15');


