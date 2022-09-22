--Индекс – это объект базы данных, позволяющий ускорить поиск в определенной таблице, 
--так как при этом данные организуются в виде сбалансированного бинарного дерева поиска. 
--Индексы бывают кластеризованные, некластеризованные, уникальные, неуникальные и др.
use UNIVER
exec sp_helpindex AUDITORIUM

create table #explre
(
	cc int identity(1,1),
	tind int,
	tfield varchar(100)
);

set nocount on;
declare @iz int = 0;
while @iz < 20000
begin
	insert #explre(tind, tfield)
		values (floor(20000*rand()), replicate('qwert', 5));
	if(@iz %100 = 0)
		print @iz;
	set @iz = @iz + 1;
end;

--1 Кластеризованные индексы сортируют и хранят строки данных в таблицах или представлениях на основе их ключевых значений.
--Этими значениями являются столбцы, включенные в определение индекса. 
--Существует только один кластеризованный индекс для каждой таблицы, так как строки данных могут храниться в единственном порядке
SELECT * FROM #explre where tind between 1500 and 5500 order by tind;

checkpoint; --Создает контрольную точку вручную в базе данных SQL Server, к которой вы в данный момент подключены.

dbcc dropcleanbuffers;  --DBCC, которые действуют как команды консоли базы данных для SQL Server.

create clustered index #explre_cl on #explre(tind desc); --сортировка по возрастанию

drop index #explre_cl on #explre;

--2 В отличие от кластерных, они не перестраивают физическую структуру таблицы, а лишь организуют ссылки на соответствующие строки
--Составной индекс – это индекс, построенный по нескольким колонкам.
SELECT count(*)[количество строк] from #explre;

SELECT * from #explre;

CREATE index #explre_nonclu on #explre(tind, cc)

select * from #explre where tind > 1000 and cc < 5000

SELECT * from  #explre where  tind = 1200 and  cc > 3
--сли хотя бы одно из индексируемых значений зафиксировать (задать одно значение), то оптимизатор применит индекс.
drop index #explre_nonclu on #explre

--3Некластеризованный индекс покрытия запроса позволяет включить в состав индексной строки значения одного или нескольких неиндексируемых столбцов.

SELECT cc from #explre where tind > 15000  --планы выполнения запроса без применения индексов и с использованием индекса покрытия.

CREATE index #explre_tkey_x on #explre(tind) INCLUDE (cc) --индекс покрытия #EX_TKEY_X включает значения столбца CC (ключевое слово INCLUDE):


drop index #explre_tkey_x on #explre

--4
SELECT tind from  #explre where tind between 5000 and 19999; 
SELECT tind from  #explre where tind > 15000 and  tind < 20000  
SELECT tind from  #explre where tind = 17000

create index #explre_where on #explre(tind) where (tind >= 1500 and tind <= 20000) --фильтрующий индекс
-- Здесь фильтруемый индекс создается только для строк таблицы #EX, которые удовлетворяют логическому условию. 
--Стоимость запросов уменьшится.


drop index #explre_where on #explre

--5
-- Процесс образования неиспользуемых фрагментов памяти называется фрагментацией. 


--create table #Primer5
--(
--	cc int identity(1,1),
--	tind int,
--	tfield varchar(100)
--);

--set nocount on;
--declare @iy int = 0;
--while @iy < 20000
--begin
--	insert #Primer5(tind, tfield)
--		values (floor(20000*rand()), replicate('qwert', 5));
--	set @iy = @iy + 1;
--end;

----Процесс образования неиспользуемых фрагментов памяти называется фрагментацией. 
--CREATE index #Primer5_tind ON #Primer5(tind); 
--use tempdb
----Получить информацию о степени фрагментации индекса
--SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
--        FROM sys.dm_db_index_physical_stats(DB_ID(N'T	EMPDB'), 
--        OBJECT_ID(N'#Primer5'), NULL, NULL, NULL) ss
--			JOIN sys.indexes ii 
--				on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
--        WHERE name is not null;

--INSERT top(100000) #Primer5(tind, tfield) select tind, tfield from #Primer5;

--ALTER index #Primer5_tind on #Primer5 reorganize; --Реорганизация (REORGANIZE) выполняется быстро, но после нее фрагментация будет
----убрана только на самом нижнем уровне.


--ALTER index #Primer5_tind on #Primer5 rebuild with (online = off); --Операция перестройки (REBUILD) затрагивает все узлы дерева,
----поэтому после ее выполнения степень фрагментации равна нулю.
----В режиме OFFLINE таблица заранее блокируется для любого чтения или записи, а затем новый индекс
----строится из старого индекса, удерживая при этом блокировку таблицы

--drop index #Primer5_tind on #Primer5
--drop table #Primer5

--6 Параметр FILLFACTOR указывает процент заполнения индексных страниц нижнего уровня.
--Пусть индекс пересоздан со значением параметра FILLFACTOR равным 65: 


CREATE index #explre_tind on #explre(tind) with (fillfactor = 65);

INSERT top(50)percent INTO #explre(tind, tfield) 
		SELECT tind, tfield FROM #explre;

use tempdb
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
       FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),    
       OBJECT_ID(N'#explre_tind'), NULL, NULL, NULL) ss  JOIN sys.indexes ii 
                                     ON ss.object_id = ii.object_id and ss.index_id = ii.index_id  
                                                                                          WHERE name is not null;

drop table #explre
drop index #explre_tind on #explre

-------------------------555555

create table #TMPTB
(
INDTMP int,
CCTMP int identity(1,1),
TMPTEXT varchar(100)
)



set nocount on;
declare @i int = 0;
while @i<30000
begin
insert #TMPTB (INDTMP, TMPTEXT)
values(floor(40000*RAND()), REPLICATE('строка', 10));
if (@i % 100 = 0) print @i;
set @i = @i + 1;
end;

create index #TMPTB_INDTMP ON #TMPTB(INDTMP);

use tempdb;
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'),
OBJECT_ID(N'#TMPTB'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
WHERE name is not null;


set nocount on;
declare @a int = 0;
while @a<200000
begin
insert #TMPTB (INDTMP, TMPTEXT)
values(floor(10000*RAND()), REPLICATE('строка', 10));
if (@a % 100 = 0) print @a;
set @a = @a + 1;
end;

alter index #TMPTB_INDTMP ON #TMPTB reorganize; --еорганизация (REORGANIZE) выполняется быстро, но после нее фрагментация будет убрана 
--только на самом нижнем уровне.


alter index #TMPTB_INDTMP on #TMPTB rebuild with (online = off); --Операция перестройки (REBUILD) затрагивает все узлы дерева, 
--поэтому после ее выполнения степень фрагментации равна нулю.


drop index #TMPTB_INDTMP ON #TMPTB
drop table #TMPTB