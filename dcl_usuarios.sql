CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'administrador';
CREATE USER 'operador_pagos'@'localhost' IDENTIFIED BY 'operador_pagos';
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'gerente';
CREATE USER 'consultor_tarjetas'@'localhost' IDENTIFIED BY 'consultor_tarjetas';
CREATE USER 'auditor'@'localhost' IDENTIFIED BY 'auditor';

-- GRANTS ADMINISTRADOR

GRANT ALL PRIVILEGES ON * . * TO 'administrador'@'localhost';
FLUSH PRIVILEGES;

--GRANTS OPERADOR_PAGOS

GRANT ALL PRIVILEGES ON banco . pago TO 'operador_pagos'@'localhost';
GRANT ALL PRIVILEGES ON banco . pago_tarjeta TO 'operador_pagos'@'localhost';
GRANT ALL PRIVILEGES ON banco . historial_pago TO 'operador_pagos'@'localhost';
FLUSH PRIVILEGES;

--GRANTS GERENTE

GRANT ALL PRIVILEGES ON banco . historial_pago TO 'gerente'@'localhost';
GRANT ALL PRIVILEGES ON banco . tarjeta TO 'gerente'@'localhost';
FLUSH PRIVILEGES;

--GRANTS CONSULTOR_TARJETAS
GRANT SELECT ON banco . tarjeta TO 'consultor_tarjetas'@'localhost';
GRANT SELECT ON banco . tipo_tarjeta TO 'consultor_tarjetas'@'localhost';
GRANT SELECT ON banco . cuota_manejo TO 'consultor_tarjetas'@'localhost';
FLUSH PRIVILEGES;

--GRANTS AUDITOR

GRANT SELECT ON banco . historial_pago TO 'auditor'@'localhost';
FLUSH PRIVILEGES;