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

