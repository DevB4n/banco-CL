use banco;

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


