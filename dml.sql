-- Active: 1748981230048@@127.0.0.1@3307@banco_cl
use banco;
-- cliente
INSERT INTO cliente (identificacion, nombre, apellido, celular, correo_electronico) values
('1024567890', 'Camila', 'Ramírez', '3114567890', 'camila.ramirez@gmail.com'),
('1032456789', 'Juan', 'Martínez', '3123456789', 'juan.martinez@hotmail.com'),
('1045678912', 'Valentina', 'Gómez', '3102345678', 'valen.gomez@yahoo.com'),
('1056789123', 'Esteban', 'Ruiz', '3134567890', 'estebanruiz@outlook.com'),
('1067891234', 'Daniela', 'López', '3119876543', 'daniela.lopez@gmail.com'),
('1078912345', 'Mateo', 'Torres', '3124567890', 'mateo.torres@hotmail.com'),
('1089123456', 'Laura', 'Jiménez', '3139876543', 'laura.jimenez@icloud.com'),
('1091234567', 'Santiago', 'Moreno', '3108765432', 's.moreno@gmail.com'),
('1102345678', 'Isabella', 'Hernández', '3112345678', 'isahernandez@live.com'),
('1113456789', 'Tomás', 'Castaño', '3129876543', 'tomas.castano@yahoo.com'),
('1124567890', 'Sofía', 'Castillo', '3133456789', 'sofia.castillo@gmail.com'),
('1135678901', 'Felipe', 'Ortiz', '3101234567', 'felipeo@protonmail.com'),
('1146789012', 'Mariana', 'Peña', '3117654321', 'mariana.pena@hotmail.com'),
('1157890123', 'Andrés', 'Rojas', '3125432167', 'andres.rojas@live.com'),
('1168901234', 'Luciana', 'Córdoba', '3102341987', 'luciana.cordoba@gmail.com'),
('1179012345', 'Sebastián', 'Sánchez', '3132345678', 'sebas.sanchez@outlook.com'),
('1180123456', 'Juliana', 'Vargas', '3103456789', 'juliana.v@gmail.com'),
('1191234567', 'Cristian', 'Mejía', '3114561234', 'cristianmejia@hotmail.com'),
('1202345678', 'Emma', 'Chávez', '3122341234', 'emma.chavez@icloud.com'),
('1213456789', 'Nicolás', 'González', '3131234321', 'nicolasgonzalez@gmail.com'),
('1224567890', 'Antonia', 'Delgado', '3107654321', 'antonia.delgado@yahoo.com'),
('1235678901', 'Samuel', 'Navarro', '3115432167', 'samuel.navarro@live.com'),
('1246789012', 'Renata', 'Pérez', '3124567890', 'renata.perez@gmail.com'),
('1257890123', 'David', 'Romero', '3139876543', 'david.romero@hotmail.com'),
('1268901234', 'María José', 'Valencia', '3102348765', 'mjvalencia@gmail.com'),
('1279012345', 'Ángel', 'Silva', '3119871234', 'angel.silva@yahoo.com'),
('1280123456', 'Salomé', 'Nieto', '3123450912', 'salome.nieto@outlook.com'),
('1291234567', 'Joaquín', 'Muñoz', '3138765432', 'joaquin.munoz@gmail.com'),
('1302345678', 'Abril', 'Mendoza', '3102347856', 'abril.mendoza@live.com'),
('1313456789', 'Gabriel', 'Patiño', '3112346789', 'gabriel.patino@gmail.com'),
('1324567890', 'Manuela', 'Salazar', '3129873210', 'manuela.salazar@hotmail.com');

-- cuenta
INSERT INTO cuenta (numero_cuenta, tipo_cuenta, saldo, cliente_id) VALUES
('1001000001', 'ahorros', 250000.00, 1),
('1001000002', 'corriente', 500000.00, 2),
('1001000003', 'ahorros', 180000.00, 3),
('1001000004', 'ahorros', 320000.00, 4),
('1001000005', 'corriente', 150000.00, 5),
('1001000006', 'ahorros', 400000.00, 6),
('1001000007', 'corriente', 850000.00, 7),
('1001000008', 'ahorros', 120000.00, 8),
('1001000009', 'ahorros', 95000.00, 9),
('1001000010', 'corriente', 780000.00, 10),
('1001000011', 'ahorros', 230000.00, 11),
('1001000012', 'corriente', 410000.00, 12),
('1001000013', 'ahorros', 99000.00, 13),
('1001000014', 'corriente', 270000.00, 14),
('1001000015', 'ahorros', 350000.00, 15),
('1001000016', 'corriente', 610000.00, 16),
('1001000017', 'ahorros', 290000.00, 17),
('1001000018', 'corriente', 700000.00, 18),
('1001000019', 'ahorros', 300000.00, 19),
('1001000020', 'corriente', 660000.00, 20),
('1001000021', 'ahorros', 210000.00, 21),
('1001000022', 'corriente', 540000.00, 22),
('1001000023', 'ahorros', 330000.00, 23),
('1001000024', 'corriente', 125000.00, 24),
('1001000025', 'ahorros', 275000.00, 25),
('1001000026', 'corriente', 150000.00, 26),
('1001000027', 'ahorros', 87000.00, 27),
('1001000028', 'corriente', 430000.00, 28),
('1001000029', 'ahorros', 210000.00, 29),
('1001000030', 'corriente', 395000.00, 30);

-- tipo de tarjeta

INSERT INTO tipo_tarjeta (nombre, descuento) VALUES
('joven', 15.00),     -- Descuento mayor para fomentar uso juvenil
('nomina', 10.00),    -- Descuento estándar para cuentas empresariales
('visa', 5.00);       -- Tarjeta comercial con menor descuento

-- tarjetas

INSERT INTO tarjeta (numero_tarjeta, tipo_tarjeta_id, cliente_id, cuenta_id, fecha_apertura, monto_apertura, saldo) VALUES
('4000123410010001', 1, 1, 1, '2024-01-15', 300000.00, 300000.00),
('4000123410010002', 2, 2, 2, '2023-11-22', 500000.00, 500000.00),
('4000123410010003', 3, 3, 3, '2023-07-10', 700000.00, 700000.00),
('4000123410010004', 1, 4, 4, '2024-03-01', 250000.00, 250000.00),
('4000123410010005', 2, 5, 5, '2023-10-05', 450000.00, 450000.00),
('4000123410010006', 3, 6, 6, '2024-04-12', 600000.00, 600000.00),
('4000123410010007', 1, 7, 7, '2023-09-08', 200000.00, 200000.00),
('4000123410010008', 2, 8, 8, '2024-01-30', 480000.00, 480000.00),
('4000123410010009', 3, 9, 9, '2024-05-20', 650000.00, 650000.00),
('4000123410010010', 1, 10, 10, '2023-12-12', 220000.00, 220000.00),
('4000123410010011', 2, 11, 11, '2024-02-18', 510000.00, 510000.00),
('4000123410010012', 3, 12, 12, '2023-08-25', 750000.00, 750000.00),
('4000123410010013', 1, 13, 13, '2024-03-17', 300000.00, 300000.00),
('4000123410010014', 2, 14, 14, '2024-01-05', 470000.00, 470000.00),
('4000123410010015', 3, 15, 15, '2023-11-30', 720000.00, 720000.00),
('4000123410010016', 1, 16, 16, '2024-04-02', 280000.00, 280000.00),
('4000123410010017', 2, 17, 17, '2023-09-21', 500000.00, 500000.00),
('4000123410010018', 3, 18, 18, '2024-05-11', 690000.00, 690000.00),
('4000123410010019', 1, 19, 19, '2024-01-08', 260000.00, 260000.00),
('4000123410010020', 2, 20, 20, '2023-10-18', 520000.00, 520000.00),
('4000123410010021', 3, 21, 21, '2024-03-25', 710000.00, 710000.00),
('4000123410010022', 1, 22, 22, '2023-12-01', 230000.00, 230000.00),
('4000123410010023', 2, 23, 23, '2024-02-05', 490000.00, 490000.00),
('4000123410010024', 3, 24, 24, '2023-09-14', 640000.00, 640000.00),
('4000123410010025', 1, 25, 25, '2024-01-22', 310000.00, 310000.00),
('4000123410010026', 2, 26, 26, '2023-11-11', 455000.00, 455000.00),
('4000123410010027', 3, 27, 27, '2024-04-08', 680000.00, 680000.00),
('4000123410010028', 1, 28, 28, '2023-10-27', 290000.00, 290000.00),
('4000123410010029', 2, 29, 29, '2024-03-14', 495000.00, 495000.00),
('4000123410010030', 3, 30, 30, '2023-08-03', 710000.00, 710000.00);

-- cuota manejo

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 1
(1, '2025-03-01', 6000.00, 'pagado'),
(1, '2025-04-01', 6000.00, 'pendiente'),
(1, '2025-05-01', 6000.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 2
(2, '2025-03-01', 10000.00, 'pagado'),
(2, '2025-04-01', 10000.00, 'pagado'),
(2, '2025-05-01', 10000.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 3
(3, '2025-03-01', 14000.00, 'pendiente'),
(3, '2025-04-01', 14000.00, 'pendiente'),
(3, '2025-05-01', 14000.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 4
(4, '2025-03-01', 5000.00, 'pagado'),
(4, '2025-04-01', 5000.00, 'pagado'),
(4, '2025-05-01', 5000.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 5
(5, '2025-03-01', 9000.00, 'pagado'),
(5, '2025-04-01', 9000.00, 'pendiente'),
(5, '2025-05-01', 9000.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 6
(6, '2025-03-01', 12000.00, 'pendiente'),
(6, '2025-04-01', 12000.00, 'pendiente'),
(6, '2025-05-01', 12000.00, 'pagado');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 7
(7, '2025-03-01', 4000.00, 'pagado'),
(7, '2025-04-01', 4000.00, 'pagado'),
(7, '2025-05-01', 4000.00, 'pagado');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 8
(8, '2025-03-01', 9600.00, 'pendiente'),
(8, '2025-04-01', 9600.00, 'pendiente'),
(8, '2025-05-01', 9600.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 9
(9, '2025-03-01', 13000.00, 'pagado'),
(9, '2025-04-01', 13000.00, 'pendiente'),
(9, '2025-05-01', 13000.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 10
(10, '2025-03-01', 4400.00, 'pagado'),
(10, '2025-04-01', 4400.00, 'pagado'),
(10, '2025-05-01', 4400.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 11
(11, '2025-03-01', 10200.00, 'pagado'),
(11, '2025-04-01', 10200.00, 'pendiente'),
(11, '2025-05-01', 10200.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 12
(12, '2025-03-01', 15000.00, 'pendiente'),
(12, '2025-04-01', 15000.00, 'pendiente'),
(12, '2025-05-01', 15000.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 13
(13, '2025-03-01', 6000.00, 'pagado'),
(13, '2025-04-01', 6000.00, 'pagado'),
(13, '2025-05-01', 6000.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 14
(14, '2025-03-01', 9400.00, 'pendiente'),
(14, '2025-04-01', 9400.00, 'pendiente'),
(14, '2025-05-01', 9400.00, 'pagado');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 15
(15, '2025-03-01', 14400.00, 'pendiente'),
(15, '2025-04-01', 14400.00, 'pendiente'),
(15, '2025-05-01', 14400.00, 'pagado');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 16
(16, '2025-03-01', 5600.00, 'pagado'),
(16, '2025-04-01', 5600.00, 'pendiente'),
(16, '2025-05-01', 5600.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 17
(17, '2025-03-01', 10000.00, 'pagado'),
(17, '2025-04-01', 10000.00, 'pagado'),
(17, '2025-05-01', 10000.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 18
(18, '2025-03-01', 13800.00, 'pendiente'),
(18, '2025-04-01', 13800.00, 'pendiente'),
(18, '2025-05-01', 13800.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 19
(19, '2025-03-01', 5200.00, 'pagado'),
(19, '2025-04-01', 5200.00, 'pendiente'),
(19, '2025-05-01', 5200.00, 'pagado');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 20
(20, '2025-03-01', 10400.00, 'pagado'),
(20, '2025-04-01', 10400.00, 'pendiente'),
(20, '2025-05-01', 10400.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 21
(21, '2025-03-01', 14200.00, 'pendiente'),
(21, '2025-04-01', 14200.00, 'pendiente'),
(21, '2025-05-01', 14200.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 22
(22, '2025-03-01', 4600.00, 'pagado'),
(22, '2025-04-01', 4600.00, 'pagado'),
(22, '2025-05-01', 4600.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 23
(23, '2025-03-01', 9800.00, 'pendiente'),
(23, '2025-04-01', 9800.00, 'pendiente'),
(23, '2025-05-01', 9800.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 24
(24, '2025-03-01', 12800.00, 'pendiente'),
(24, '2025-04-01', 12800.00, 'pagado'),
(24, '2025-05-01', 12800.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 25
(25, '2025-03-01', 6200.00, 'pagado'),
(25, '2025-04-01', 6200.00, 'pagado'),
(25, '2025-05-01', 6200.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 26
(26, '2025-03-01', 9100.00, 'pendiente'),
(26, '2025-04-01', 9100.00, 'pendiente'),
(26, '2025-05-01', 9100.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 27
(27, '2025-03-01', 13600.00, 'pagado'),
(27, '2025-04-01', 13600.00, 'pendiente'),
(27, '2025-05-01', 13600.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 28
(28, '2025-03-01', 5800.00, 'pendiente'),
(28, '2025-04-01', 5800.00, 'pendiente'),
(28, '2025-05-01', 5800.00, 'pagado');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 29
(29, '2025-03-01', 9900.00, 'pagado'),
(29, '2025-04-01', 9900.00, 'pendiente'),
(29, '2025-05-01', 9900.00, 'pendiente');

INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Tarjeta 30
(30, '2025-03-01', 14200.00, 'pendiente'),
(30, '2025-04-01', 14200.00, 'pagado'),
(30, '2025-05-01', 14200.00, 'pendiente');



-- pagos

INSERT INTO pago (fecha_pago, fecha_maxima_pago, monto_pagado, estado) VALUES
('2025-02-28 10:15:00', '2025-03-05', 6000.00, 'exitoso'),
('2025-03-28 09:20:00', '2025-04-05', 10000.00, 'exitoso'),
('2025-04-01 14:45:00', '2025-05-05', 15000.00, 'exitoso'),
('2025-03-02 12:00:00', '2025-03-05', 5000.00, 'exitoso'),
('2025-03-04 13:30:00', '2025-03-05', 9000.00, 'exitoso'),
('2025-05-04 11:00:00', '2025-05-05', 12000.00, 'exitoso'),
('2025-03-05 10:10:00', '2025-03-05', 4000.00, 'exitoso'),
('2025-03-03 08:45:00', '2025-03-05', 13000.00, 'exitoso'),
('2025-03-01 11:25:00', '2025-03-05', 4400.00, 'exitoso'),
('2025-03-01 10:10:00', '2025-03-05', 10200.00, 'exitoso'),
('2025-03-29 15:20:00', '2025-04-05', 6000.00, 'exitoso'),
('2025-05-04 09:50:00', '2025-05-05', 9400.00, 'exitoso'),
('2025-05-02 14:05:00', '2025-05-05', 14400.00, 'exitoso'),
('2025-03-01 12:35:00', '2025-03-05', 5600.00, 'exitoso'),
('2025-03-02 15:45:00', '2025-03-05', 10000.00, 'exitoso'),
('2025-03-04 13:20:00', '2025-03-05', 5200.00, 'exitoso'),
('2025-03-01 14:00:00', '2025-03-05', 10400.00, 'exitoso'),
('2025-03-30 09:30:00', '2025-04-05', 4600.00, 'exitoso'),
('2025-04-02 16:40:00', '2025-04-05', 12800.00, 'exitoso'),
('2025-03-02 08:00:00', '2025-03-05', 6200.00, 'exitoso'),
('2025-03-03 11:00:00', '2025-03-05', 13600.00, 'exitoso'),
('2025-05-03 17:20:00', '2025-05-05', 5800.00, 'exitoso'),
('2025-03-01 07:50:00', '2025-03-05', 9900.00, 'exitoso'),
('2025-04-01 08:30:00', '2025-04-05', 14200.00, 'exitoso');

INSERT INTO pago (fecha_pago, fecha_maxima_pago, monto_pagado, estado) VALUES
-- Pagos fallidos (simulación)
('2025-03-05 13:00:00', '2025-03-05', 10000.00, 'fallido'),
('2025-03-06 09:00:00', '2025-03-05', 9500.00, 'fallido'),
('2025-04-07 10:00:00', '2025-04-05', 11000.00, 'fallido'),
('2025-05-08 11:15:00', '2025-05-05', 8700.00, 'fallido'),
('2025-05-09 12:10:00', '2025-05-05', 7200.00, 'fallido');



-- pago tarjeta

INSERT INTO pago_tarjeta (pago_id, tarjeta_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 9),
(9, 10),
(10, 11),
(11, 13),
(12, 14),
(13, 15),
(14, 16),
(15, 17),
(16, 19),
(17, 20),
(18, 22),
(19, 24),
(20, 25),
(21, 27),
(22, 28),
(23, 29),
(24, 30);



-- Historial de pagos
INSERT INTO historial_pago (tarjeta_id, cuota_manejo_id, pago_id, fecha_pago) VALUES
(1, 1, 1, '2025-02-28 10:15:00'),
(2, 4, 2, '2025-03-28 09:20:00'),
(3, 7, 3, '2025-04-01 14:45:00'),
(4, 10, 4, '2025-03-02 12:00:00'),
(5, 13, 5, '2025-03-04 13:30:00'),
(6, 18, 6, '2025-05-04 11:00:00'),
(7, 19, 7, '2025-03-05 10:10:00'),
(9, 25, 8, '2025-03-03 08:45:00'),
(10, 28, 9, '2025-03-01 11:25:00'),
(11, 31, 10, '2025-03-01 10:10:00'),
(13, 37, 11, '2025-03-29 15:20:00'),
(14, 40, 12, '2025-05-04 09:50:00'),
(15, 43, 13, '2025-05-02 14:05:00'),
(16, 46, 14, '2025-03-01 12:35:00'),
(17, 49, 15, '2025-03-02 15:45:00'),
(19, 55, 16, '2025-03-04 13:20:00'),
(20, 58, 17, '2025-03-01 14:00:00'),
(22, 64, 18, '2025-03-30 09:30:00'),
(24, 70, 19, '2025-04-02 16:40:00'),
(25, 73, 20, '2025-03-02 08:00:00'),
(27, 79, 21, '2025-03-03 11:00:00'),
(28, 82, 22, '2025-05-03 17:20:00'),
(29, 85, 23, '2025-03-01 07:50:00');



--INSERCIONES LUEGO DE LOS TRES TRISTES TRIGGERS

-- INSERCIONES ADICIONALES PARA COMPLETAR 50 REGISTROS POR TABLA
-- Teniendo en cuenta los triggers existentes

USE banco;

-- ============================================
-- CLIENTES (25 adicionales para completar 50)
-- ============================================
INSERT INTO cliente (identificacion, nombre, apellido, celular, correo_electronico) VALUES
('1334567891', 'Alejandra', 'Montoya', '3125467891', 'alejandra.montoya@gmail.com'),
('1345678902', 'Ricardo', 'Bedoya', '3136578902', 'ricardo.bedoya@hotmail.com'),
('1356789013', 'Paulina', 'Cárdenas', '3147689013', 'paulina.cardenas@yahoo.com'),
('1367890124', 'Diego', 'Ospina', '3158790124', 'diego.ospina@outlook.com'),
('1378901235', 'Natalia', 'Restrepo', '3169801235', 'natalia.restrepo@gmail.com'),
('1389012346', 'Camilo', 'Zuluaga', '3170912346', 'camilo.zuluaga@icloud.com'),
('1390123457', 'Andrea', 'Giraldo', '3181023457', 'andrea.giraldo@live.com'),
('1401234568', 'Miguel', 'Arango', '3192134568', 'miguel.arango@protonmail.com'),
('1412345679', 'Carolina', 'Velásquez', '3103245679', 'carolina.velasquez@gmail.com'),
('1423456780', 'Andrés', 'Quintero', '3114356780', 'andres.quintero@hotmail.com'),
('1434567891', 'Valeria', 'Agudelo', '3125467891', 'valeria.agudelo@yahoo.com'),
('1445678902', 'Sebastián', 'Ramírez', '3136578902', 'sebastian.ramirez@outlook.com'),
('1456789013', 'Gabriela', 'Londoño', '3147689013', 'gabriela.londono@gmail.com'),
('1467890124', 'Alejandro', 'Henao', '3158790124', 'alejandro.henao@live.com'),
('1478901235', 'Mónica', 'García', '3169801235', 'monica.garcia@icloud.com'),
('1489012346', 'Daniel', 'Correa', '3170912346', 'daniel.correa@gmail.com'),
('1490123457', 'Tatiana', 'Villa', '3181023457', 'tatiana.villa@hotmail.com'),
('1501234568', 'Luis', 'Betancur', '3192134568', 'luis.betancur@yahoo.com'),
('1512345679', 'Paola', 'Jaramillo', '3103245679', 'paola.jaramillo@outlook.com'),
('1523456780', 'Jorge', 'Castrillón', '3114356780', 'jorge.castrillon@gmail.com'),
('1534567891', 'Marcela', 'Echeverri', '3125467891', 'marcela.echeverri@live.com'),
('1545678902', 'Fernando', 'Mesa', '3136578902', 'fernando.mesa@protonmail.com'),
('1556789013', 'Viviana', 'Cardona', '3147689013', 'viviana.cardona@gmail.com'),
('1567890124', 'Álvaro', 'Upegui', '3158790124', 'alvaro.upegui@hotmail.com'),
('1578901235', 'Liliana', 'Posada', '3169801235', 'liliana.posada@icloud.com');

-- ============================================
-- CUENTAS (25 adicionales)
-- NOTA: Las cuentas se crean automáticamente por el trigger trg_crear_cuenta_nuevo_cliente
-- Pero vamos a insertar algunas adicionales manualmente para tener variedad
-- ============================================
INSERT INTO cuenta (numero_cuenta, tipo_cuenta, saldo, cliente_id) VALUES
('1002000031', 'corriente', 450000.00, 31),
('1002000032', 'ahorros', 380000.00, 32),
('1002000033', 'corriente', 520000.00, 33),
('1002000034', 'ahorros', 290000.00, 34),
('1002000035', 'corriente', 670000.00, 35),
('1002000036', 'ahorros', 190000.00, 36),
('1002000037', 'corriente', 580000.00, 37),
('1002000038', 'ahorros', 340000.00, 38),
('1002000039', 'corriente', 420000.00, 39),
('1002000040', 'ahorros', 310000.00, 40),
('1002000041', 'corriente', 490000.00, 41),
('1002000042', 'ahorros', 260000.00, 42),
('1002000043', 'corriente', 550000.00, 43),
('1002000044', 'ahorros', 370000.00, 44),
('1002000045', 'corriente', 440000.00, 45),
('1002000046', 'ahorros', 200000.00, 46),
('1002000047', 'corriente', 590000.00, 47),
('1002000048', 'ahorros', 320000.00, 48),
('1002000049', 'corriente', 460000.00, 49),
('1002000050', 'ahorros', 280000.00, 50),
('1003000021', 'corriente', 630000.00, 21), -- Segunda cuenta para cliente existente
('1003000022', 'ahorros', 180000.00, 22),
('1003000023', 'corriente', 510000.00, 23),
('1003000024', 'ahorros', 350000.00, 24),
('1003000025', 'corriente', 480000.00, 25);

-- ============================================
-- TARJETAS (25 adicionales para completar 50)
-- NOTA: Al insertar tarjetas, los triggers automáticamente:
-- - Generan cuotas de manejo (trigger 3)
-- - Validan saldo suficiente (trigger 6)
-- - Actualizan saldo de cuenta (trigger 7)
-- ============================================
INSERT INTO tarjeta (numero_tarjeta, tipo_tarjeta_id, cliente_id, cuenta_id, fecha_apertura, monto_apertura, saldo) VALUES
('4000123410010031', 2, 31, 32, '2023-12-15', 400000.00, 400000.00),
('4000123410010032', 1, 32, 33, '2024-01-20', 280000.00, 280000.00),
('4000123410010033', 3, 33, 34, '2023-08-18', 680000.00, 680000.00),
('4000123410010034', 2, 34, 35, '2024-02-10', 420000.00, 420000.00),
('4000123410010035', 1, 35, 36, '2023-11-05', 300000.00, 300000.00),
('4000123410010036', 3, 36, 37, '2024-04-25', 750000.00, 750000.00),
('4000123410010037', 2, 37, 38, '2023-09-12', 480000.00, 480000.00),
('4000123410010038', 1, 38, 39, '2024-03-08', 250000.00, 250000.00),
('4000123410010039', 3, 39, 40, '2024-05-15', 720000.00, 720000.00),
('4000123410010040', 2, 40, 41, '2023-10-30', 460000.00, 460000.00),
('4000123410010041', 1, 41, 42, '2024-01-12', 290000.00, 290000.00),
('4000123410010042', 3, 42, 43, '2023-07-22', 690000.00, 690000.00),
('4000123410010043', 2, 43, 44, '2024-04-18', 510000.00, 510000.00),
('4000123410010044', 1, 44, 45, '2023-12-08', 270000.00, 270000.00),
('4000123410010045', 3, 45, 46, '2024-02-28', 730000.00, 730000.00),
('4000123410010046', 2, 46, 47, '2023-09-05', 450000.00, 450000.00),
('4000123410010047', 1, 47, 48, '2024-05-20', 320000.00, 320000.00),
('4000123410010048', 3, 48, 49, '2023-11-18', 670000.00, 670000.00),
('4000123410010049', 2, 49, 50, '2024-01-25', 490000.00, 490000.00),
('4000123410010050', 1, 50, 51, '2023-08-12', 260000.00, 260000.00),
('4000123410010051', 3, 21, 56, '2024-03-10', 700000.00, 700000.00), -- Segunda tarjeta para cliente existente
('4000123410010052', 2, 22, 57, '2023-10-15', 440000.00, 440000.00),
('4000123410010053', 1, 23, 58, '2024-04-05', 310000.00, 310000.00),
('4000123410010054', 3, 24, 59, '2023-12-20', 680000.00, 680000.00),
('4000123410010055', 2, 25, 60, '2024-02-15', 470000.00, 470000.00);

-- ============================================
-- CUOTAS DE MANEJO ADICIONALES
-- NOTA: Las cuotas se generan automáticamente por el trigger al crear tarjetas
-- Pero vamos a agregar algunas cuotas adicionales para meses futuros
-- ============================================
INSERT INTO cuota_manejo (tarjeta_id, fecha_cuota, monto, estado_pago) VALUES
-- Cuotas para junio 2025 (tarjetas 1-10)
(1, '2025-06-01', 6000.00, 'pendiente'),
(2, '2025-06-01', 10000.00, 'pendiente'),
(3, '2025-06-01', 14000.00, 'pendiente'),
(4, '2025-06-01', 5000.00, 'pendiente'),
(5, '2025-06-01', 9000.00, 'pendiente'),
(6, '2025-06-01', 12000.00, 'pendiente'),
(7, '2025-06-01', 4000.00, 'pendiente'),
(8, '2025-06-01', 9600.00, 'pendiente'),
(9, '2025-06-01', 13000.00, 'pendiente'),
(10, '2025-06-01', 4400.00, 'pendiente'),

-- Cuotas para julio 2025 (tarjetas 11-20)
(11, '2025-07-01', 10200.00, 'pendiente'),
(12, '2025-07-01', 15000.00, 'pendiente'),
(13, '2025-07-01', 6000.00, 'pendiente'),
(14, '2025-07-01', 9400.00, 'pendiente'),
(15, '2025-07-01', 14400.00, 'pendiente'),
(16, '2025-07-01', 5600.00, 'pendiente'),
(17, '2025-07-01', 10000.00, 'pendiente'),
(18, '2025-07-01', 13800.00, 'pendiente'),
(19, '2025-07-01', 5200.00, 'pendiente'),
(20, '2025-07-01', 10400.00, 'pendiente'),

-- Cuotas adicionales para completar 50
(21, '2025-06-01', 14200.00, 'pendiente'),
(22, '2025-06-01', 4600.00, 'pendiente'),
(23, '2025-06-01', 9800.00, 'pendiente'),
(24, '2025-06-01', 12800.00, 'pendiente'),
(25, '2025-06-01', 6200.00, 'pendiente');

-- ============================================
-- PAGOS ADICIONALES (25 más para completar 50)
-- ============================================
INSERT INTO pago (fecha_pago, fecha_maxima_pago, monto_pagado, estado) VALUES
('2025-04-05 09:15:00', '2025-04-10', 8000.00, 'exitoso'),
('2025-04-08 10:30:00', '2025-04-15', 12000.00, 'exitoso'),
('2025-04-12 14:20:00', '2025-04-20', 9500.00, 'exitoso'),
('2025-04-15 16:45:00', '2025-04-25', 11000.00, 'exitoso'),
('2025-04-18 11:10:00', '2025-04-30', 7500.00, 'exitoso'),
('2025-04-22 13:35:00', '2025-05-05', 10500.00, 'exitoso'),
('2025-04-25 15:20:00', '2025-05-10', 8800.00, 'exitoso'),
('2025-04-28 09:50:00', '2025-05-15', 13500.00, 'exitoso'),
('2025-05-02 12:25:00', '2025-05-20', 9200.00, 'exitoso'),
('2025-05-05 14:40:00', '2025-05-25', 10800.00, 'exitoso'),
('2025-05-08 10:15:00', '2025-05-30', 7800.00, 'exitoso'),
('2025-05-12 16:30:00', '2025-06-05', 12500.00, 'exitoso'),
('2025-05-15 11:45:00', '2025-06-10', 9800.00, 'exitoso'),
('2025-05-18 13:20:00', '2025-06-15', 11200.00, 'exitoso'),
('2025-05-22 15:10:00', '2025-06-20', 8500.00, 'exitoso'),
('2025-05-25 09:35:00', '2025-06-25', 10200.00, 'exitoso'),
('2025-05-28 12:50:00', '2025-06-30', 9600.00, 'exitoso'),
('2025-06-02 14:15:00', '2025-07-05', 13200.00, 'exitoso'),
('2025-06-05 16:25:00', '2025-07-10', 8900.00, 'exitoso'),
('2025-06-08 10:40:00', '2025-07-15', 11500.00, 'exitoso'),
-- Algunos pagos fallidos
('2025-06-10 13:00:00', '2025-06-10', 9000.00, 'fallido'),
('2025-06-12 15:20:00', '2025-06-12', 8500.00, 'fallido'),
('2025-06-15 11:30:00', '2025-06-15', 10000.00, 'fallido'),
('2025-06-18 14:45:00', '2025-06-18', 7500.00, 'fallido'),
('2025-06-20 16:10:00', '2025-06-20', 9500.00, 'fallido');

-- ============================================
-- PAGO_TARJETA (25 adicionales)
-- ============================================
INSERT INTO pago_tarjeta (pago_id, tarjeta_id) VALUES
(30, 31), (31, 32), (32, 33), (33, 34), (34, 35),
(35, 36), (36, 37), (37, 38), (38, 39), (39, 40),
(40, 41), (41, 42), (42, 43), (43, 44), (44, 45),
(45, 46), (46, 47), (47, 48), (48, 49), (49, 50),
(50, 21), (51, 22), (52, 23), (53, 24), (54, 25);

-- ============================================
-- HISTORIAL_PAGO (25 adicionales para completar 50)
-- NOTA: Algunos se generan automáticamente por triggers
-- ============================================
INSERT INTO historial_pago (tarjeta_id, cuota_manejo_id, pago_id, fecha_pago) VALUES
(31, 91, 30, '2025-04-05 09:15:00'),
(32, 94, 31, '2025-04-08 10:30:00'),
(33, 97, 32, '2025-04-12 14:20:00'),
(34, 100, 33, '2025-04-15 16:45:00'),
(35, 103, 34, '2025-04-18 11:10:00'),
(36, 106, 35, '2025-04-22 13:35:00'),
(37, 109, 36, '2025-04-25 15:20:00'),
(38, 112, 37, '2025-04-28 09:50:00'),
(39, 115, 38, '2025-05-02 12:25:00'),
(40, 118, 39, '2025-05-05 14:40:00'),
(41, 121, 40, '2025-05-08 10:15:00'),
(42, 124, 41, '2025-05-12 16:30:00'),
(43, 127, 42, '2025-05-15 11:45:00'),
(44, 130, 43, '2025-05-18 13:20:00'),
(45, 133, 44, '2025-05-22 15:10:00'),
(46, 136, 45, '2025-05-25 09:35:00'),
(47, 139, 46, '2025-05-28 12:50:00'),
(48, 142, 47, '2025-06-02 14:15:00'),
(49, 145, 48, '2025-06-05 16:25:00'),
(50, 148, 49, '2025-06-08 10:40:00'),
(21, 151, 50, '2025-06-10 13:00:00'),
(22, 152, 51, '2025-06-12 15:20:00'),
(23, 153, 52, '2025-06-15 11:30:00'),
(24, 154, 53, '2025-06-18 14:45:00'),
(25, 155, 54, '2025-06-20 16:10:00');

-- ============================================
-- VERIFICACIÓN DE REGISTROS
-- ============================================
SELECT 'Clientes' as tabla, COUNT(*) as total FROM cliente
UNION ALL
SELECT 'Cuentas', COUNT(*) FROM cuenta
UNION ALL
SELECT 'Tarjetas', COUNT(*) FROM tarjeta
UNION ALL
SELECT 'Cuotas de Manejo', COUNT(*) FROM cuota_manejo
UNION ALL
SELECT 'Pagos', COUNT(*) FROM pago
UNION ALL
SELECT 'Pago-Tarjeta', COUNT(*) FROM pago_tarjeta
UNION ALL
SELECT 'Historial Pago', COUNT(*) FROM historial_pago;