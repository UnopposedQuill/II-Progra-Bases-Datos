use master
if not exists(select * from sysdatabases where name = 'II_Progra') 
	create database [II_Progra];--si no existe, la crea
go

use [II_Progra]
go

/*
primero colocaré todos los SP de inserción, les daré prioridad puesto que quiero cargar el XML
rápidamente, utilizaré el mismo orden que el de creación de tablas.
*/
if object_id('SPinsertarMunicipalidad','P') is not null drop procedure SPinsertarMunicipalidad;
go
create procedure SPinsertarMunicipalidad @nombre nvarchar(20), @diaEmision date, @diaLimite date, @interesesMorosidad float, @valorMetroCubicoAgua float
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Municipalidad(nombre, diaEmision, diaLimite, interesesMorosidad, valorMetroCubicoAgua) values (@nombre, @diaEmision, @diaLimite, @interesesMorosidad, @valorMetroCubicoAgua);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end

if object_id('SPinsertarPropiedad','P') is not null drop procedure SPinsertarPropiedad;
go
create procedure SPinsertarPropiedad @id int, @descripcion nvarchar(50), @valor float, @codigoPostal nvarchar(10), @numeroFinca int
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Propiedad(descripcion, valor, codigoPostal, numeroFinca) values (@descripcion, @valor, @codigoPostal, @numeroFinca);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end

if object_id('SPinsertarTipoServicio','P') is not null drop procedure SPinsertarTipoServicio;
go
create procedure SPinsertarTipoServicio @nombre varchar(20), @valor float
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into TipoServicio(nombre, valor) values (@nombre, @valor);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end

if object_id('SPinsertarAbonado','P') is not null drop procedure SPinsertarAbonado;
go
create procedure SPinsertarAbonado @nombre varchar(20), @idDocumento int
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Abonado(nombre, idDocumento) values (@nombre, @idDocumento);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end

if object_id('SPinsertarRecibo','P') is not null drop procedure SPinsertarRecibo;
go
create procedure SPinsertarRecibo @numeroFinca int, @fechaEmision date, @totalAPagarSinIntereses float,
	@interesMoratorios float, @totalPagado float, @fechaLimite date, @fechaPagado date
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Recibo(
			FKPropiedad, fechaEmision, totalAPagarSinIntereses, interesMoratorio,
			totalPagado, fechaLimite, fechaPagado
		) values ((select P.id from Propiedad P where P.numeroFinca = @numeroFinca), @fechaEmision,
		@totalAPagarSinIntereses, @interesMoratorios, @totalPagado, @fechaLimite, @fechaPagado
		);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end

/*--SP ya no necesitado debido a la eliminación de la tabla de líneas
if object_id('SPinsertarLinea','P') is not null drop procedure SPinsertarLinea;
go
create procedure SPinsertarLinea 
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Recibo(
			FKPropiedad, fechaEmision, totalAPagarSinIntereses, interesMoratorio,
			totalPagado, fechaLimite, fechaPagado
		) values ((select P.id from Propiedad P where P.numeroFinca = @numeroFinca), @fechaEmision,
		@totalAPagarSinIntereses, @interesMoratorios, @totalPagado, @fechaLimite, @fechaPagado
		);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
*/

if object_id('SPinsertarConsumoAgua','P') is not null drop procedure SPinsertarConsumoAgua;
go
create procedure SPinsertarConsumoAgua @numeroFinca int, @fechaLectura date, @contadorMetrosCubicos float
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into ConsumoAgua(FKPropiedad, fechaLectura, contadorMetrosCubicos) 
			values ((select P.id from Propiedad P where P.numeroFinca = @numeroFinca), @fechaLectura, 
			@contadorMetrosCubicos);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end

if object_id('SPinsertarMunicipalidadXPropiedad','P') is not null drop procedure SPinsertarMunicipalidadXPropiedad;
go
create procedure SPinsertarMunicipalidadXPropiedad @numeroFinca int, @idMunicipalidad int
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into MunicipalidadXPropiedad(FKPropiedad, FKMunicipalidad) values 
			((select P.id from Propiedad P where P.numeroFinca = @numeroFinca), 
			 (select M.id from Municipalidad M where M.id = @idMunicipalidad));
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end

if object_id('SPinsertarAbonadoXPropiedad','P') is not null drop procedure SPinsertarAbonadoXPropiedad;
go
create procedure SPinsertarAbonadoXPropiedad @numeroFinca int, @idAbonado int
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into AbonadoXPropiedad(FKPropiedad, FKAbonado) values 
			((select P.id from Propiedad P where P.numeroFinca = @numeroFinca), 
			 (select A.id from Abonado A where A.id = @idAbonado));
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end

if object_id('SPinsertarServicioXPropiedad','P') is not null drop procedure SPinsertarServicioXPropiedad;
go
create procedure SPinsertarServicioXPropiedad @numeroFinca int, @idTipoServicio int
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into ServicioXPropiedad(FKPropiedad, FKTipoServicio) values 
			((select P.id from Propiedad P where P.numeroFinca = @numeroFinca), 
			 (select T.id from TipoServicio T where T.id = @idTipoServicio));
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end