-- ver si la cantidad de tablas es la misma en las 2 bases
select case when 
(select COUNT(*) from AdventureWorks2014.INFORMATION_SCHEMA.TABLES)=
(select COUNT(*) from AdventureWorksClone2.INFORMATION_SCHEMA.TABLES) 
then 'iguales' else 'diferentes'end;

-- ver todas las tablas del mismo nombre
select N1.TABLE_NAME, M1.TABLE_NAME from AdventureWorks2014.INFORMATION_SCHEMA.TABLES N1
inner join AdventureWorks.INFORMATION_SCHEMA.TABLES M1
on N1.TABLE_NAME=M1.TABLE_NAME COLLATE Latin1_General_CS_AS;

-- ver todas las tablas que no estan en la bd 2
select N1.TABLE_NAME, M1.TABLE_NAME from AdventureWorks2014.INFORMATION_SCHEMA.TABLES N1
left join AdventureWorks.INFORMATION_SCHEMA.TABLES M1
on N1.TABLE_NAME=M1.TABLE_NAME COLLATE Latin1_General_CS_AS where M1.TABLE_NAME is null;

-- ver todas las tablas que no estan en la bd 1
select N1.TABLE_NAME, M1.TABLE_NAME from AdventureWorks2014.INFORMATION_SCHEMA.TABLES N1
right join AdventureWorks.INFORMATION_SCHEMA.TABLES M1
on N1.TABLE_NAME=M1.TABLE_NAME COLLATE Latin1_General_CS_AS where N1.TABLE_NAME is null;

-- ver si la cantidad de esquemas es la misma en las 2 bases
select case when 
(select COUNT(*) from AdventureWorks2014.INFORMATION_SCHEMA.SCHEMATA)=
(select COUNT(*) from AdventureWorksClone2.INFORMATION_SCHEMA.SCHEMATA) 
then 'iguales' else 'diferentes'end;

-- ver todos los esquemas del mismo nombre
select N1.SCHEMA_NAME, M1.SCHEMA_NAME from AdventureWorks2014.INFORMATION_SCHEMA.SCHEMATA N1
inner join AdventureWorks.INFORMATION_SCHEMA.SCHEMATA M1
on N1.SCHEMA_NAME=M1.SCHEMA_NAME COLLATE Latin1_General_CS_AS;

-- ver todos los esquemas que no estan en la bd 2
select N1.SCHEMA_NAME, M1.SCHEMA_NAME from AdventureWorks2014.INFORMATION_SCHEMA.SCHEMATA N1
left join AdventureWorks.INFORMATION_SCHEMA.SCHEMATA M1
on N1.SCHEMA_NAME=M1.SCHEMA_NAME COLLATE Latin1_General_CS_AS where M1.SCHEMA_NAME is null;

-- ver todos los esquemas que no estan en la bd 1
select N1.SCHEMA_NAME, M1.SCHEMA_NAME from AdventureWorks2014.INFORMATION_SCHEMA.SCHEMATA  N1
right join AdventureWorks.INFORMATION_SCHEMA.SCHEMATA  M1
on N1.SCHEMA_NAME=M1.SCHEMA_NAME COLLATE Latin1_General_CS_AS where N1.SCHEMA_NAME is null;

-- IMPORTANTE!!!!!
-- query que devuelve que tablas estan y no estan en la base de datos origen por medio de un print
declare @schemaName nvarchar(50)
declare @tableName nvarchar(50)

declare cursor1 cursor for
select TABLE_SCHEMA, TABLE_NAME from AdventureWorks2014.INFORMATION_SCHEMA.TABLES
 order by TABLE_SCHEMA,TABLE_NAME

open cursor1

fetch next from cursor1 into @schemaName,@tableName
while @@FETCH_STATUS=0
begin
if exists (select TABLE_SCHEMA, TABLE_NAME from AdventureWorks.INFORMATION_SCHEMA.TABLES 
where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName)
print 'coincidencia' /* @schemaName+' '+@tableName+' se encuentra en las dos tablas'*/
else
print @schemaName+' '+@tableName+' no se encuentra en la tabla destino'
fetch next from cursor1 into @schemaName,@tableName

end

close cursor1
deallocate cursor1

--IMPORTANTE!!!!!
------------------------------------------------------------------------------------------------
--creacion de dos bases de datos para su comparacion, la tabla1 es igual en las 2, la tabla2--
--tiene columnas distintas, la tabla3 no existe en la base de datos destino-------------------
----------------------------------------------------------------------------------------------

create database ejemplo1
use ejemplo1 

create table tabla1(
columna1 int,
columna2 varchar(50),
columna3 date,
columna4 int
)

create table tabla2(
columna1 int,
columna2 varchar(50),
columna3 date,
columna4 int
)

create table tabla3(
columna1 int,
columna2 varchar(50),
columna3 date
)

ALTER TABLE Tabla1 ALTER COLUMN columna1 INTEGER NOT NULL
alter table tabla1 add constraint PK_tabla1_columna1 primary key (columna1)
alter table tabla1 add constraint UN_tabla1_columna2 unique (columna2)
alter table tabla1 add constraint CK_tabla1_columna3 check (columna3>'1-1-2015')
ALTER TABLE Tabla1 ALTER COLUMN columna4 INTEGER NOT NULL
alter table tabla1 add constraint DF_tabla1_columna4 default 1 for columna4 

ALTER TABLE tabla3 ALTER COLUMN columna1 INTEGER NOT NULL
alter table tabla3 add constraint PK_tabla3_columna1 primary key  (columna1)

ALTER TABLE tabla2 ALTER COLUMN columna1 INTEGER NOT NULL
alter table tabla2 add constraint FK_tabla2_columna1_tabla1_columna1 foreign key (columna1) references tabla1 (columna1) 
alter table tabla2 add constraint FK_tabla2_columna1_tabla3_columna1 foreign key (columna1) references tabla3 (columna1)
alter table tabla2 add constraint UN_tabla2_columna2 unique (columna2)
alter table tabla2 add constraint DF_tabla2_columna3 default '1-1-2015' for columna3

-- OJO!!!
drop table tabla1;
drop table tabla2;
drop table tabla3;

create database ejemplo2
use ejemplo2 

create table tabla1(
columna1 int,
columna2 varchar(50),
columna3 date,
columna4 int
)

create table tabla2(
columna1 int,
columna2 varchar(50),
columna3 date,
columna4 varchar(50)
)

create table tabla4(
columna1 int,
columna2 varchar(50),
columna3 date
)

ALTER TABLE Tabla1 ALTER COLUMN columna1 INTEGER NOT NULL
alter table tabla1 add constraint PK_tabla1_columna1 primary key (columna1)
alter table tabla1 add constraint UN_tabla1_columna2 unique (columna2)
alter table tabla1 add constraint CK_tabla1_columna3 check (columna3>'1-1-2015')
ALTER TABLE Tabla1 ALTER COLUMN columna4 INTEGER NOT NULL
alter table tabla1 add constraint DF_tabla1_columna4 default 1 for columna4 

ALTER TABLE tabla4 ALTER COLUMN columna1 INTEGER NOT NULL
alter table tabla4 add constraint PK_tabla4_columna1 primary key  (columna1)

ALTER TABLE tabla2 ALTER COLUMN columna1 INTEGER NOT NULL
alter table tabla2 add constraint FK_tabla2_columna1_tabla1_columna1 foreign key (columna1) references tabla1 (columna1) 
alter table tabla2 add constraint FK_tabla2_columna1_tabla4_columna1 foreign key (columna1) references tabla4 (columna1)
alter table tabla2 add constraint UN_tabla2_columna2 unique (columna2)
alter table tabla2 add constraint DF_tabla2_columna3 default '3-2-2015' for columna3

--OJO!!!
drop table tabla1;
drop table tabla2;
drop table tabla4;

----------------------------------------------------------------------------------------------
--Bloque para comparar las tablas y las columnas de las 2 bases-------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

use master

declare @schemaName nvarchar(50)
declare @tableName nvarchar(50)
declare @columnName nvarchar(50)
declare @typeName nvarchar(50)

declare cursor1 cursor for
select TABLE_SCHEMA, TABLE_NAME from ejemplo1.INFORMATION_SCHEMA.TABLES
order by TABLE_SCHEMA,TABLE_NAME

open cursor1

fetch next from cursor1 into @schemaName,@tableName
while @@FETCH_STATUS=0
begin
	if exists (select TABLE_SCHEMA, TABLE_NAME from ejemplo2.INFORMATION_SCHEMA.TABLES 
	where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName)
		begin
			print /*'coincidencia'*/  @schemaName+' '+@tableName+' se encuentra en las dos tablas'
			declare cursor2 cursor for
			select COLUMN_NAME,DATA_TYPE from ejemplo1.INFORMATION_SCHEMA.COLUMNS
			where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName

			open cursor2

			fetch next from cursor2 into @columnName,@typeName
			while @@FETCH_STATUS=0
			begin
				if exists (select COLUMN_NAME,DATA_TYPE from ejemplo2.INFORMATION_SCHEMA.COLUMNS
				where TABLE_SCHEMA=@schemaName and TABLE_NAME=@tableName and COLUMN_NAME=@columnName and DATA_TYPE=@typeName)
						print/*'			coincide'*/ '			la columna '+@columnName+' coincide'
					else
						print '			la columna '+@columnName+' no coincide'
					fetch next from cursor2 into @columnName,@typeName
			end

			close cursor2
			deallocate cursor2

		end
			
	else
		print (@schemaName+' '+@tableName+' no se encuentra en la tabla destino')
	fetch next from cursor1 into @schemaName,@tableName

end

close cursor1
deallocate cursor1

----------------------------------------------------------------------------------------------
--direcciones donde se guarda informacion sobre las bases de datos----------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

select * from ejemplo1.information_schema.CONSTRAINT_COLUMN_USAGE
select * from ejemplo1.information_schema.CONSTRAINT_TABLE_USAGE
select * from ejemplo1.information_schema.KEY_COLUMN_USAGE
select * from ejemplo2.INFORMATION_SCHEMA.KEY_COLUMN_USAGE
select * from ejemplo1.INFORMATION_SCHEMA.CHECK_CONSTRAINTS
select * from ejemplo2.INFORMATION_SCHEMA.CHECK_CONSTRAINTS
select * from ejemplo1.information_schema.COLUMNS
select * from ejemplo1.INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
select * from ejemplo1.INFORMATION_SCHEMA.COLUMN_PRIVILEGES
select * from ejemplo1.information_schema.COLUMNS
select * from ejemplo1.INFORMATION_SCHEMA.TABLE_CONSTRAINTS

----------------------------------------------------------------------------------------------
--funcion para encontrar si la columna admite nulls o no en las dos bases---------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


if (select IS_NULLABLE from ejemplo1.information_schema.COLUMNS where TABLE_NAME='tabla1' and COLUMN_NAME='columna1')=
(select IS_NULLABLE from ejemplo2.information_schema.COLUMNS where TABLE_NAME='tabla1' and COLUMN_NAME='columna3')
print 'iguales'
else
print 'no iguales'

----------------------------------------------------------------------------------------------
--compara todas las primary key, foreing key y uniques de las dos bases (puede modificarse----
--para mostrar coincidencias en en una tabla o en una columna)--------------------------------
----------------------------------------------------------------------------------------------

if exists (select CONSTRAINT_NAME from ejemplo1.INFORMATION_SCHEMA.KEY_COLUMN_USAGE
/*where TABLE_NAME='tabla3' and COLUMN_NAME='columna1'*/)
begin

declare @nombreTemporal nvarchar(50)
declare @tipoTemporal nvarchar(50)

declare cursor3 cursor for
select ejemplo1.INFORMATION_SCHEMA.KEY_COLUMN_USAGE.CONSTRAINT_NAME,
ejemplo1.INFORMATION_SCHEMA.TABLE_CONSTRAINTS.CONSTRAINT_TYPE
from ejemplo1.INFORMATION_SCHEMA.KEY_COLUMN_USAGE inner join
ejemplo1.INFORMATION_SCHEMA.TABLE_CONSTRAINTS on 
ejemplo1.INFORMATION_SCHEMA.KEY_COLUMN_USAGE.CONSTRAINT_NAME
=ejemplo1.INFORMATION_SCHEMA.TABLE_CONSTRAINTS.CONSTRAINT_NAME
/*where ejemplo1.INFORMATION_SCHEMA.KEY_COLUMN_USAGE.TABLE_NAME='tabla3' 
and ejemplo1.INFORMATION_SCHEMA.KEY_COLUMN_USAGE.COLUMN_NAME='columna1'*/

open cursor3

fetch next from cursor3 into @nombreTemporal,@tipoTemporal

while @@FETCH_STATUS=0
			begin
			if exists (select CONSTRAINT_NAME,CONSTRAINT_TYPE from 
			ejemplo2.INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME=@nombreTemporal
			and CONSTRAINT_TYPE=@tipoTemporal)
			begin
				print @nombreTemporal+' '+@tipoTemporal+' existe en las 2 bases'
			end
			else
			begin
			print  @nombreTemporal+' '+@tipoTemporal+' no existe en la base destino'
			end
				fetch next from cursor3 into @nombreTemporal,@tipoTemporal
			end

close cursor3
deallocate cursor3
end
else
print 'no hay nada'