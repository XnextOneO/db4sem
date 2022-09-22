--триггеры

use Univer;

--task1

create table TR_AUDIT
(
ID int identity,
STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
TRNAME varchar(50),
CC varchar(700)
)

go
create trigger TR_TEACHER_INS on TEACHER after insert
	as 
declare @teachershort char(10), @teachername varchar(100), @gender char(1), @pulpit char(20), @in varchar(400);
print 'Операция вставки';
set @teachershort = (select [TEACHER] from INSERTED);
set @teachername = (select [TEACHER_NAME] from INSERTED);
set @gender = (select [GENDER] from INSERTED);
set @pulpit = (select [PULPIT] from INSERTED);
set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @in);
return;

insert into TEACHER values ('БНИ', 'Белодед Николай Иванович', 'м', 'ПОиСОИ');
--delete from TEACHER where TEACHER = 'БНИ'
select * from TR_AUDIT order by ID;
drop trigger TR_TEACHER_INS
--Событие INSERT при выполнении AFTER-триггера приводит к тому, что в псевдотаблицу INSERTED помещаются строки, добавленные оператором INSERT,
--вызвавшим это событие. Псевдотаблица DELETED остается пустой. 
--При возникновении события DELETE в таблицу DELETED копируются удаленные строки, а таблица INSERTED остается пустой. 
--При изменении строк таблицы с помощью оператора UPDATE заполняются обе псевдотаблицы, при этом таблица INSERTED содержит обновленные версии 
--строк, а таблица DELETED - версию строк до их изменения.


--task2
	
go
create trigger TR_TEACHER_DEL on TEACHER after delete
	as 
declare @teachershort char(10), @teachername varchar(100), @gender char(1), @pulpit char(20), @in varchar(400);
print 'Операция удаления';
set @teachershort = (select [TEACHER] from DELETED);
set @teachername = (select [TEACHER_NAME] from DELETED);
set @gender = (select [GENDER] from DELETED);
set @pulpit = (select [PULPIT] from DELETED);
set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @in);
return;

--insert into TEACHER values ('БНИ', 'Белодед Николай Иванович', 'м', 'ПОиСОИ');
delete from TEACHER where TEACHER = 'БНИ'
select * from TR_AUDIT order by ID;


--task3

go
create trigger TR_TEACHER_UPD on TEACHER after update
	as 
declare @teachershort_old char(10), @teachername_old varchar(100), @gender_old char(1), @pulpit_old char(20), @in_old varchar(400);
declare @teachershort_new char(10), @teachername_new varchar(100), @gender_new char(1), @pulpit_new char(20), @in_new varchar(400);

print 'Операция изменения';
set @teachershort_old = (select [TEACHER] from DELETED);
set @teachername_old = (select [TEACHER_NAME] from DELETED);
set @gender_old = (select [GENDER] from DELETED);
set @pulpit_old = (select [PULPIT] from DELETED);
set @in_old = 'До изменения: ' + rtrim(@teachershort_old) + ' ' + @teachername_old + ' ' + @gender_old + ' ' + rtrim(@pulpit_old);

set @teachershort_new = (select [TEACHER] from INSERTED);
set @teachername_new = (select [TEACHER_NAME] from INSERTED);
set @gender_new = (select [GENDER] from INSERTED);
set @pulpit_new = (select [PULPIT] from INSERTED);
set @in_new = 'После изменения: ' + rtrim(@teachershort_new) + ' ' + @teachername_new + ' ' + @gender_new + ' ' + rtrim(@pulpit_new);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @in_old + ' ' + @in_new);
return;

--изменять кафедру для наглядности:
update TEACHER set PULPIT = 'ИСиТ' where TEACHER = 'ДТК'
select * from TR_AUDIT order by ID;

--task4
--ЭТО ОБЩИЙ ТРИГГЕР! Надо удалить предыдущие, чтобы не срабатывало дважды
--drop trigger TR_TEACHER_INS;
--drop trigger TR_TEACHER_DEL;
--drop trigger TR_TEACHER_UPD;

go
create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE
	as
declare @teachershort char(10), @teachername varchar(100), @gender char(1), @pulpit char(20), @in varchar(400);

declare @teachershort_old char(10), @teachername_old varchar(100), @gender_old char(1), @pulpit_old char(20), @in_old varchar(400);
declare @teachershort_new char(10), @teachername_new varchar(100), @gender_new char(1), @pulpit_new char(20), @in_new varchar(400);

declare @ins int = (select count(*) from INSERTED), @del int = (select count(*) from DELETED); --чтобы установить факт операции

if  @ins > 0 and  @del = 0  --произошла вставка
	begin
		print 'Событие Insert';
		set @teachershort = (select [TEACHER] from INSERTED);
		set @teachername = (select [TEACHER_NAME] from INSERTED);
		set @gender = (select [GENDER] from INSERTED);
		set @pulpit = (select [PULPIT] from INSERTED);
		set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @in);
		return;
	end;

if  @ins = 0 and  @del > 0  --произошло удаление
	begin
		print 'Событие Delete';
		set @teachershort = (select [TEACHER] from DELETED);
		set @teachername = (select [TEACHER_NAME] from DELETED);
		set @gender = (select [GENDER] from DELETED);
		set @pulpit = (select [PULPIT] from DELETED);
		set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @in);
		return;
	end;

if  @ins > 0 and  @del > 0  --произошло обновление
	begin
		print 'Событие Update';

		set @teachershort_old = (select [TEACHER] from DELETED);
		set @teachername_old = (select [TEACHER_NAME] from DELETED);
		set @gender_old = (select [GENDER] from DELETED);
		set @pulpit_old = (select [PULPIT] from DELETED);
		set @in_old = 'До изменения: ' + rtrim(@teachershort_old) + ' ' + @teachername_old + ' ' + @gender_old + ' ' + rtrim(@pulpit_old);

		set @teachershort_new = (select [TEACHER] from INSERTED);
		set @teachername_new = (select [TEACHER_NAME] from INSERTED);
		set @gender_new = (select [GENDER] from INSERTED);
		set @pulpit_new = (select [PULPIT] from INSERTED);
		set @in_new = 'После изменения: ' + rtrim(@teachershort_new) + ' ' + @teachername_new + ' ' + @gender_new + ' ' + rtrim(@pulpit_new);
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @in_old + ' ' + @in_new);
		return;
	end;

insert into TEACHER values ('ЧРНД', 'Чернодед Николай Иванович', 'м', 'ИСиТ');
update TEACHER set PULPIT = 'ПОиСОИ' where TEACHER = 'ЧРНД';
delete from TEACHER where TEACHER = 'ЧРНД';


select * from TR_AUDIT order by ID;

--task5

--до срабатывания триггера будет проверка целостности:
insert into TEACHER values ('ЧРНД', 'Чернодед Николай Ивано	вич', 'п', 'ИСиТ');
select * from TR_AUDIT order by ID;

--task6

--удалить все предыдущие триггера, чтобы скрипт себя нормально вел
--drop trigger TR_TEACHER_INS;
--drop trigger TR_TEACHER_DEL;
--drop trigger TR_TEACHER_UPD;
--drop trigger TR_TEACHER;

go
create trigger TR_TEACHER_DEL1 on TEACHER after DELETE  
       as 
print 'TR_TEACHER_DEL1';
declare @teachershort char(10), @teachername varchar(100), @gender char(1), @pulpit char(20), @in varchar(400);
print 'Операция удаления';
set @teachershort = (select [TEACHER] from DELETED);
set @teachername = (select [TEACHER_NAME] from DELETED);
set @gender = (select [GENDER] from DELETED);
set @pulpit = (select [PULPIT] from DELETED);
set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL1', @in);
return;  

go 
create trigger TR_TEACHER_DEL2 on TEACHER after DELETE  
       as
print 'TR_TEACHER_DEL2';
declare @teachershort char(10), @teachername varchar(100), @gender char(1), @pulpit char(20), @in varchar(400);
print 'Операция удаления';
set @teachershort = (select [TEACHER] from DELETED);
set @teachername = (select [TEACHER_NAME] from DELETED);
set @gender = (select [GENDER] from DELETED);
set @pulpit = (select [PULPIT] from DELETED);
set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL2', @in);
return;  

go  
create trigger TR_TEACHER_DEL3 on TEACHER after DELETE  
       as
print 'TR_TEACHER_DEL3';
declare @teachershort char(10), @teachername varchar(100), @gender char(1), @pulpit char(20), @in varchar(400);
print 'Операция удаления';
set @teachershort = (select [TEACHER] from DELETED);
set @teachername = (select [TEACHER_NAME] from DELETED);
set @gender = (select [GENDER] from DELETED);
set @pulpit = (select [PULPIT] from DELETED);
set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL3', @in);
 return;  

--получим список ВСЕХ триггеров таблицы Teacher
go
select t.name, e.type_desc 
         from sys.triggers t join sys.trigger_events e  
                  on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER'
--and  e.type_desc = 'DELETE' ;  

--сменим порядок выполнения триггеров (order - есть еще none, кроме last и first) Изменение с помощью системных процедур 
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                     @order = 'First', @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                     @order = 'Last', @stmttype = 'DELETE';

--проверка
delete from TR_AUDIT; --почистим таблицу триггерных операций

insert into TEACHER values ('ЧРНД', 'Чернодед Николай Иванович', 'м', 'ИСиТ');

delete from TEACHER where TEACHER = 'ЧРНД';

select * from TR_AUDIT order by ID;


--task7 AFTER-триггер является частью транзакции, в рамках которого выполняется оператор, активизировавший триггер.
go
create trigger TEACHER_TRAN
	on TEACHER after INSERT, UPDATE, DELETE
as
	declare @teachercount int = (select Count(*) from TEACHER where PULPIT='ИСиТ')
if (@teachercount >= 10 or @teachercount < 5)
	begin
		raiserror('Количество преподавателей на кафедре ИСиТ согласно бюджету и учебному плану - в диапазоне от 5 до 10', 10, 1);
		rollback;
	end;
return;

insert into TEACHER values ('РЖНД', 'Рыжодед Николай Иванович', 'м', 'ИСиТ');
--а этого уже не будет:
insert into TEACHER values ('КРНД', 'Краснодед Николай Иванович', 'м', 'ИСиТ');


--task8  запрещающий удаление строк в таблице. 

go
create trigger FACULTY_INSTEAD_OF
on FACULTY instead of DELETE
as 
	raiserror(N'Запрещено удаление факультетов', 10, 1);
return;

delete from FACULTY where FACULTY = 'ТОВ';
select * from FACULTY where FACULTY = 'ТОВ';

--task 8-1

go
create trigger STUDENT_INSTEAD_OF
on STUDENT instead of UPDATE --Триггер INSTEAD OF срабатывает вместо операции с данными.
as 
	raiserror(N'Запрещено обновление данных студентов, пока не закончился семестр', 10, 1);
return;

update STUDENT set IDGROUP = 555 where IDSTUDENT = 1000; --триггер выполняется до проверки целостности! группы 555 нет. 
select * from STUDENT where IDGROUP = 555

--получим список ВСЕХ триггеров бд Univer
go
select *
         from sys.triggers t join sys.trigger_events e  
                  on t.object_id = e.object_id  

--where OBJECT_NAME(t.parent_id) = 'FACULTY'
--and is_instead_of_trigger = 1;

--удалим некоторые:
drop trigger TR_TEACHER_DEL1;
drop trigger TR_TEACHER_DEL2;
drop trigger TR_TEACHER_DEL3;
drop trigger TEACHER_TRAN;
drop trigger FACULTY_INSTEAD_OF;


--task9

create table DOGSALES
(
  PRICE int not null,
  DOGCOUNT int default 1,
  BREED varchar(40)
)

go	
create  trigger DDL_UNIVER on database --триггер создается на базе!
                          for DDL_DATABASE_LEVEL_EVENTS --срабатывает при срабатывании DDL операторов на базе!
as   
  declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)'); --запрашивает тип события в переменную varchar(50)
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)'); --запрашивает имя объекта, на котором произошло событие
  declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');  --запрашивает тип объекта,  на котором произошло событие
  if @t1 = 'DOGSALES' 
begin
       print 'Тип события: ' + @t;
       print 'Имя объекта: ' + @t1;
       print 'Тип объекта: ' + @t2;
       raiserror( N'операции с таблицей Собаки запрещены', 16, 1);  
       rollback;    
end;

--drop trigger DDL_UNIVER on database

drop table DOGSALES;
