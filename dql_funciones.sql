-- Active: 1748981230048@@127.0.0.1@3307@banco_cl
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


-- 6. Función para obtener el cliente con mayor saldo pendiente
DELIMITER //
DROP FUNCTION IF EXISTS cliente_mayor_saldo_pendiente //
CREATE FUNCTION cliente_mayor_saldo_pendiente() RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE cliente_nombre VARCHAR(100);
    DECLARE max_saldo DECIMAL(10,2);
    
    SELECT CONCAT(c.nombre, ' ', c.apellido), sal_pendiente(c.cliente_id)
    INTO cliente_nombre, max_saldo
    FROM cliente c
    ORDER BY sal_pendiente(c.cliente_id) DESC
    LIMIT 1;
    
    RETURN CONCAT(cliente_nombre, ' - $', FORMAT(max_saldo, 2));
END; //
DELIMITER ;

SELECT cliente_mayor_saldo_pendiente();

-- 7. Función para contar tarjetas por tipo
DELIMITER //
DROP FUNCTION IF EXISTS contar_tarjetas_tipo //
CREATE FUNCTION contar_tarjetas_tipo(tipo_nombre ENUM('joven', 'nomina', 'visa')) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_tarjetas INT;
    
    SELECT COUNT(t.tarjeta_id)
    INTO total_tarjetas
    FROM tarjeta t
    JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE tt.nombre = tipo_nombre;
    
    RETURN total_tarjetas;
END; //
DELIMITER ;

SELECT contar_tarjetas_tipo('joven');

-- 8. Función para calcular promedio de saldos por tipo de cuenta
DELIMITER //
DROP FUNCTION IF EXISTS promedio_saldo_tipo_cuenta //
CREATE FUNCTION promedio_saldo_tipo_cuenta(tipo ENUM('ahorros', 'corriente')) RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(10,2);
    
    SELECT AVG(saldo)
    INTO promedio
    FROM cuenta
    WHERE tipo_cuenta = tipo;
    
    RETURN IFNULL(promedio, 0);
END; //
DELIMITER ;

SELECT promedio_saldo_tipo_cuenta('ahorros');

-- 9. Función para obtener el total de pagos exitosos de un cliente
DELIMITER //
DROP FUNCTION IF EXISTS total_pagos_exitosos_cliente //
CREATE FUNCTION total_pagos_exitosos_cliente(cliente_id_param INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT COALESCE(SUM(p.monto_pagado), 0)
    INTO total
    FROM pago p
    JOIN pago_tarjeta pt ON p.pago_id = pt.pago_id
    JOIN tarjeta t ON pt.tarjeta_id = t.tarjeta_id
    WHERE t.cliente_id = cliente_id_param AND p.estado = 'exitoso';
    
    RETURN total;
END; //
DELIMITER ;

 SELECT total_pagos_exitosos_cliente(1);

-- 10. Función para verificar si un cliente tiene pagos atrasados
DELIMITER //
DROP FUNCTION IF EXISTS tiene_pagos_atrasados //
CREATE FUNCTION tiene_pagos_atrasados(cliente_id_param INT) RETURNS VARCHAR(10)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE tiene_atrasos INT;
    
    SELECT COUNT(*)
    INTO tiene_atrasos
    FROM tarjeta t
    JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
    WHERE t.cliente_id = cliente_id_param 
    AND cm.estado_pago = 'pendiente' 
    AND cm.fecha_cuota < CURDATE();
    
    RETURN IF(tiene_atrasos > 0, 'SI', 'NO');
END; //
DELIMITER ;

 SELECT tiene_pagos_atrasados(1);

-- 11. Función para calcular la antigüedad de una tarjeta en días
DELIMITER //
DROP FUNCTION IF EXISTS antiguedad_tarjeta_dias //
CREATE FUNCTION antiguedad_tarjeta_dias(tarjeta_id_param INT) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE dias INT;
    
    SELECT DATEDIFF(CURDATE(), fecha_apertura)
    INTO dias
    FROM tarjeta
    WHERE tarjeta_id = tarjeta_id_param;
    
    RETURN IFNULL(dias, 0);
END; //
DELIMITER ;


SELECT antiguedad_tarjeta_dias(1);

-- 12. Función para obtener el número de cuotas pagadas de una tarjeta
DELIMITER //
DROP FUNCTION IF EXISTS cuotas_pagadas_tarjeta //
CREATE FUNCTION cuotas_pagadas_tarjeta(tarjeta_id_param INT) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE cuotas_pagadas INT;
    
    SELECT COUNT(*)
    INTO cuotas_pagadas
    FROM cuota_manejo
    WHERE tarjeta_id = tarjeta_id_param AND estado_pago = 'pagado';
    
    RETURN cuotas_pagadas;
END; //
DELIMITER ;

SELECT cuotas_pagadas_tarjeta(1);

-- 13. Función para calcular el porcentaje de pagos exitosos vs fallidos
DELIMITER //
DROP FUNCTION IF EXISTS porcentaje_exito_pagos //
CREATE FUNCTION porcentaje_exito_pagos() RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_pagos INT;
    DECLARE pagos_exitosos INT;
    DECLARE porcentaje DECIMAL(5,2);
    
    SELECT COUNT(*) INTO total_pagos FROM pago;
    SELECT COUNT(*) INTO pagos_exitosos FROM pago WHERE estado = 'exitoso';
    
    IF total_pagos > 0 THEN
        SET porcentaje = (pagos_exitosos * 100.0) / total_pagos;
    ELSE
        SET porcentaje = 0;
    END IF;
    
    RETURN porcentaje;
END; //
DELIMITER ;

 SELECT porcentaje_exito_pagos();

-- 14. Función para obtener el saldo total de todas las cuentas
DELIMITER //
DROP FUNCTION IF EXISTS saldo_total_banco //
CREATE FUNCTION saldo_total_banco() RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(12,2);
    
    SELECT SUM(saldo)
    INTO total
    FROM cuenta;
    
    RETURN IFNULL(total, 0);
END; //
DELIMITER ;

SELECT saldo_total_banco();

-- 15. Función para obtener el monto promedio de apertura por tipo de tarjeta
DELIMITER //
DROP FUNCTION IF EXISTS promedio_apertura_tipo //
CREATE FUNCTION promedio_apertura_tipo(tipo_nombre ENUM('joven', 'nomina', 'visa')) RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(10,2);
    
    SELECT AVG(t.monto_apertura)
    INTO promedio
    FROM tarjeta t
    JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
    WHERE tt.nombre = tipo_nombre;
    
    RETURN IFNULL(promedio, 0);
END; //
DELIMITER ;

SELECT promedio_apertura_tipo('visa');

-- 16. Función para verificar si un cliente tiene múltiples tarjetas
DELIMITER //
DROP FUNCTION IF EXISTS tiene_multiples_tarjetas //
CREATE FUNCTION tiene_multiples_tarjetas(cliente_id_param INT) RETURNS VARCHAR(10)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE num_tarjetas INT;
    
    SELECT COUNT(*)
    INTO num_tarjetas
    FROM tarjeta
    WHERE cliente_id = cliente_id_param;
    
    RETURN IF(num_tarjetas > 1, 'SI', 'NO');
END; //
DELIMITER ;

SELECT tiene_multiples_tarjetas(1);

-- 17. Función para calcular el total de ingresos por cuotas de manejo en un mes específico
DELIMITER //
DROP FUNCTION IF EXISTS ingresos_cuotas_mes //
CREATE FUNCTION ingresos_cuotas_mes(mes_año VARCHAR(7)) RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT IFNULL(SUM(cm.monto), 0)
    INTO total
    FROM cuota_manejo cm
    JOIN historial_pago hp ON cm.cuota_manejo_id = hp.cuota_manejo_id
    WHERE DATE_FORMAT(hp.fecha_pago, '%Y-%m') = mes_año;
    
    RETURN total;
END; //
DELIMITER ;

 SELECT ingresos_cuotas_mes('2025-03');

-- 18. Función para obtener el tipo de tarjeta más popular
DELIMITER //
DROP FUNCTION IF EXISTS tipo_tarjeta_mas_popular //
CREATE FUNCTION tipo_tarjeta_mas_popular() RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE tipo_popular VARCHAR(20);
    
    SELECT tt.nombre
    INTO tipo_popular
    FROM tipo_tarjeta tt
    JOIN tarjeta t ON tt.tipo_tarjeta_id = t.tipo_tarjeta_id
    GROUP BY tt.nombre
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    
    RETURN IFNULL(tipo_popular, 'N/A');
END; //
DELIMITER ;

SELECT tipo_tarjeta_mas_popular();

-- 19. Función para calcular el saldo promedio de tarjetas por cliente
DELIMITER //
DROP FUNCTION IF EXISTS saldo_promedio_tarjetas_cliente //
CREATE FUNCTION saldo_promedio_tarjetas_cliente(cliente_id_param INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(10,2);
    
    SELECT AVG(saldo)
    INTO promedio
    FROM tarjeta
    WHERE cliente_id = cliente_id_param;
    
    RETURN IFNULL(promedio, 0);
END; //
DELIMITER ;

SELECT saldo_promedio_tarjetas_cliente(1);

-- 20. Función para obtener el número total de clientes con cuentas activas
DELIMITER //
DROP FUNCTION IF EXISTS total_clientes_activos //
CREATE FUNCTION total_clientes_activos() RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT c.cliente_id)
    INTO total
    FROM cliente c
    JOIN cuenta cu ON c.cliente_id = cu.cliente_id
    WHERE cu.saldo > 0;
    
    RETURN total;
END; //
DELIMITER ;
SELECT total_clientes_activos();