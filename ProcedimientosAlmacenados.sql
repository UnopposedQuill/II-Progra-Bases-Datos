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

/*--ya no necesitado pues se inserta de manera masiva
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
*/

/*--SP ya no necesitado debido a que ahora se realiza en conjunto con la creación de recibos
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
			--primero crearé los recibos, pues las líneas necesitan poder apuntar a ellos
			insert into Recibo(FKPropiedad, fechaEmision, fechaLimite, interesMoratorios, totalAPagarSinIntereses)
				values(@contadorBajo, 
					   dateadd(month, datediff(month, 0, getdate()),(select M.diaEmision from Municipalidad M inner join MunicipalidadXPropiedad MxP on MxP.FKMunicipalidad = M.id where MxP.FKPropiedad = @contadorBajo)),
					   dateadd(month, datediff(month, 0, getdate()),(select M.diaLimite from Municipalidad M inner join MunicipalidadXPropiedad MxP on MxP.FKMunicipalidad = M.id where MxP.FKPropiedad = @contadorBajo)),
					   (select M.interesesMorosidad from Municipalidad M inner join MunicipalidadXPropiedad MxP on MxP.FKMunicipalidad = M.id where MxP.FKPropiedad = @contadorBajo),
					   (select sum(T.valor) from TipoServicio T inner join ServicioXPropiedad SxP on SxP.FKTipoServicio = T.id where SxP.FKPropiedad = @contadorBajo) + ((select M.valorMetroCubicoAgua from Municipalidad M inner join MunicipalidadXPropiedad MxP on MxP.FKMunicipalidad = M.id where MxP.FKPropiedad = @contadorBajo)*(select sum(C.contadorMetrosCubicos) from ConsumoAgua C where C.FKPropiedad = @contadorBajo))
			);--sumo todos los costos de los servicios más el costo del agua, que está por separado
			declare @idRecibo int = @@identity;
			insert into Linea(FKPropiedad, FKTipoServicio, FKRecibo)
			select @contadorBajo, S.FKTipoServicio, @idRecibo
			from ServicioXPropiedad S
			where S.FKPropiedad = @contadorBajo;
			set @contadorBajo += 1;			
		end
		commit;
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
		set R.fechaPagado = @fechaPago, R.totalPagado = case when datediff(day, R.fechaEmision, R.fechaLimite) > 0 then R.totalAPagarSinIntereses+0.5*P.valor
							else R.totalAPagarSinIntereses+R.totalAPagarSinIntereses*(R.interesMoratorios/360)*datediff(day, R.fechaEmision, R.fechaLimite)+0.5*P.valor
							end
		from Recibo as R
		inner join Propiedad P on P.id = R.FKPropiedad
		where R.fechaPagado is null and R.FKPropiedad = @idPropiedad
			and R.id = (select Top 1 R.id from Recibo R order by R.fechaEmision desc);
	end try
	begin catch
		rollback;
		select ERROR_MESSAGE();
		return -50001;
	end catch
end

if object_id('SPmayoresMorosos','P') is not null drop procedure SPinsertarServicioXPropiedad;
go
create procedure SPmayoresMorosos 
as begin
	declare @tablaResultado table(nombre varchar(20), monto int, cantidadRecibosPendientes int);
	insert into @tablaResultado
		select A.nombre as nombre,
			   (R.totalAPagarSinIntereses+R.totalAPagarSinIntereses*(R.interesMoratorios/360)*datediff(day, R.fechaEmision, R.fechaLimite)+0.5*P.valor) as monto,
			   (select count(*) from Recibo R inner join AbonadoXPropiedad AxP on AxP.FKPropiedad = R.FKPropiedad where datediff(day, R.fechaEmision, R.fechaLimite) > 0) as cantidadRecibosSinPagar
		from Abonado A
		inner join AbonadoXPropiedad AxP on AxP.FKAbonado = A.id
		inner join Propiedad P on AxP.FKPropiedad = P.id
		inner join Recibo R on R.FKPropiedad = AxP.FKPropiedad
		where datediff(day, R.fechaEmision, R.fechaLimite) > 0 and R.fechaPagado is null--donde el recibo está pendiente
		order by monto desc;
	select top 20 T.nombre, T.monto, T.cantidadRecibosPendientes from @tablaResultado T;
end

if object_id('SPlistaPendientes','P') is not null drop procedure SPinsertarServicioXPropiedad;
go
create procedure SPlistaPendientes @idAbonado int
as 
begin
	select R.id, R.totalAPagarSinIntereses as totalAPagarSinIntereses, 
				R.totalAPagarSinIntereses*(R.interesMoratorios/360)*datediff(day, R.fechaEmision, R.fechaLimite)+0.5*P.valor as totalIntereses,
				R.totalAPagarSinIntereses+R.totalAPagarSinIntereses*(R.interesMoratorios/360)*datediff(day, R.fechaEmision, R.fechaLimite)+0.5*P.valor as totalAPagar
	from Recibo R
	inner join AbonadoXPropiedad AxP on AxP.FKAbonado = @idAbonado
	inner join Propiedad P on AxP.FKPropiedad = R.FKPropiedad
	where datediff(day, R.fechaEmision, R.fechaLimite) > 0 and R.fechaPagado is null--donde el recibo está pendiente
	order by R.fechaEmision;
end

if object_id('SPlistaCortes','P') is not null drop procedure SPinsertarServicioXPropiedad;
go
create procedure SPlistaCortes @fecha date
as 
begin
	select A.nombre, IC.direccion, (R.totalAPagarSinIntereses+R.totalAPagarSinIntereses*(R.interesMoratorios/360)*datediff(day, R.fechaEmision, R.fechaLimite)+0.5*P.valor) as montoTotal
	from Abonado A
	inner join AbonadoXPropiedad AxP on AxP.FKAbonado = A.id
	inner join Recibo R on R.FKPropiedad = AxP.FKPropiedad
	inner join Propiedad P on P.id = R.FKPropiedad
	inner join AbonadoXInformacionContacto AxIC on AxIC.FKAbonado = A.id
	inner join InformacionContacto IC on IC.id = AxIC.FKInformacionContacto
	where R.fechaPagado is null and month(R.fechaEmision) >= month(@fecha)
	--group by A.nombre, IC.direccion, 3
	order by montoTotal desc;
end

if object_id('SPdistritoMasMoroso','P') is not null drop procedure SPdistritoMasMoroso;
go
create procedure SPdistritoMasMoroso @modalidad bit
as 
begin
	if(@modalidad = 1)
	begin--morosos por cantidad de monto
	declare @tablaResultados table(codigoPostal int, cantidadMonto float);
	insert into @tablaResultados
		select P.codigoPostal as codigoPostal, sum(R.totalAPagarSinIntereses+R.totalAPagarSinIntereses*(R.interesMoratorios/360)*datediff(day, R.fechaEmision, R.fechaLimite)+0.5*P.valor) as montoTotal
		from Propiedad P inner join Recibo R on R.FKPropiedad = P.id
		where datediff(day, R.fechaEmision, R.fechaLimite) > 0 and R.fechaPagado is null--donde el recibo está pendiente
		group by codigoPostal
		order by montoTotal;
	select top 1 T.codigoPostal, T.cantidadMonto from @tablaResultados T;
	end
	--morosos por cantidad de recibos pendientes
	declare @tableResultados table(codigoPostal int, cantidadPendientes int);
	insert into @tablaResultados
		select P.codigoPostal as codigoPostal, count(*) as cantidadDeRecibosPendientes
		from Propiedad P inner join Recibo R on R.FKPropiedad = P.id
		where datediff(day, R.fechaEmision, R.fechaLimite) > 0 and R.fechaPagado is null--donde el recibo está pendiente
		group by codigoPostal
		order by cantidadDeRecibosPendientes;
	select top 1 T.codigoPostal, T.cantidadPendientes from @tableResultados T;
end

