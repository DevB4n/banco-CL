use banco;

--CONSULTAS BASICAS

select T.tarjeta_id, T.numero_tarjeta,  SUM(C.monto) as total from tarjeta T 
join cuota_manejo C
on T.tarjeta_id = C.tarjeta_id
group by T.tarjeta_id ;


select c.nombre, historial.* 
from cliente c
join tarjeta t 
on c.cliente_id = t.cliente_id 
join historial_pago historial 
on t.tarjeta_id = historial.tarjeta_id
where c.nombre =  'Mateo';


SELECT cm.*
FROM cuota_manejo cm 
WHERE MONTH(cm.fecha_cuota) = 3;

select c.nombre, tt.descuento
from tarjeta t
join cliente c 
on t.cliente_id = c.cliente_id
join cuota_manejo cm 
on t.tarjeta_id = cm.tarjeta_id
join tipo_tarjeta tt
on t.tipo_tarjeta_id = tt.tipo_tarjeta_id
where tt.descuento = '15.00'
group by c.nombre;


select cm.fecha_cuota, t.tarjeta_id, t.numero_tarjeta
from cuota_manejo cm
join tarjeta t
on cm.tarjeta_id = t.tarjeta_id
join historial_pago historial
on t.tarjeta_id = historial.tarjeta_id
where month (cm.fecha_cuota) = 3;


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