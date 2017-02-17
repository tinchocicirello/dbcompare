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