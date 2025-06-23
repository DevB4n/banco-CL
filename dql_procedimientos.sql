USE banco;

--#1. Registrar una nueva cuota de manejo calculando automáticamente el descuento.
DROP PROCEDURE IF EXISTS registrar_cuota_manejo;

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