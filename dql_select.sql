use banco;

--CONSULTAS BASICAS

--#1 Imprime tarjeta_id, numero_tarjeta y total.
SELECT T.tarjeta_id, T.numero_tarjeta,  SUM(C.monto) as total from tarjeta T 
JOIN cuota_manejo C
ON T.tarjeta_id = C.tarjeta_id
GROUP BY T.tarjeta_id ;

--#2 Imprime nombre, historial_id, tarjeta_id, cuota_manejo_id, pago_id y fecha_pago de Mateo.
SELECT c.nombre, historial.* 
FROM cliente c
JOIN tarjeta t 
ON c.cliente_id = t.cliente_id 
JOIN historial_pago historial 
ON t.tarjeta_id = historial.tarjeta_id
WHERE c.nombre =  'Mateo';

--#3. Imprime cuota_manejo_id, tarjeta_id, fecha_cuota, monto y estado_pago de las cuotas pagadas.
SELECT cm.*
FROM cuota_manejo cm 
WHERE MONTH(cm.fecha_cuota) = 3;

--#4. Imprime nombre y el descuento de las tarjetas con descuento del 15.00.
SELECT c.nombre, tt.descuento
FROM tarjeta t
JOIN cliente c 
ON t.cliente_id = c.cliente_id
JOIN cuota_manejo cm 
ON t.tarjeta_id = cm.tarjeta_id
JOIN tipo_tarjeta tt
ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
WHERE tt.descuento = '15.00'
GROUP BY c.nombre;

--#5. Imprime fecha_cuota, tarjeta_id y número_tarjeta
SELECT cm.fecha_cuota, t.tarjeta_id, t.numero_tarjeta
FROM cuota_manejo cm
JOIN tarjeta t
ON cm.tarjeta_id = t.tarjeta_id
JOIN historial_pago historial
ON t.tarjeta_id = historial.tarjeta_id
WHERE month (cm.fecha_cuota) = 3;

--#6. Imprime la tarjeta_id, numero_tarjeta y total de la tarjeta con id 1.
SELECT T.tarjeta_id, T.numero_tarjeta,  SUM(C.monto) as total from tarjeta T 
JOIN cuota_manejo C
ON T.tarjeta_id = C.tarjeta_id
WHERE T.tarjeta_id = '1';

--#7. Imprime el nombre, numero_tarjeta y total de todo lo de usuarios
SELECT * FROM cliente;

--8. Imprime el los clientes que tienen correo electrónico de gmail.
SELECT * FROM cliente WHERE correo_electronico LIKE '%gmail.com';

--#9. Imrpime cuantos clientes hay registrados.
SELECT COUNT(*) AS total_clientes FROM cliente;

--#10. Obtiene los primeros 5 clientes ordenados por cliente_id de forma ascendente.
SELECT * FROM cliente ORDER BY cliente_id ASC LIMIT 5;

--#11. Imprime el nombre del cliente y el número de cuenta.
SELECT c.nombre, cu.numero_cuenta
FROM cliente c 
JOIN cuenta cu
ON c.cliente_id = cu.cliente_id
WHERE c.cliente_id = 1;

--12. Muestra los clientes con el total de cuotas por deber.
SELECT c.nombre AS nombre_cliente, SUM(cm.monto) AS total_pendiente 
FROM cliente c
JOIN tarjeta t 
ON c.cliente_id = t.cliente_id
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
WHERE cm.estado_pago = 'pendiente'
GROUP BY c.nombre;

--#13. Número de pagos realizados por cada cliente.
SELECT c.nombre, COUNT(h.pago_id) AS total_pagos
FROM cliente c
JOIN tarjeta t 
ON c.cliente_id = t.cliente_id
JOIN historial_pago h ON t.tarjeta_id = h.tarjeta_id
GROUP BY c.nombre;

--#14. Muestra los clientes con más de una tarjeta registrada.
SELECT c.nombre, COUNT(t.tarjeta_id) AS total_tarjetas
FROM cliente c
JOIN tarjeta t ON c.cliente_id = t.cliente_id
GROUP BY c.nombre
HAVING COUNT(t.tarjeta_id) > 1;

--#15. Imprime el cliente que no tenga cuenta registrada.
SELECT c.nombre
FROM cliente c
LEFT JOIN cuenta cu ON c.cliente_id = cu.cliente_id
WHERE cu.cuenta_id IS NULL;

--#16. Muestra el número de tarjeta y el total pagado de las tarjetas que tienen cuotas pagadas.
SELECT t.numero_tarjeta, SUM(cm.monto) AS total_pagado
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
WHERE cm.estado_pago = 'pagado'
GROUP BY t.numero_tarjeta;

--#17. ¿Cuántas cuotas de manejo hay por tarjeta?
SELECT t.numero_tarjeta, COUNT(cm.cuota_manejo_id) AS total_cuotas
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
GROUP BY t.numero_tarjeta;

--#18.  Total de clientes por tipo de tarjeta.
SELECT tt.nombre, COUNT(DISTINCT c.cliente_id) AS total_clientes
FROM cliente c
JOIN tarjeta t ON c.cliente_id = t.cliente_id
JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
GROUP BY tt.nombre;

--#19. Muestra todas las cuotas vencidas antes de la fecha actual.
SELECT cm.*
FROM cuota_manejo cm
WHERE cm.fecha_cuota < CURDATE() AND cm.estado_pago = 'pendiente';


--#20. Clientes a los cuales su nombre inicia por la letra 'S'.
SELECT *
FROM cliente
WHERE nombre LIKE 'S%';

--#21. Muestra las tarjetas sin historial de pagos.
SELECT t.numero_tarjeta
FROM tarjeta t
LEFT JOIN historial_pago h 
ON t.tarjeta_id = h.tarjeta_id
WHERE h.pago_id IS NULL;


--#22. Muestra el número de tarjeta y suma los valores de monto de todas las cuotas que sean mayores o iguales a 1000.
SELECT t.numero_tarjeta, SUM(cm.monto) AS total_cuotas
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
WHERE cm.monto >= 1000
GROUP BY t.numero_tarjeta;


--23. Muestra las tarjetas y cuántas veces han sido pagadas.
SELECT t.numero_tarjeta, COUNT(cm.cuota_manejo_id) AS cuotas_pagadas
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
WHERE cm.estado_pago = 'pagado'
GROUP BY t.numero_tarjeta;

--#24. Clientes con cuotas pagadas en abril
SELECT t.numero_tarjeta
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
WHERE cm.estado_pago = 'pagado' AND MONTH(cm.fecha_cuota) = 4;

--#25. Total de pagos registrados en el historial de pagos.
SELECT COUNT(*) AS total_pagos
FROM historial_pago;

--#26. Muestra los clientes con tarjetas tipo 'Joven'.
SELECT DISTINCT c.nombre
FROM cliente c
JOIN tarjeta t ON c.cliente_id = t.cliente_id
JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
WHERE tt.nombre = 'Joven';

--#27. Muestra los clientes cuyo descuento es menor a 10.
SELECT t.numero_tarjeta, tt.descuento
FROM tarjeta t
JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
WHERE tt.descuento < 10;

--#28. Muestra los clientes cuyo descuento es mayor a 13.
SELECT t.numero_tarjeta, tt.descuento
FROM tarjeta t
JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
WHERE tt.descuento > 13;

--#29. Muestra la fecha de la primera cuota de cada tarjeta.
SELECT t.numero_tarjeta, MIN(cm.fecha_cuota) AS primera_cuota
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
GROUP BY t.numero_tarjeta;

--30. Muestra tarjetas con cuotas pendientes de pago.
SELECT DISTINCT t.numero_tarjeta
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
WHERE cm.estado_pago = 'pendiente';

--#31. Muestra las tarjetas con el monto promedio de sus cuotas.
SELECT t.numero_tarjeta, AVG(cm.monto) AS promedio
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
GROUP BY t.numero_tarjeta;

--#32. Muestra el pago más alto registrado
SELECT * 
FROM cuota_manejo 
WHERE monto = (
    SELECT MAX(monto) FROM cuota_manejo
);
ORDER BY monto DESC 
LIMIT 1;

--#33. Muestra los nombres de los clientes ordenados de manera DESC.
SELECT * FROM cliente
ORDER BY nombre DESC;

--#34. Muestra los nombres de los clientes ordenados de manera ASC.
SELECT * FROM cliente
ORDER BY nombre ASC;

--#35. Muestra los pagos hechos por la tarjeta con número '4000123410010010'.
SELECT h.*
FROM historial_pago h
JOIN tarjeta t ON h.tarjeta_id = t.tarjeta_id
WHERE t.numero_tarjeta = '4000123410010010';

--#36. Muestra los clientes cuyo nombre tiene exactamente 5 caracteres.
SELECT * FROM cliente
WHERE LENGTH(nombre) = 5;

--#37. Muestra todas las cuentas registradas en febrero.
SELECT *
FROM tarjeta
WHERE MONTH(fecha_apertura) = 2;

--#38. Mostrar las cuotas cuyo monto es múltiplo de 500.
SELECT cm.cuota_manejo_id, cm.monto
FROM cuota_manejo cm
WHERE monto % 500 = 0;

--#39. Muestra el nombre de los clientes que contengan la letra 'v'.
SELECT * FROM cliente
WHERE nombre LIKE '%v%';

--#40. Se muestran los 3 clientes más recientes registrados limitando el resultado a 3.
SELECT * FROM cliente
ORDER BY cliente_id DESC
LIMIT 3;

--#41. Muestra el total de cuotas pagadas.
SELECT * 
FROM cuota_manejo 
WHERE estado_pago = 'pagado';

--#42. Muestra los pagos realizados después del 1 de marzo de 2024.
SELECT * 
FROM pago 
WHERE fecha_pago > '2024-03-01';

--#43. Muestra los clientes con tarjetas tipo 'Nomina'.
SELECT DISTINCT c.nombre
FROM cliente c
JOIN tarjeta t ON c.cliente_id = t.cliente_id
JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
WHERE tt.nombre = 'Nomina';

--#44. Muestra los clientes con tarjetas tipo 'Visa'.
SELECT DISTINCT c.nombre
FROM cliente c
JOIN tarjeta t ON c.cliente_id = t.cliente_id
JOIN tipo_tarjeta tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
WHERE tt.nombre = 'Visa';

--#45. Clientes con cuotas pagadas en mayo
SELECT t.numero_tarjeta
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
WHERE cm.estado_pago = 'pagado' AND MONTH(cm.fecha_cuota) = 5;;


--46. Imprime el los clientes que tienen correo electrónico de yahoo.
SELECT * FROM cliente WHERE correo_electronico LIKE '%yahoo.com';


--47. Imprime el los clientes que tienen correo electrónico de outlook.
SELECT * FROM cliente WHERE correo_electronico LIKE '%outlook.com';

--48. Imprime el cliente cuyo apellido es 'Torres'.
SELECT * FROM cliente WHERE apellido = 'Torres';

--#49. Se muestran los 5 clientes más recientes registrados limitando el resultado a 5.
SELECT * FROM cliente
ORDER BY cliente_id ASC
LIMIT 5;

--#50. Muestra las tarjetas cuyo total de cuotas es mayor a 3000
SELECT t.numero_tarjeta, SUM(cm.monto) AS total_cuotas
FROM tarjeta t
JOIN cuota_manejo cm ON t.tarjeta_id = cm.tarjeta_id
GROUP BY t.numero_tarjeta
HAVING total_cuotas > 3000;



--CONSULTAS AVANZADAS

 USE banco;

SELECT c.nombre AS nombre,MAX(h.fecha_pago) AS ultimo_pago
FROM historial_pago AS h
JOIN tarjeta AS t ON h.tarjeta_id = t.tarjeta_id
JOIN cliente AS c ON t.cliente_id = c.cliente_id
WHERE h.fecha_pago < NOW() - INTERVAL 3 MONTH
GROUP BY c.nombre
ORDER BY c.nombre ASC;

SELECT tt.nombre,AVG(monto) AS promedio_monto
FROM cuota_manejo AS c
JOIN tarjeta AS t ON c.tarjeta_id = t.tarjeta_id 
JOIN tipo_tarjeta AS tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
WHERE c.fecha_cuota >= '2025-04-01'
GROUP BY tt.nombre
;

SELECT tt.nombre AS tarjeta, COUNT(h.tarjeta_id) AS cantidad_descuentos
FROM historial_pago AS h
JOIN tarjeta AS t ON h.tarjeta_id = t.tarjeta_id
JOIN tipo_tarjeta AS tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
WHERE h.fecha_pago > NOW() - INTERVAL 1 YEAR
GROUP BY tarjeta;

SELECT  tt.nombre AS tipo_tarjeta, t.monto_apertura
FROM tarjeta AS t
JOIN tipo_tarjeta AS tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
WHERE t.monto_apertura = (
    SELECT MAX(monto_apertura) FROM tarjeta
)
   OR t.monto_apertura = (
    SELECT MIN(monto_apertura) FROM tarjeta
);

SELECT tt.nombre AS tarjeta, COUNT(h.tarjeta_id) AS pagos_realizados
FROM historial_pago AS h
JOIN tarjeta AS t ON h.tarjeta_id = t.tarjeta_id
JOIN tipo_tarjeta AS tt ON t.tipo_tarjeta_id = tt.tipo_tarjeta_id
GROUP BY tarjeta;