-- Active: 1748981230048@@127.0.0.1@3307@banco_cl
USE banco;

--#1. Evento que actualiza cuotas vencidas
SET GLOBAL event_scheduler = ON;

DELIMITER $$
CREATE EVENT IF NOT EXISTS actualizar_cuotas
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
    BEGIN 
        UPDATE cuota_manejo
        SET estado_pago = 'vencido'
        WHERE fecha_cuota < CURDATE() 
        AND estado_pago = 'pendiente';
    END $$  
DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'actualizar_cuotas';

--#2. Registrar pagos 'fallidos' vencidos como ''fallidos definitivos'
USE banco;
DELIMITER $$
CREATE EVENT IF NOT EXISTS ev_actualizar_pagos_fallidos
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    UPDATE pago
    SET estado = 'fallido'
    WHERE fecha_pago < CURDATE() AND estado = 'pendiente';
END;
DELIMITER $$
SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'ev_actualizar_pagos_fallidos';

--#3. Evento de Generar log mensual de cuotas de manejo

DELIMITER $$
CREATE EVENT IF NOT EXISTS cuotas_mensuales
ON SCHEDULE EVERY 1 MONTH
  STARTS '2025-07-01 00:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Genera log de control de cuotas cada mes'
DO
BEGIN
  INSERT INTO historial_pago (descripcion, fecha_registro)
  VALUES ('Log mensual generado', NOW());
END $$
DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'cuotas_mensuales';


--#4. Evento de resetear saldos negativos 
DELIMITER $$
CREATE EVENT IF NOT EXISTS resetear_saldos
ON SCHEDULE EVERY 1 WEEK
  STARTS '2025-06-30 00:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Resetea saldos negativos en tarjetas a cero'
DO
BEGIN
  UPDATE tarjeta
  SET saldo = 0
  WHERE saldo < 0;
END $$
DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'resetear_saldos';

--#5. Desactivar tarjetas vencidas
DELIMITER $$
CREATE EVENT IF NOT EXISTS tarjetas_vencidas
ON SCHEDULE EVERY 1 DAY
  STARTS '2025-06-26 00:01:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Desactiva tarjetas vencidas'
DO
BEGIN
  UPDATE tarjeta
  SET estado = 'inactiva'
  WHERE fecha_vencimiento < CURDATE();
END $$
DELIMITER ;
SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'tarjetas_vencidas';

--#6. Cobrar cuota de manejo mensual
DELIMITER $$
CREATE EVENT IF NOT EXISTS cobro_cuota
ON SCHEDULE EVERY 1 MONTH
  STARTS '2025-07-01 05:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Cobra cuota de manejo a todas las tarjetas activas'
DO
BEGIN
  INSERT INTO cuota_manejo (id_tarjeta, valor, fecha_cuota, estado_pago)
  SELECT id_tarjeta, 15000, CURDATE(), 'pendiente'
  FROM tarjeta
  WHERE estado = 'activa';
END $$
DELIMITER ;
SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'cobro_cuota';


--#7. Registrar respaldo de pagos
DELIMITER $$
CREATE EVENT IF NOT EXISTS respaldo_pagos
ON SCHEDULE EVERY 1 DAY
  STARTS '2025-06-26 02:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Copia los pagos realizados a un log'
DO
BEGIN
  INSERT INTO historial_pago (cuota_manejo_id, fecha_pago)
  SELECT CONCAT('Pago ID ', id_pago, ' respaldado'), NOW()
  FROM pago
  WHERE estado = 'realizado' AND fecha_pago = CURDATE();
END $$
DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'respaldo_pagos';

--#8. Simular alerta por correo para tarjetas con saldo bajo
DELIMITER $$
CREATE EVENT IF NOT EXISTS alerta_tarjetas
ON SCHEDULE EVERY 1 DAY
  STARTS '2025-06-26 08:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Simula alerta por correo para tarjetas en rojo'
DO
BEGIN
  INSERT INTO historial_pago (fecha_registro)
  SELECT CONCAT('Alerta: tarjeta ', id_tarjeta, ' con saldo < 1000'), NOW()
  FROM tarjeta
  WHERE saldo < 1000;
END $$
DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'alerta_tarjetas';

