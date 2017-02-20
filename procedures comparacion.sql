-----------------------------------------------------------------------------------------
-------------- procedimiento para insertar error en la tabla resultados------------------
-----------------------------------------------------------------------------------------
CREATE PROCEDURE insertarErrorTabla @nombreTabla varchar(20), @error varchar(80)
as

insert into comparaciontablas(descripcion)
values (''+@nombreTabla+@error+'')

GO

-----------------------------------------------------------------------------------------
-------procedimiento para comparar bases, pasar el valor de las bases a comparar---------
-----------------------------------------------------------------------------------------


---esto sigue tirando error al querer usar el parametro como from del select-------------
---ya probe con un exec(query) y no funciono tengo que seguir googleando-----------------

CREATE PROCEDURE compararBases (
	@db1 varchar(50),
	@db2 varchar(50)
	)
AS

-- query que devuelve que tablas estan y no estan en la base de datos origen por medio de un print
declare @schemaName nvarchar(50)
declare @tableName nvarchar(50)

declare cursor1 cursor for
	 select TABLE_SCHEMA, TABLE_NAME 
		from @db1.INFORMATION_SCHEMA.TABLES
	order by TABLE_SCHEMA,TABLE_NAME

open cursor1

fetch next from cursor1 into @schemaName,@tableName
while @@FETCH_STATUS=0
begin
if exists (
	select TABLE_SCHEMA, TABLE_NAME from @db2.INFORMATION_SCHEMA.TABLES 
	where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName)
	print @schemaName+' '+@tableName+' se encuentra en las dos tablas'	
else
	EXEC insertarErrorTabla @nombreTabla = @tableName, @error = ' no se encuentra en la base de datos de destino';
fetch next from cursor1 into @schemaName,@tableName

end

close cursor1
deallocate cursor1
GO


EXEC compararBases @db1 = 'ejemplo1', @db2 = 'ejemplo2';

drop procedure compararBases;