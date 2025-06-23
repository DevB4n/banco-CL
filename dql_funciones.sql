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


