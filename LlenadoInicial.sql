use master
if exists(select * from sysdatabases where name = 'II_Progra') and not exists(select 1 from [II_Progra].[dbo].[DatosControlBase])
begin
	use [II_Progra];
	set nocount on;
	begin transaction
	begin try

		commit;
	end try
	begin catch
		rollback;
	end catch
end
