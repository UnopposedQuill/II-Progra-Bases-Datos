use master
if exists(select * from sysdatabases where name = 'II_Progra') and not exists(select 1 from [II_Progra].[dbo].[DatosControlBase])
begin
	use [II_Progra];
	set nocount on;
	begin transaction;
	begin try
		--primero, traer los datos del XML dentro de la base de datos
		declare @datosXML xml = (select * from openrowset(bulk 'C:\BaseDatos\DataPrograII.xml',single_blob) as x);
		--inserción de Abonados
		insert into Abonado(nombre) select a.value('@Nombre[1]','nvarchar(20)')
				from @datosXML.nodes('/XML/Abonado') as x(Rec)
				cross apply @datosXML.nodes('/XML/Abonado/dbo.Abonado') as i(a);
		--inserción de Municipalidades
		insert into Municipalidad(nombre, diaEmision, diaLimite, interesesMorosidad, valorMetroCubicoAgua) 
				select	m.value('@Nombre[1]', 'nvarchar(20)'),
						m.value('@DiaEmite[1]', 'tinyint'),
						m.value('@DiaLimite[1]', 'tinyint'),
						m.value('@TasaInteres[1]', 'float'),
						m.value('@ValorMAgua[1]', 'float')
				from @datosXML.nodes('/XML/Municipalidades') as x(Rec)
				cross apply @datosXML.nodes('/XML/Municipalidades/dbo.Municipalidades') as i(m);
		--inserción de Tipos de Servicios
		insert into TipoServicio(nombre, valor, variable) 
				select	ts.value('@Nombre[1]', 'nvarchar(20)'),
						ts.value('@Valor[1]', 'float'),
						ts.value('@Variable[1]', 'bit')
				from @datosXML.nodes('/XML/TipoServicio') as x(Rec)
				cross apply @datosXML.nodes('/XML/TipoServicio/dbo.TipoServicio') as i(ts);
		--inserción de propiedades
		insert into Propiedad(numeroFinca, descripcion, valor, codigoPostal)
				select	p.value('@NumeroFinca[1]', 'int'),
						p.value('@Descripcion[1]', 'nvarchar(50)'),
						p.value('@Valor[1]', 'float'),
						p.value('@CodigoPostal[1]', 'nvarchar(10)')
				from @datosXML.nodes('/XML/Propiedades') as x(Rec)
				cross apply @datosXML.nodes('/XML/Propiedades/dbo.Propiedades') as i(p);
		--inserción de MunicipalidadXPropiedad, este es más complicado
		--select * from Municipalidad;
		insert into MunicipalidadXPropiedad(FKPropiedad, FKMunicipalidad)
				select	P.id,
						p.value('@IdMunicipalidad', 'int')
				from @datosXML.nodes('/XML/Propiedades') as x(Rec)
				cross apply @datosXML.nodes('/XML/Propiedades/dbo.Propiedades') as i(p)
				inner join Propiedad P on P.numeroFinca = p.value('@NumeroFinca', 'int');
		--inserción de AbonadoXPropiedad
		insert into AbonadoXPropiedad(FKPropiedad, FKAbonado)
				select	P.id,
						a.value('@IdAbonado', 'int')
				from @datosXML.nodes('/XML/Propiedades') as x(Rec)
				cross apply @datosXML.nodes('/XML/Propiedades/dbo.Propiedades') as i(a)
				inner join Propiedad P on P.numeroFinca = a.value('@NumeroFinca', 'int');
		--inserción de ServicioXPropiedad
		insert into ServicioXPropiedad(FKPropiedad, FKTipoServicio, fechaContratacion)
				select	P.id,
						sp.value('@IDServicio', 'int'),
						sp.value('@FechaContratacion', 'date')
				from @datosXML.nodes('/XML/ServicioXPropiedad') as x(Rec)
				cross apply @datosXML.nodes('/XML/ServicioXPropiedad/dbo.ServicioXPropiedad') as i(sp)
				inner join Propiedad P on P.numeroFinca = sp.value('@NumeroFinca', 'int');
		--inserción de ConsumoAgua
		insert into ConsumoAgua(FKPropiedad, fechaLectura, contadorMetrosCubicos)
				select	P.id,
						ca.value('@FechaLectura', 'date'),
						ca.value('@QM3', 'float')
				from @datosXML.nodes('/XML/ConsumoAgua') as x(Rec)
				cross apply @datosXML.nodes('/XML/ConsumoAgua/dbo.ConsumoAgua') as i(ca)
				inner join Propiedad P on P.numeroFinca = ca.value('@NumeroFinca', 'int');

		--inserción de Recibos
		exec SPgenerarRecibos;--genero recibos

		--ahora los pagos
		declare @tablaPagos table(
			id int identity primary key,--esto es para facilitarme las iteraciones
			FKPropiedad int,--coloco esta constraint aquí para poder parar esto antes si ocurre algún error
			fechaPago date
		);
		insert into @tablaPagos(FKPropiedad,fechaPago)
			select P.id,
				   pa.value('@FechaPago','date')
			from @datosXML.nodes('/XML/Pagos') as x(Rec)
			cross apply @datosXML.nodes('/XML/Pagos/dbo.Pagos') as i(pa)
			inner join Propiedad P on P.numeroFinca = pa.value('@NumeroFinca', 'int');--tomo todos los datos de los pagos
		
		update R
		set R.fechaPagado = T.fechaPago
		from Recibo as R 
		inner join @tablaPagos T on T.FKPropiedad = R.FKPropiedad
		--falta el where para asegurarme de que agarro el más viejo, ni uno ya pagado
		where R.fechaPagado is null--no repagaré un recibo
		and R.id = (select Top 1 R.id
					from Recibo R
					where R.FKPropiedad = T.FKPropiedad--me aseguro de que sea la propiedad correcta
					order by R.fechaEmision desc);--tomo el más viejo esa propiedad, y lo pago
		--ahora falta actualizar aquellos que pagaron de manera morosa.
		update R
		set R.totalPagado = case when datediff(day, R.fechaEmision, R.fechaLimite) > 0 then R.totalAPagarSinIntereses+0.5*P.valor
							else R.totalAPagarSinIntereses+R.totalAPagarSinIntereses*(M.interesesMorosidad/360)*datediff(day, R.fechaEmision, R.fechaLimite)+0.5*P.valor
							end
		from Recibo as R
		inner join Propiedad P on P.id = R.FKPropiedad
		inner join MunicipalidadXPropiedad MxP on MxP.FKPropiedad = R.FKPropiedad
		inner join Municipalidad M on M.id = MxP.FKMunicipalidad
		--ahora sólo coloco este 1, para indicar que los datos están listos
		insert into DatosControlBase(datosSimulacionListos) values(1);--ya todo está cargado
		commit;
	end try
	begin catch
		rollback;
		select ERROR_MESSAGE();
	end catch
end
