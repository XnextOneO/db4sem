--Task1
--declare ��� ���������� ���������� 
Declare @first int = 1, @second char = 'c', @trd varchar(4),
@date datetime, @time time, @sint smallint, @tint tinyint,
--ISNUMERIC ����������, �������� �� ��������� ���������� �������� �����
@xnumeric numeric(12,5) 
-- ���������� ��������� �������� � ��������� ����������
SET @trd = '����'
--SELECT ��������� ���������� ���������� ��������� ��������. 

select @first = 25
select @first first

select @date = '12-12-2022',
@time = '1:53', @sint = 1, @tint = 2
select @date , @time , @sint, @tint 

print '� ����� � ' + @trd + '. ����� ������ -' + convert(varchar,@time)

--Task2 

use UNIVER

Declare @TotalCapacity int = (select sum(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM),
@totalaud int,
@smallaud int,
@smallaudpercent numeric(8,3),
@avgcapacity numeric(8,3)
if @TotalCapacity > 200 --������� ���������� ���������, ������� ����������� ���������,
--���������� ���������, ����������� ������� ������ �������, � ������� ����� ���������
begin

set @avgcapacity = (select avg(AUDITORIUM_CAPACITY) FROM AUDITORIUM)
set @totalaud = (select count(*) from AUDITORIUM)
set @smallaud = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY < @avgcapacity)
set @smallaudpercent = @smallaud / @totalaud

Print 'AVG - ' + convert(varchar,@avgcapacity) + '. Total - ' + convert(varchar,@totalaud) + '. Small auditorim - ' + convert(varchar,@smallaud) + '. Percent - ' + convert(varchar,@smallaudpercent) + '.'
end
else print '����� ����������� - ' + convert(varchar,@TotalCapacity)

--task3

print '����� ������������ �����: ' + cast(@@rowcount as varchar) --3. ���������� ���������� --����� ������������ �����
print '������ SQL Server: ' + cast(@@version as varchar)
print '��������� ������������� ��������: ' + cast(@@spid as varchar) --��������� ������������� ��������
print '��� ��������� ������: ' + cast(@@error as varchar)
print '��� �������: ' + cast(@@servername as varchar)
print '������� ����������� ����������: ' + cast(@@trancount as varchar) --������� ����������� ����������
print '�������� ���������� ���������� ����� ��������������� ������: ' + cast(@@fetch_status as varchar)
print '������� ����������� ������� ���������: ' + cast(@@nestlevel as varchar) --������� �����������

--task4
--4
--4.1
declare @t int = 2,
@x int = 1,
@z float;
if (@t > @x) 
set @z = power(sin(@t), 2);
else if (@t < @x)
set @z = 4 * (@t + @x);
else
set @z = 1 - exp(@x-2);
print @z;
--4.2
declare @name varchar(30) = '�������� ������� ����������',
@newName nvarchar(50) = '',
@symbol nchar(1),
@item int = 1,
@wordCount int = 0,
@isFirstLetter int = 0;
while @item < len(@name)  -- LEN(��������� ���������) ���������� ����� �������� � ������, ���������� ��������� ����������
begin
set @symbol = substring(@name, @item ,1); --��������� ������� �� ��������� ��� ����� �������� �����, ������� �� �������� ��������� �������
if (@symbol = ' ')
begin
select @wordCount = @wordCount + 1,
@isFirstLetter = 1,
@newName = @newName + @symbol
end
else if (@isFirstLetter = 1)
begin
select @isFirstLetter = 0,
@newName = @newName + @symbol
end
else if (@wordCount = 0)
begin
select @newName = @newName + @symbol
end
set @item = @item + 1
end
print @newName;
--4.3
use UNIVER -- ���������� �������� �������, ���������� ����� ����� ���������� ���������
select STUDENT.NAME, STUDENT.BDAY, (datediff(YY, STUDENT.BDAY, GETDATE())) as �������  
from STUDENT
where month(STUDENT.BDAY) = month(sysdatetime()) + 1;  --month - ���������� ����� 
--4.4
use UNIVER
select STUDENT.IDGROUP as 'group', count(*) as '���������� ���������', DATEPART(weekday, PROGRESS.PDATE) as '���� ������'
from STUDENT
inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
where SUBJECT.SUBJECT = '����'
group by STUDENT.IDGROUP, PROGRESS.PDATE;
--Task5 

declare @totalstud int = (select count(*) from STUDENT)
if(@totalstud > 55)
begin
Print '� ������� ������ 55 ���������'
end
else begin
Print '� ������� ������ 55 ���������'
end

--task6
use UNIVER --6 case  ������ ��� ������������ ������ �� ���������� ��������� ��������.
 
select (case
when NOTE between 0 and 3 then '�� ����'
when NOTE between 4 and 5 then '���� �� 4-5'
when NOTE between 6 and 7 then '���� �� 6-7'
when NOTE between 8 and 10 then '���� �� 8-10'
end) ������, count(*) [����������] from PROGRESS
group by (case
when NOTE between 0 and 3 then '�� ����'
when NOTE between 4 and 5 then '���� �� 4-5'
when NOTE between 6 and 7 then '���� �� 6-7'
when NOTE between 8 and 10 then '���� �� 8-10'
end)

--task 7

CREATE table  #EXPLRE
 (   TIND int,  
  TFIELD varchar(100)
      );
Set nocount on; -- �� �������� ��������� � ����� �����
declare @i int =0;
while @i<1000
begin
insert #EXPLRE(TIND,TFIELD)
values (floor(30000*rand()), REPLICATE('������',10));
if(@i%100=0)
print @i;
set @i=@i+1;
end;
select * from #EXPLRE--��������� ��������� ������� � ����� ����������� ���� ����� 1000 �������
--����� 2 �������
--1 ������� ��� ��������� ����� ���-�� � ������ 30000 � ������ ��� ������ ������������������, 
--����� ������ 10 ��� ������� ���� �� ������
--� ����� ������� ����� ����������� �� 100, 200, 300 )�������� ������� � ��������) � 
--�� � ����� ���������� ���������� ����� i, � ����� ��������� i++ � ������ �� ��������� ��������


--task8

declare @u int = 1
print @u+1
print @u+2
return
print @u+3
print @u+3
	

--task9
begin try
insert into AUDITORIUM values ('299-1', '�������', 20, '299-1');
end try
begin catch
print '��� ��������� ������: ' + cast(ERROR_NUMBER() as varchar(10));
print '��������� �� ������: ' + cast(ERROR_MESSAGE() as varchar(250));
print '������ � �������: ' + cast(ERROR_LINE() as varchar(25));
print '��� ���������: ' + isnull(cast(ERROR_PROCEDURE() as varchar(50)), 'NULL');
print '������� ����������� ������: ' + cast(ERROR_SEVERITY() as varchar(25));
print '����� ������: ' + cast(ERROR_STATE() as varchar(25));
end catch
