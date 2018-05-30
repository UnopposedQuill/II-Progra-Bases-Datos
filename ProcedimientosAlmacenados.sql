use master
if not exists(select * from sysdatabases where name = 'II_Progra') 
	create database [II_Progra];--si no existe, la crea
go

use [II_Progra]
go

/*
primero colocar� todos los SP de inserci�n, les dar� prioridad puesto que quiero cargar el XML
r�pidamente, utilizar� el mismo orden que el de creaci�n de tablas.
*/
if object_id('SPinsertarMunicipalidad','P') is not null drop procedure SPinsertarMunicipalidad;
go
create procedure SPinsertarMunicipalidad @nombre nvarchar(20), @diaEmision tinyint, @diaLimite tinyint, @interesesMorosidad float, @valorMetroCubicoAgua float
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
create procedure SPinsertarTipoServicio @nombre varchar(20), @valor float, @variable bit
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into TipoServicio(nombre, valor, variable) values (@nombre, @valor, @variable);
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
create procedure SPinsertarAbonado @nombre varchar(20)
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Abonado(nombre) values (@nombre);
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
	@interesMoratorios float, @fechaLimite date, @fechaPagado date
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Recibo(
			FKPropiedad, fechaEmision, totalAPagarSinIntereses,
			interesMoratorios, fechaLimite, fechaPagado
		) values ((select P.id from Propiedad P where P.numeroFinca = @numeroFinca), @fechaEmision,
		@totalAPagarSinIntereses, @interesMoratorios, @fechaLimite, @fechaPagado
		);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end

/*--SP ya no necesitado debido a que ahora se realiza en conjunto con la creaci�n de recibos
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



if object_id('SPgenerarRecibos','P') is not null drop procedure SPinsertarServicioXPropiedad;
go
create procedure SPgenerarRecibos
as begin
	set nocount on;
	begin transaction;
	begin try
		declare @contadorBajo int = 1, @contadorAlto int = (select count(*) from Propiedad) + 1;--por cada uno de los identity de las propiedades;
		while @contadorBajo < @contadorAlto--mientras falten propiedades por revisar
		begin
			--primero crear� los recibos, pues las l�neas necesitan poder apuntar a ellos
			insert into Recibo(FKPropiedad, fechaEmision, fechaLimite, interesMoratorios, totalAPagarSinIntereses)
				values(@contadorBajo, 
					   dateadd(month, datediff(month, 0, getdate()),(select M.diaEmision from Municipalidad M inner join MunicipalidadXPropiedad MxP on MxP.FKMunicipalidad = M.id where MxP.FKPropiedad = @contadorBajo)),
					   dateadd(month, datediff(month, 0, getdate()),(select M.diaLimite from Municipalidad M inner join MunicipalidadXPropiedad MxP on MxP.FKMunicipalidad = M.id where MxP.FKPropiedad = @contadorBajo)),
					   (select M.interesesMorosidad from Municipalidad M inner join MunicipalidadXPropiedad MxP on MxP.FKMunicipalidad = M.id where MxP.FKPropiedad = @contadorBajo),
					   (select sum(T.valor) from TipoServicio T inner join ServicioXPropiedad SxP on SxP.FKTipoServicio = T.id where SxP.FKPropiedad = @contadorBajo) + ((select M.valorMetroCubicoAgua from Municipalidad M inner join MunicipalidadXPropiedad MxP on MxP.FKMunicipalidad = M.id where MxP.FKPropiedad = @contadorBajo)*(select sum(C.contadorMetrosCubicos) from ConsumoAgua C where C.FKPropiedad = @contadorBajo))
			);--sumo todos los costos de los servicios m�s el costo del agua, que est� por separado
			declare @idRecibo int = @@identity;
			insert into Linea(FKPropiedad, FKTipoServicio, FKRecibo)
				select @contadorBajo, S.FKTipoServicio, @idRecibo
				from ServicioXPropiedad S
				where S.FKPropiedad = @contadorBajo;
			
		end
		return (select count(*) from Recibo);--retorno la cantidad de recibos generados
	end try
	begin catch
		rollback;
		select ERROR_MESSAGE();
		return -50001;
	end catch
end

if object_id('SPrealizarPago','P') is not null drop procedure SPinsertarServicioXPropiedad;
go
create procedure SPrealizarPago @idPropiedad int, @fechaPago date
as begin
	set nocount on;
	begin transaction;
	begin try
		update R
		set R.fechaPagado = @fechaPago
		from Recibo as R
		where R.fechaPagado is null and R.FKPropiedad = @idPropiedad
			and R.id = (select Top 1 R.id from Recibo R order by R.fechaEmision desc);
		return @idPropiedad;
	end try
	begin catch
		rollback;
		select ERROR_MESSAGE();
		return -50001;
	end catch
end