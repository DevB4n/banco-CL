--Calcular la cuota de manejo para un cliente según su tipo de tarjeta y monto de apertura.

USE banco;
DROP PROCEDURE cal_cuota_manejo;
DELIMITER //
CREATE PROCEDURE cal_cuota_manejo(IN tarjeta_id INT(20) , OUT nombre VARCHAR( 40),OUT cuota_manejo DECIMAL(10,2))
BEGIN

    DECLARE monto_apertura DECIMAL(10,2);
    DECLARE descuento DECIMAL(10,2);
    SELECT c.nombre, t.monto_apertura,tt.descuento
    INTO  nombre,monto_apertura,descuento
    FROM cliente AS c
    JOIN tarjeta AS t ON c.cliente_id = t.cliente_id
    JOIN tipo_tarjeta AS tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE t.tarjeta_id = tarjeta_id;

    SET cuota_manejo = (monto_apertura * 0.04) * (descuento / 10);

END;
//

DELIMITER //

DROP FUNCTION  func_cal_cuota_man//

CREATE FUNCTION func_cal_cuota_man(tarjeta_id_input INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE nombre_cliente VARCHAR(40);
    DECLARE cuota DECIMAL(10,2);
    DECLARE resultado VARCHAR(100);

    CALL cal_cuota_manejo(tarjeta_id_input, nombre_cliente, cuota);

    SET resultado = CONCAT(nombre_cliente, ' - ', FORMAT(cuota, 2));

    RETURN resultado;
END;

//

DELIMITER ;
SELECT  func_cal_cuota_man(1);


--Estimar el descuento total aplicado sobre la cuota de manejo.


DELIMITER //
USE banco//
DELIMITER;
DELIMITER //

DROP FUNCTION IF EXISTS func_descuento;

CREATE FUNCTION func_descuento(tarjeta_id INT)
RETURNS VARCHAR(40)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE descuento INT;
    DECLARE resultado VARCHAR(40);

    SELECT tt.descuento
    INTO descuento
    FROM tarjeta AS t
    JOIN tipo_tarjeta AS tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE t.tarjeta_id = tarjeta_id;

    SET resultado = CONCAT(descuento, '%');
    RETURN resultado;
END;
//

DELIMITER ;
SELECT func_descuento(1);

--Calcular el saldo pendiente de pago de un cliente.

DELIMITER //
USE banco//
DROP FUNCTION IF EXISTS sal_pendiente //
CREATE FUNCTION sal_pendiente(cliente_id_param INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_pendiente DECIMAL(10,2);

    SELECT COALESCE(SUM(cm.monto), 0) INTO total_pendiente
    FROM tarjeta t
    JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
    WHERE t.cliente_id = cliente_id_param AND cm.estado_pago = 'pendiente';

    RETURN total_pendiente;
END;
//
DELIMITER ;
SELECT sal_pendiente(2) ;

DELIMITER //

DROP FUNCTION IF EXISTS pagos_por_tipo_tarjeta //

CREATE FUNCTION pagos_por_tipo_tarjeta(
    tipo_tarjeta_nombre ENUM('joven', 'nomina', 'visa'),
    fecha_inicio DATE,
    fecha_fin DATE
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT COALESCE(SUM(p.monto_pagado), 0)
    INTO total
    FROM pago p
    JOIN pago_tarjeta pt ON p.pago_id = pt.pago_id
    JOIN tarjeta t ON pt.tarjeta_id = t.tarjeta_id
    JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE p.estado = 'exitoso'
      AND p.fecha_pago BETWEEN fecha_inicio AND fecha_fin
      AND tt.nombre = tipo_tarjeta_nombre;

    RETURN total;
END;
//

DELIMITER ;
SELECT 'joven' AS tipo,pagos_por_tipo_tarjeta('joven', '2025-03-01', '2025-05-31') AS total_pagado;

DELIMITER //

DROP FUNCTION IF EXISTS cuotas_mes_total //

CREATE FUNCTION cuotas_mes_total(mes_año VARCHAR(7))
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT IFNULL(SUM(monto), 0)
    INTO total
    FROM cuota_manejo
    WHERE DATE_FORMAT(fecha_cuota, '%Y-%m') = mes_año;

    RETURN total;
END;
//

DELIMITER ;
SELECT cuotas_mes_total('2025-04') AS total_cuotas_abril;
