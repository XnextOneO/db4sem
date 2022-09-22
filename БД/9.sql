--������ � ��� ������ ���� ������, ����������� �������� ����� � ������������ �������, 
--��� ��� ��� ���� ������ ������������ � ���� ����������������� ��������� ������ ������. 
--������� ������ ����������������, ������������������, ����������, ������������ � ��.
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

--1 ���������������� ������� ��������� � ������ ������ ������ � �������� ��� �������������� �� ������ �� �������� ��������.
--����� ���������� �������� �������, ���������� � ����������� �������. 
--���������� ������ ���� ���������������� ������ ��� ������ �������, ��� ��� ������ ������ ����� ��������� � ������������ �������
SELECT * FROM #explre where tind between 1500 and 5500 order by tind;

checkpoint; --������� ����������� ����� ������� � ���� ������ SQL Server, � ������� �� � ������ ������ ����������.

dbcc dropcleanbuffers;  --DBCC, ������� ��������� ��� ������� ������� ���� ������ ��� SQL Server.

create clustered index #explre_cl on #explre(tind desc); --���������� �� �����������

drop index #explre_cl on #explre;

--2 � ������� �� ����������, ��� �� ������������� ���������� ��������� �������, � ���� ���������� ������ �� ��������������� ������
--��������� ������ � ��� ������, ����������� �� ���������� ��������.
SELECT count(*)[���������� �����] from #explre;

SELECT * from #explre;

CREATE index #explre_nonclu on #explre(tind, cc)

select * from #explre where tind > 1000 and cc < 5000

SELECT * from  #explre where  tind = 1200 and  cc > 3
--��� ���� �� ���� �� ������������� �������� ������������� (������ ���� ��������), �� ����������� �������� ������.
drop index #explre_nonclu on #explre

--3������������������ ������ �������� ������� ��������� �������� � ������ ��������� ������ �������� ������ ��� ���������� ��������������� ��������.

SELECT cc from #explre where tind > 15000  --����� ���������� ������� ��� ���������� �������� � � �������������� ������� ��������.

CREATE index #explre_tkey_x on #explre(tind) INCLUDE (cc) --������ �������� #EX_TKEY_X �������� �������� ������� CC (�������� ����� INCLUDE):


drop index #explre_tkey_x on #explre

--4
SELECT tind from  #explre where tind between 5000 and 19999; 
SELECT tind from  #explre where tind > 15000 and  tind < 20000  
SELECT tind from  #explre where tind = 17000

create index #explre_where on #explre(tind) where (tind >= 1500 and tind <= 20000) --����������� ������
-- ����� ����������� ������ ��������� ������ ��� ����� ������� #EX, ������� ������������� ����������� �������. 
--��������� �������� ����������.


drop index #explre_where on #explre

--5
-- ������� ����������� �������������� ���������� ������ ���������� �������������. 


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

----������� ����������� �������������� ���������� ������ ���������� �������������. 
--CREATE index #Primer5_tind ON #Primer5(tind); 
--use tempdb
----�������� ���������� � ������� ������������ �������
--SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
--        FROM sys.dm_db_index_physical_stats(DB_ID(N'T	EMPDB'), 
--        OBJECT_ID(N'#Primer5'), NULL, NULL, NULL) ss
--			JOIN sys.indexes ii 
--				on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
--        WHERE name is not null;

--INSERT top(100000) #Primer5(tind, tfield) select tind, tfield from #Primer5;

--ALTER index #Primer5_tind on #Primer5 reorganize; --������������� (REORGANIZE) ����������� ������, �� ����� ��� ������������ �����
----������ ������ �� ����� ������ ������.


--ALTER index #Primer5_tind on #Primer5 rebuild with (online = off); --�������� ����������� (REBUILD) ����������� ��� ���� ������,
----������� ����� �� ���������� ������� ������������ ����� ����.
----� ������ OFFLINE ������� ������� ����������� ��� ������ ������ ��� ������, � ����� ����� ������
----�������� �� ������� �������, ��������� ��� ���� ���������� �������

--drop index #Primer5_tind on #Primer5
--drop table #Primer5

--6 �������� FILLFACTOR ��������� ������� ���������� ��������� ������� ������� ������.
--����� ������ ���������� �� ��������� ��������� FILLFACTOR ������ 65: 


CREATE index #explre_tind on #explre(tind) with (fillfactor = 65);

INSERT top(50)percent INTO #explre(tind, tfield) 
		SELECT tind, tfield FROM #explre;

use tempdb
SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
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
values(floor(40000*RAND()), REPLICATE('������', 10));
if (@i % 100 = 0) print @i;
set @i = @i + 1;
end;

create index #TMPTB_INDTMP ON #TMPTB(INDTMP);

use tempdb;
SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'),
OBJECT_ID(N'#TMPTB'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
WHERE name is not null;


set nocount on;
declare @a int = 0;
while @a<200000
begin
insert #TMPTB (INDTMP, TMPTEXT)
values(floor(10000*RAND()), REPLICATE('������', 10));
if (@a % 100 = 0) print @a;
set @a = @a + 1;
end;

alter index #TMPTB_INDTMP ON #TMPTB reorganize; --������������ (REORGANIZE) ����������� ������, �� ����� ��� ������������ ����� ������ 
--������ �� ����� ������ ������.


alter index #TMPTB_INDTMP on #TMPTB rebuild with (online = off); --�������� ����������� (REBUILD) ����������� ��� ���� ������, 
--������� ����� �� ���������� ������� ������������ ����� ����.


drop index #TMPTB_INDTMP ON #TMPTB
drop table #TMPTB