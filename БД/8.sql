--Task1
--declare для объявления переменной 
Declare @first int = 1, @second char = 'c', @trd varchar(4),
@date datetime, @time time, @sint smallint, @tint tinyint,
--ISNUMERIC определяет, является ли выражение допустимым числовым типом
@xnumeric numeric(12,5) 
-- переменной присвоить значение и выполнять вычисления
SET @trd = 'БГТУ'
--SELECT позволяет нескольким переменным присвоить значения. 

select @first = 25
select @first first

select @date = '12-12-2022',
@time = '1:53', @sint = 1, @tint = 2
select @date , @time , @sint, @tint 

print 'Я учусь в ' + @trd + '. Время сейчас -' + convert(varchar,@time)

--Task2 

use UNIVER

Declare @TotalCapacity int = (select sum(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM),
@totalaud int,
@smallaud int,
@smallaudpercent numeric(8,3),
@avgcapacity numeric(8,3)
if @TotalCapacity > 200 --вывести количество аудиторий, среднюю вместимость аудиторий,
--количество аудиторий, вместимость которых меньше средней, и процент таких аудиторий
begin

set @avgcapacity = (select avg(AUDITORIUM_CAPACITY) FROM AUDITORIUM)
set @totalaud = (select count(*) from AUDITORIUM)
set @smallaud = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY < @avgcapacity)
set @smallaudpercent = @smallaud / @totalaud

Print 'AVG - ' + convert(varchar,@avgcapacity) + '. Total - ' + convert(varchar,@totalaud) + '. Small auditorim - ' + convert(varchar,@smallaud) + '. Percent - ' + convert(varchar,@smallaudpercent) + '.'
end
else print 'Общая вместимость - ' + convert(varchar,@TotalCapacity)

--task3

print 'Число обработанных строк: ' + cast(@@rowcount as varchar) --3. глобальные переменные --число обработанных строк
print 'Версия SQL Server: ' + cast(@@version as varchar)
print 'Системный идентификатор процесса: ' + cast(@@spid as varchar) --системный идентификатор процесса
print 'Код последней ошибки: ' + cast(@@error as varchar)
print 'Имя сервера: ' + cast(@@servername as varchar)
print 'Уровень вложенности транзакции: ' + cast(@@trancount as varchar) --уровень вложенности транзакции
print 'Проверка результата считывания строк результирующего набора: ' + cast(@@fetch_status as varchar)
print 'Уровень вложенности текущей процедуры: ' + cast(@@nestlevel as varchar) --уровень вложенности

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
declare @name varchar(30) = 'Макенчик Татьяна Леонидовна',
@newName nvarchar(50) = '',
@symbol nchar(1),
@item int = 1,
@wordCount int = 0,
@isFirstLetter int = 0;
while @item < len(@name)  -- LEN(строковое выражение) возвращает число символов в строке, задаваемой строковым выражением
begin
set @symbol = substring(@name, @item ,1); --позволяет извлечь из выражения его часть заданной длины, начиная от заданной начальной позиции
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
use UNIVER -- возвращает интервал времени, прошедшего между двумя временными отметками
select STUDENT.NAME, STUDENT.BDAY, (datediff(YY, STUDENT.BDAY, GETDATE())) as Возраст  
from STUDENT
where month(STUDENT.BDAY) = month(sysdatetime()) + 1;  --month - возвращает месяц 
--4.4
use UNIVER
select STUDENT.IDGROUP as 'group', count(*) as 'количество студентов', DATEPART(weekday, PROGRESS.PDATE) as 'день недели'
from STUDENT
inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
inner join SUBJECT on PROGRESS.SUBJECT = SUBJECT.SUBJECT
where SUBJECT.SUBJECT = 'СУБД'
group by STUDENT.IDGROUP, PROGRESS.PDATE;
--Task5 

declare @totalstud int = (select count(*) from STUDENT)
if(@totalstud > 55)
begin
Print 'В универе больше 55 студентов'
end
else begin
Print 'В универе меньше 55 студентов'
end

--task6
use UNIVER --6 case  служит для формирования одного из нескольких возможных значений.
 
select (case
when NOTE between 0 and 3 then 'не сдал'
when NOTE between 4 and 5 then 'Сдал на 4-5'
when NOTE between 6 and 7 then 'Сдал на 6-7'
when NOTE between 8 and 10 then 'Сдал на 8-10'
end) Оценка, count(*) [Количество] from PROGRESS
group by (case
when NOTE between 0 and 3 then 'не сдал'
when NOTE between 4 and 5 then 'Сдал на 4-5'
when NOTE between 6 and 7 then 'Сдал на 6-7'
when NOTE between 8 and 10 then 'Сдал на 8-10'
end)

--task 7

CREATE table  #EXPLRE
 (   TIND int,  
  TFIELD varchar(100)
      );
Set nocount on; -- не выводить сообщения о вводе строк
declare @i int =0;
while @i<1000
begin
insert #EXPLRE(TIND,TFIELD)
values (floor(30000*rand()), REPLICATE('строка',10));
if(@i%100=0)
print @i;
set @i=@i+1;
end;
select * from #EXPLRE--создается временная таблица и потом объявляется цикл будет 1000 записей
--всего 2 столбца
--1 столбец это рандомное число где-то в районе 30000 а второе это просто строкастрокастрока, 
--слово строка 10 раз склеена друг за другом
--и потом счетчик цикла проверяется на 100, 200, 300 )проверка деления с остатком) и 
--тп и будет выводиться переменная цикла i, а потом инкремент i++ и погнал на следующую итерацию


--task8

declare @u int = 1
print @u+1
print @u+2
return
print @u+3
print @u+3
	

--task9
begin try
insert into AUDITORIUM values ('299-1', 'Кафедра', 20, '299-1');
end try
begin catch
print 'Код последней ошибки: ' + cast(ERROR_NUMBER() as varchar(10));
print 'Сообщение об ошибке: ' + cast(ERROR_MESSAGE() as varchar(250));
print 'Строка с ошибкой: ' + cast(ERROR_LINE() as varchar(25));
print 'Имя процедуры: ' + isnull(cast(ERROR_PROCEDURE() as varchar(50)), 'NULL');
print 'Уровень серьезности ошибки: ' + cast(ERROR_SEVERITY() as varchar(25));
print 'Метка ошибки: ' + cast(ERROR_STATE() as varchar(25));
end catch
