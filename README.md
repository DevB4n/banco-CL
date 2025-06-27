# banco-CL
# Proyecto BANCO-CL 🏦

Banco-CL simula el funcionamiento de una base de datos bancaria, tiene una estructura de datos que va de acuerdo a las tablas que se encuentran creadas, también tiene permisos específicos y diferentes ejercicios para el desarrollo del proyecto.


## Tabla Contenidos

- [🔍 Descripción General](#-descripción-general)
- [🗃️ Estructura del Proyecto](#-estructura-del-proyecto)
- [👥 Gestión de Usuarios y Permisos](#-gestión-de-usuarios-y-permisos)
- [🧱 Modelo de Base de Datos](#-modelo-de-base-de-datos)
- [📄 Scripts Incluidos](#-scripts-incluidos)
- [🛠️ Requisitos](#-requisitos)
- [📜 Licencia](#-licencia)


## Descripción General

El sistema bancario **BANCO-CL**, incluye:

- Diferentes tipos de tablas relacionadas (clientes, cuentas, tarjetas, etc.).
- Gestión de accesos con distintos perfiles de usuario.
- Automatización de procesos mediante eventos y triggers.
- Simulación de "operaciones" bancarias reales: historial, manejo de cuotas, entre otros.


## Estructura del Proyecto

BANCO-CL/
├── dcl_usuarios.sql            # Gestión de usuarios y privilegios
├── ddl.sql                     # Creación de la base de datos y tablas
├── dml.sql                     # Inserción de datos (50 registros por tabla)
├── dql_funciones.sql           # 50 funciones SQL
├── dql_procedimientos.sql     # 50 procedimientos almacenados
├── dql_select.sql              # 100 consultas básicas
├── dql_eventos.sql             # 50 eventos programados
├── dql_triggers.sql            # 50 triggers
├── diagrama-banco-cl.png       # Diagrama ER del sistema
├── LICENSE                     # Licencia
└── README.md                   # Este archivo
