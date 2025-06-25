-- Active: 1750881178308@@127.0.0.1@3307@banco
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

--#9. Comisión diaria de $200 a cuentas corrientes
DELIMITER $$ 
CREATE EVENT IF NOT EXISTS comision_diaria
ON SCHEDULE EVERY 1 DAY
  STARTS'2025-07-01 02:00:00'
ON COMPLETION PRESERVE 
ENABLE
COMMENT 'Aplica una comisión diaria de $200 a cuentas corrientes'
DO
BEGIN 
  UPDATE cuenta
  SET saldo = saldo - 200
  WHERE cuenta = 'corriente';
END $$

DELIMITER;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'comision_diaria'


--#10. Bonificación mensual por saldo alto
DELIMITER $$
CREATE EVENT IF NOT EXISTS bonificacion_mensual
ON SCHEDULE EVERY 1 MONTH
  STARTS '2025-07-31 23:59:00'
ON COMPLETION PRESERVE 
ENABLE
COMMENT 'Bonifica a quienes tienen más de cierta cantidad de dinero'
DO
BEGIN
  UPDATE cuenta
  SET saldo = saldo + 5000
  WHERE saldo > 1000000;
END $$

DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'bonificacion_mensual' 

--#11. Eliminar clientes que no tengan ninguna cuenta asociada
DELIMITER $$
CREATE EVENT IF NOT EXISTS eliminar_clientes
ON SCHEDULE EVERY 30 DAY
  STARTS '2026-12-02 18:30:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Elimina clientes que no tengan ninguna cuenta asociada'
DO
BEGIN 
  DELETE FROM cliente
  WHERE cliente_id NOT IN (SELECT cliente_id FROM cuenta);
END $$
DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'eliminar_clientes'

--#12. Para registrar intereses en las cuentas de AHORRO (1% mensual)
DELIMITER $$
CREATE EVENT IF NOT EXISTS intereses
ON SCHEDULE EVERY 1 MONTH 
  STARTS '2025-05-22 15:00:00'
ON COMPLETION PRESERVE 
ENABLE
COMMENT 'Aplica intereses a las cuentas de ahorro'
DO 
BEGIN
  UPDATE cuenta
  SET saldo = saldo + (saldo * 0.01)
  WHERE tipo_cuenta = 'ahorros';
END $$

DELIMITER $$

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'intereses'

--#13. Dar bono a nuevos clientes 
DELIMITER $$

CREATE EVENT IF NOT EXISTS bono_nuevos_clientes
ON SCHEDULE EVERY 1 MONTH
  STARTS '2025-08-01 09:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Bono a clientes que ingresaron este mes'
DO
BEGIN
  UPDATE cuenta
  SET saldo = saldo + 5000
  WHERE cliente_id IN (
    SELECT cliente_id FROM cliente
    WHERE MONTH(fecha_registro) = MONTH(CURDATE())
      AND YEAR(fecha_registro) = YEAR(CURDATE())
  );
END $$

DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'bono_nuevos_clientes'

--#14. Limpia cuentas que no tienen saldo ni actividad

DELIMITER $$

CREATE EVENT IF NOT EXISTS eliminar_cuentas_inutiles
ON SCHEDULE EVERY 1 MONTH
  STARTS '2025-07-30 06:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Limpia cuentas que no tienen saldo ni actividad'
DO
BEGIN
  DELETE FROM cuenta
  WHERE saldo = 0
    AND estado_pagado = 'pendiente'
    AND fecha_ultimo_movimiento < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END $$

DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'eliminar_cuentas_inutiles'

--#15. Detectar movimientos SUSPICIOUS 
DELIMITER $$

CREATE EVENT IF NOT EXISTS movimientos_sospechosos
ON SCHEDULE EVERY 1 DAY
  STARTS '2025-07-01 02:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Marca cuentas con retiros sospechosos'
DO
BEGIN
  UPDATE cuenta
  SET estado = 'sospechosa'
  WHERE cuenta_id IN (
    SELECT cuenta_id FROM tarjeta
    WHERE monto > 5000000
      AND fecha = CURDATE()
  );
END $$

DELIMITER ;
SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'movimientos_sospechosos'

--#16. Renueva la fecha de vencmineto de tarjetas inactivas con la variable de fecha_vencimiento

DELIMITER $$

CREATE EVENT IF NOT EXISTS renovar_tarjetas
ON SCHEDULE EVERY 1 YEAR
  STARTS '2025-12-01 10:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Renueva fecha de vencimiento de tarjetas activas'
DO
BEGIN
  UPDATE tarjeta
  SET fecha_vencimiento = DATE_ADD(CURDATE(), INTERVAL 4 YEAR);

END $$

DELIMITER ;
SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'renovar_tarjetas'


--#17. Aumenta el limite del credito

DELIMITER $$

CREATE EVENT IF NOT EXISTS aumentar_limite_credito
ON SCHEDULE EVERY 3 MONTH
  STARTS '2025-07-01 07:00:00'
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Aumenta límite a clientes sin moras'
DO
BEGIN
  UPDATE tarjeta
  SET limite_credito = limite_credito + 100000
  WHERE cliente_id IN (
    SELECT cliente_id FROM cliente
    WHERE estado_pago = 'pagado'
    GROUP BY cliente_id
    HAVING COUNT(*) >= 3
  );
END $$

DELIMITER ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'aumentar_limite_credito'

--#18.