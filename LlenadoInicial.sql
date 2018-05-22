use master
if exists(select * from sysdatabases where name = 'II_Progra') and not exists(select 1 from [II_Progra].[dbo].[DatosControlBase])
begin
	use [II_Progra];
	set nocount on;
	begin transaction;
	begin try
		--primero, traer los datos del XML dentro de la base de datos
		declare @datosXML xml = (select * from openrowset(bulk 'C:\BaseDatos\DataPrograII.xml',single_blob) as x);
		
		insert into Abonado(nombre) select ab.value('@Nombre[1]','nvarchar(20)')
				from @datosXML.nodes('/XML/Abonado') as x(Rec)
				cross apply @datosXML.nodes('XML/Abonado/dbo.Abonado') as i(ab);
		/*
		--para todas las iteraciones necesito dos variables, una de contador de iteraciones y el otro
		--para llevar la cuenta de cuántos llevo
		declare @numeroElementos int, @contadorElementos int = 0;
		--primero, llenar los abonados
		set @numeroElementos = @datosXML.value('count(/XML/Abonado/dbo.Abonado)', 'int');--consigo la cantidad de abonados
		declare @nombreAbonado nvarchar(20);
		while (@contadorElementos < @numeroElementos)
		begin
			set @nombreAbonado = @datosXML.value('(/XML/Abonado/dbo.Abonado/@Nombre)[1]', 'nvarchar(20)');
			exec SPinsertarAbonado @nombreAbonado;
			set @contadorElementos = @contadorElementos + 1;
		end
		*/
		commit;
	end try
	begin catch
		rollback;
	end catch
end
