use master
if exists(select * from sysdatabases where name = 'II_Progra')--si existe, la borra y luego la crea de nuevo
begin
	drop database [II_Progra];
end
create database [II_Progra];
go

use [II_Progra];
go

--primero crear un sitio donde pueda guardar banderas de la base de datos
create table DatosControlBase(
	datosSimulacionListos bit not null
);

--ahora crear� todas las tablas que no requieran FK's dentro de ellas
create table Municipalidad(
	id int identity primary key,
	nombre varchar(20)unique not null,
	diaEmision tinyint not null,
	diaLimite tinyint not null,
	interesesMorosidad float not null,
	valorMetroCubicoAgua float not null,
	habilitado bit not null default 1
);

create table Propiedad(
	id int identity primary key,
	descripcion nvarchar(50)unique not null,
	valor float not null,
	codigoPostal nvarchar(10) not null,
	numeroFinca int not null,
	habilitado bit not null default 1
);

create table TipoServicio(
	id int identity primary key,
	nombre varchar(20)unique not null,
	valor float not null,
	variable bit not null,
	habilitado bit not null default 1
);

create table InformacionContacto(
	id int identity primary key,
	correo varchar(20) not null,
	direccion varchar(50) not null
);

--ahora empezar� a crear todas las tablas que requieren un FK
create table Telefono(
	id int identity primary key,
	FKInformacionContacto int constraint FKTelefono_InformacionContacto references InformacionContacto(id) not null,
	telefono varchar(8) not null
);

create table Abonado(
	id int identity primary key,
	nombre varchar(20)unique not null,
	idDocumento int not null,--campo reinsertado para opcionales
	habilitado bit not null default 1
);

create table AbonadoXInformacionContacto(
	id int identity primary key,
	FKAbonado int constraint FKAbonadoXInformacionContacto_Abonado references Abonado(id),
	FKInformacionContacto int constraint FKAbonadoXInformacionContacto_InformacionContacto references Abonado(id)
);

create table Recibo(
	id int identity primary key,
	FKPropiedad int constraint FKRecibos_Propiedad foreign key references Propiedad(id) not null,
	--FKLinea int constraint FKRecibos_Linea foreign key references Linea(id) not null,--error de modificaci�n
	fechaEmision date not null,
	totalAPagarSinIntereses float not null,
	interesMoratorios float not null,
	totalPagado float not null check (totalPagado >= 0) default 0,
	fechaLimite date not null,
	fechaPagado date, --esta si puede ser nula, dejar� de ser nula una vez se haya pagado completamente el recibo
	habilitado bit not null default 1
);

create table Linea(
	id int identity primary key,
	FKRecibo int constraint FKLinea_Recibo foreign key references Recibo(id) not null,--esto se movi� hacia recibo
	FKPropiedad int constraint FKLinea_Propiedad foreign key references Propiedad(id) not null,
	FKTipoServicio int constraint FKLinea_TipoServicio foreign key references TipoServicio(id) not null,
	habilitado bit not null default 1
);

create table ConsumoAgua(
	id int identity primary key,
	FKPropiedad int constraint FKConsumoAgua_Propiedad foreign key references Propiedad(id) not null,
	fechaLectura date not null,
	contadorMetrosCubicos float not null,
	habilitado bit not null default 1
);

create table MunicipalidadXPropiedad(
	id int identity primary key,
	FKPropiedad int constraint FKMunicipalidadXPropiedad_Propiedad foreign key references Propiedad(id) not null,
	FKMunicipalidad int constraint FKMunicipalidadXPropiedad_Municipalidad foreign key references Municipalidad(id) not null,
	habilitado bit not null default 1
);

create table AbonadoXPropiedad(
	id int identity primary key,
	FKPropiedad int constraint FKAbonadoXPropiedad_Propiedad foreign key references Propiedad(id) not null,
	FKAbonado int constraint FKAbonadoXPropiedad_Abonado foreign key references Abonado(id) not null,
	habilitado bit not null default 1
);

create table ServicioXPropiedad(
	id int identity primary key,
	FKPropiedad int constraint FKServicioXPropiedad_Propiedad foreign key references Propiedad(id) not null,
	FKTipoServicio int constraint FKServicioXPropiedad_TipoServicio foreign key references TipoServicio(id) not null,
	fechaContratacion date not null,
	habilitado bit not null default 1
);