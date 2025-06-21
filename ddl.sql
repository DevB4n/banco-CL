create database if not exists banco;
use banco;

-- clientes
create table if not exists cliente (
  cliente_id       int auto_increment primary key,
  identificacion   varchar(100),
  nombre           varchar(100),
  apellido         varchar(100),
  celular          varchar(20),
  correo_electronico varchar(50)
);

-- cuentas bancarias
create table if not exists cuenta (
  cuenta_id      int auto_increment primary key,
  numero_cuenta  varchar(20) unique not null,
  tipo_cuenta    enum('ahorros','corriente') not null,
  saldo          decimal(10,2)    default 0,
  cliente_id     int unique not null,
  fecha_creacion datetime         default current_timestamp,
  foreign key (cliente_id) references cliente(cliente_id)
);

-- tipos de tarjeta y su descuento
create table if not exists tipo_tarjeta (
  tipo_tarjeta_id int auto_increment primary key,
  nombre          enum('joven','nomina','visa'),
  descuento       decimal(5,2) not null
);

-- tarjetas emitidas a clientes
create table if not exists tarjeta (
  tarjeta_id      int auto_increment primary key,
  numero_tarjeta  varchar(20)     unique not null,
  tipo_tarjeta_id int              not null,
  cliente_id      int              not null,
  cuenta_id       int              not null,
  fecha_apertura  date             not null,
  monto_apertura  decimal(10,2)    not null,
  saldo           decimal(10,2)    not null,
  foreign key (tipo_tarjeta_id) references tipo_tarjeta(tipo_tarjeta_id),
  foreign key (cliente_id)      references cliente(cliente_id),
  foreign key (cuenta_id)       references cuenta(cuenta_id)
) ;

-- cuotas mensuales por tarjeta (rediseñada)
create table if not exists cuota_manejo (
  cuota_manejo_id int auto_increment primary key,
  tarjeta_id      int              not null,
  fecha_cuota     date             not null,
  monto           decimal(10,2)    not null,
  estado_pago     enum('pendiente','pagado') not null default 'pendiente',
  foreign key (tarjeta_id) references tarjeta(tarjeta_id)
);

-- pagos realizados por los clientes
create table if not exists pago (
  pago_id         int auto_increment primary key,
  fecha_pago      datetime         not null,
  fecha_maxima_pago date           not null,
  monto_pagado    decimal(10,2)    not null,  -- cambiado de int a decimal
  estado          enum('exitoso','fallido') not null
);

-- asociación muchos a muchos: pagos a tarjetas
create table if not exists pago_tarjeta (
  pago_id    int not null,
  tarjeta_id int not null,
  foreign key (pago_id)    references pago(pago_id),
  foreign key (tarjeta_id) references tarjeta(tarjeta_id),
  primary key (pago_id, tarjeta_id)
);

-- historial detallado de pagos por cuota
create table if not exists historial_pago (
  historial_id    int auto_increment primary key,
  tarjeta_id      int              not null,
  cuota_manejo_id int              not null,
  pago_id         int              not null,
  fecha_pago      datetime         not null,
  foreign key (tarjeta_id)      references tarjeta(tarjeta_id),
  foreign key (cuota_manejo_id) references cuota_manejo(cuota_manejo_id),
  foreign key (pago_id)         references pago(pago_id)
);


