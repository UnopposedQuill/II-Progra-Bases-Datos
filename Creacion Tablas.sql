use master
if exists(select * from sysdatabases where name = 'II_Progra')--si existe, la borra y luego la crea de nuevo
begin
	drop database [II_Progra];
end
create database [II_Progra];
go

use [II_Progra];
go

--primero crearé todas las tablas que no requieran FK's dentro de ellas
create table Municipalidad(
	id int identity primary key,
	nombre varchar(20) not null,
	diaEmision date not null,
	diaLimite date not null,
	interesesMorosidad float not null,
	valorMetroCubicoAgua float not null
);

create table Propiedad(
	id int identity primary key,
	descripcion nvarchar(50) not null,
	valor float not null,
	codigoPostal nvarchar(10) not null,
	numeroFinca int not null
);

create table TipoServicio(
	id int identity primary key,
	nombre varchar(20) not null,
	valor float not null
);

create table Abonado(
	id int identity primary key,
	nombre varchar(20) not null,
	idDocumento int not null
);
--ahora empezaré a crear todas las tablas que requieren un FK
create table Recibo(
	id int identity primary key,
	FKPropiedad int constraint FKRecibos_Propiedad foreign key references Propiedad(id) not null,
	fechaEmision date not null,
	totalAPagarSinIntereses float not null,
	interesMoratorio float not null,
	totalPagado float not null check (totalPagado >= 0),
	fechaLimite date not null,
	fechaPagado date --esta si puede ser nula, dejará de ser nula una vez se haya pagado completamente el recibo
);

create table Linea(
	id int identity primary key,
	FKRecibo int constraint FKLinea_Recibo foreign key references Recibo(id) not null,
	FKPropiedad int constraint FKLinea_Propiedad foreign key references Propiedad(id) not null,
	FKTipoServicio int constraint FKLinea_TipoServicio foreign key references TipoServicio(id) not null,
);

create table ConsumoAgua(
	id int identity primary key,
	FKPropiedad int constraint FKConsumoAgua_Propiedad foreign key references Propiedad(id) not null,
	fechaLectura date not null,
	contadorMetrosCubicos float not null
);

create table MunicipalidadXPropiedad(
	id int identity primary key,
	FKPropiedad int constraint FKMunicipalidadXPropiedad_Propiedad foreign key references Propiedad(id) not null,
	FKMunicipalidad int constraint FKMunicipalidadXPropiedad_Municipalidad foreign key references Municipalidad(id) not null
);

create table AbonadoXPropiedad(
	id int identity primary key,
	FKPropiedad int constraint FKAbonadoXPropiedad_Propiedad foreign key references Propiedad(id) not null,
	FKAbonado int constraint FKAbonadoXPropiedad_Abonado foreign key references Abonado(id) not null
);

create table ServicioXPropiedad(
	id int identity primary key,
	FKPropiedad int constraint FKServicioXPropiedad_Propiedad foreign key references Propiedad(id) not null,
	FKTipoServicio int constraint FKServicioXPropiedad_TipoServicio foreign key references TipoServicio(id) not null
);