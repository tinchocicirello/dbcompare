-- creamos la base que usaremos para guardar lo que nos arroje la comparacion --

create database TpFinal

use [TpFinal]

-- creamos la tabla donde guardaremos la descipcion del error/coincidencia y la fecha --

create table comparaciontablas(
	id int PRIMARY KEY IDENTITY NOT NULL,
	descripcion varchar(100) NOT NULL,
	fecha datetime NOT NULL); 


-- creacion del procedimiento
create procedure compararBasesEjemplo @db1 varchar(50), @db2 varchar(50)
as
begin

exec(
'declare @schemaName nvarchar(50)
declare @tableName nvarchar(50)
declare @columnName nvarchar(50)
declare @typeName nvarchar(50)
declare @nullName nvarchar(50)
declare @defaulName nvarchar(50)
declare cursor1 cursor for
select TABLE_SCHEMA, TABLE_NAME from '+@db1+'.INFORMATION_SCHEMA.TABLES
order by TABLE_SCHEMA,TABLE_NAME
open cursor1
fetch next from cursor1 into @schemaName,@tableName
while @@FETCH_STATUS=0
begin
	if exists (select TABLE_SCHEMA, TABLE_NAME from '+@db2+'.INFORMATION_SCHEMA.TABLES 
	where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName)
		begin
			insert into comparaciontablas(descripcion,fecha) values(@schemaName+'' ''+@tableName+'' se encuentra en las dos bases'',getdate())
			declare cursor2 cursor for
			select COLUMN_NAME,DATA_TYPE from '+@db1+'.INFORMATION_SCHEMA.COLUMNS
			where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName
			open cursor2
			fetch next from cursor2 into @columnName,@typeName
			while @@FETCH_STATUS=0
			begin
				if exists (select COLUMN_NAME,DATA_TYPE from '+@db2+'.INFORMATION_SCHEMA.COLUMNS
				where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName and DATA_TYPE=@typeName)
				begin
						insert into comparaciontablas(descripcion,fecha) values(''las  ''+@columnName+'' de las ''+@tablename+''coinciden'',getdate())
						if (select IS_NULLABLE from '+@db1+'.information_schema.COLUMNS where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName)=
						(select IS_NULLABLE from '+@db2+'.information_schema.COLUMNS where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName)
						begin
							set @nullName=(select IS_NULLABLE from '+@db1+'.information_schema.COLUMNS where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName)
							insert into comparaciontablas(descripcion,fecha) values(''el valor ''+@nullname+'' es igual en ambas columnas de la ''+@tablename,getdate())
							
						end
						else
						begin
							set @nullName=(select IS_NULLABLE from '+@db1+'.information_schema.COLUMNS where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName)
							insert into comparaciontablas(descripcion,fecha) values(''el valor ''+@nullname+'' es distinto en ambas columnas de la ''+@tablename,getdate())
						end
						if (select COLUMN_DEFAULT from '+@db1+'.information_schema.COLUMNS where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName)is not null
						if (select COLUMN_DEFAULT from '+@db1+'.information_schema.COLUMNS where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName)=
						(select COLUMN_DEFAULT from '+@db2+'.information_schema.COLUMNS where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName)
						begin
							set @defaulName=(select COLUMN_DEFAULT from '+@db1+'.information_schema.COLUMNS where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName)
							insert into comparaciontablas(descripcion,fecha) values(''el valor ''+@defaulName+'' es igual en ambas columnas de la ''+@tablename,getdate())
							
						end
						else
						begin
							set @defaulName=(select COLUMN_DEFAULT from '+@db1+'.information_schema.COLUMNS where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName)
							insert into comparaciontablas(descripcion,fecha) values(''el valor ''+@defaulName+'' es distinto en ambas columnas de la ''+@tablename,getdate())
						end
						if exists (select CONSTRAINT_NAME from '+@db1+'.INFORMATION_SCHEMA.KEY_COLUMN_USAGE
							where TABLE_NAME=@tableName and COLUMN_NAME=@columnName)
							begin
								declare @nombreTemporal nvarchar(50)
								declare @tipoTemporal nvarchar(50)
								declare cursor3 cursor for
								select '+@db1+'.INFORMATION_SCHEMA.KEY_COLUMN_USAGE.CONSTRAINT_NAME,
								'+@db1+'.INFORMATION_SCHEMA.TABLE_CONSTRAINTS.CONSTRAINT_TYPE
								from '+@db1+'.INFORMATION_SCHEMA.KEY_COLUMN_USAGE inner join
								'+@db1+'.INFORMATION_SCHEMA.TABLE_CONSTRAINTS on 
								'+@db1+'.INFORMATION_SCHEMA.KEY_COLUMN_USAGE.CONSTRAINT_NAME
								='+@db1+'.INFORMATION_SCHEMA.TABLE_CONSTRAINTS.CONSTRAINT_NAME
								where '+@db1+'.INFORMATION_SCHEMA.KEY_COLUMN_USAGE.TABLE_NAME=@tableName
								and '+@db1+'.INFORMATION_SCHEMA.KEY_COLUMN_USAGE.COLUMN_NAME=@columnName
								open cursor3
								fetch next from cursor3 into @nombreTemporal,@tipoTemporal
								while @@FETCH_STATUS=0
								begin
									if exists (select CONSTRAINT_NAME,CONSTRAINT_TYPE from 
									'+@db2+'.INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME=@nombreTemporal
									and CONSTRAINT_TYPE=@tipoTemporal)
									begin
										insert into comparaciontablas(descripcion,fecha) values(@nombreTemporal+'' ''+@tipoTemporal+'' existe en las  2 bases'',getdate())
									end
									else
									begin
										insert into comparaciontablas(descripcion,fecha) values(@nombreTemporal+'' ''+@tipoTemporal+'' no existe en la base destino'',getdate())
									end
									fetch next from cursor3 into @nombreTemporal,@tipoTemporal
								end
								close cursor3
								deallocate cursor3
								end
						if exists (select '+@db1+'.INFORMATION_SCHEMA.CHECK_CONSTRAINTS.CONSTRAINT_NAME 
from '+@db1+'.INFORMATION_SCHEMA.CHECK_CONSTRAINTS
inner join '+@db1+'.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE on
'+@db1+'.INFORMATION_SCHEMA.CHECK_CONSTRAINTS.CONSTRAINT_NAME=
'+@db1+'.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE.CONSTRAINT_NAME
where TABLE_NAME=@tableName and COLUMN_NAME=@columnName)
begin
declare @nombreTemporal2 nvarchar(50)
declare @clausulaTemporal nvarchar(50)
declare cursor4 cursor for
select '+@db1+'.INFORMATION_SCHEMA.CHECK_CONSTRAINTS.CONSTRAINT_NAME,
'+@db1+'.INFORMATION_SCHEMA.CHECK_CONSTRAINTS.CHECK_CLAUSE
from '+@db1+'.INFORMATION_SCHEMA.CHECK_CONSTRAINTS inner join
'+@db1+'.information_schema.CONSTRAINT_COLUMN_USAGE on 
'+@db1+'.INFORMATION_SCHEMA.CHECK_CONSTRAINTS.CONSTRAINT_NAME
='+@db1+'.information_schema.CONSTRAINT_COLUMN_USAGE.CONSTRAINT_NAME
where '+@db1+'.information_schema.CONSTRAINT_COLUMN_USAGE.TABLE_NAME=@tableName and
'+@db1+'.information_schema.CONSTRAINT_COLUMN_USAGE.COLUMN_NAME=@columnName
open cursor4
fetch next from cursor4 into @nombreTemporal2,@clausulaTemporal
while @@FETCH_STATUS=0
			begin
			if exists (select CONSTRAINT_NAME from 
			'+@db2+'.INFORMATION_SCHEMA.CHECK_CONSTRAINTS
			where CONSTRAINT_NAME=@nombreTemporal2 and CHECK_CLAUSE=@clausulaTemporal)
			begin
				insert into comparaciontablas(descripcion,fecha) values(@nombreTemporal2+'' ''+@clausulaTemporal+'' existe en las 2 bases'',getdate())
			end
			else
			begin
				insert into comparaciontablas(descripcion,fecha) values(@nombreTemporal2+'' ''+@clausulaTemporal+'' no existe en la base destino'',getdate())
			end
				fetch next from cursor4 into @nombreTemporal2,@clausulaTemporal
			end
close cursor4
deallocate cursor4
end
				end
					else
						insert into comparaciontablas(descripcion,fecha) values(''la ''+@columnName+'' no coincide'',getdate())
					fetch next from cursor2 into @columnName,@typeName
			end
			close cursor2
			deallocate cursor2
		end
			
	else
		insert into comparaciontablas(descripcion,fecha) values(@schemaName+'' ''+@tableName+'' no se encuentra en la base destino'',getdate())
	fetch next from cursor1 into @schemaName,@tableName
end
close cursor1
deallocate cursor1
')

end


--llamar el procedimiento

exec compararBasesEjemplo ejemplo1, ejemplo2

select * from dbo.comparaciontablas

--eliminar el procedimiento

drop procedure compararBasesEjemplo



-- consultamos todos los error [SE PUEDE FILTRAR POR FECHA Y HORA PARA VER EN DETALLE LOS QUE ACABAMOS DE GUARDAR] --
select *
from comparaciontablas


-- borra registros de la tabla
delete from comparaciontablas