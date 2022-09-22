--��������

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
print '�������� �������';
set @teachershort = (select [TEACHER] from INSERTED);
set @teachername = (select [TEACHER_NAME] from INSERTED);
set @gender = (select [GENDER] from INSERTED);
set @pulpit = (select [PULPIT] from INSERTED);
set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @in);
return;

insert into TEACHER values ('���', '������� ������� ��������', '�', '������');
--delete from TEACHER where TEACHER = '���'
select * from TR_AUDIT order by ID;
drop trigger TR_TEACHER_INS
--������� INSERT ��� ���������� AFTER-�������� �������� � ����, ��� � ������������� INSERTED ���������� ������, ����������� ���������� INSERT,
--��������� ��� �������. ������������� DELETED �������� ������. 
--��� ������������� ������� DELETE � ������� DELETED ���������� ��������� ������, � ������� INSERTED �������� ������. 
--��� ��������� ����� ������� � ������� ��������� UPDATE ����������� ��� �������������, ��� ���� ������� INSERTED �������� ����������� ������ 
--�����, � ������� DELETED - ������ ����� �� �� ���������.


--task2
	
go
create trigger TR_TEACHER_DEL on TEACHER after delete
	as 
declare @teachershort char(10), @teachername varchar(100), @gender char(1), @pulpit char(20), @in varchar(400);
print '�������� ��������';
set @teachershort = (select [TEACHER] from DELETED);
set @teachername = (select [TEACHER_NAME] from DELETED);
set @gender = (select [GENDER] from DELETED);
set @pulpit = (select [PULPIT] from DELETED);
set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @in);
return;

--insert into TEACHER values ('���', '������� ������� ��������', '�', '������');
delete from TEACHER where TEACHER = '���'
select * from TR_AUDIT order by ID;


--task3

go
create trigger TR_TEACHER_UPD on TEACHER after update
	as 
declare @teachershort_old char(10), @teachername_old varchar(100), @gender_old char(1), @pulpit_old char(20), @in_old varchar(400);
declare @teachershort_new char(10), @teachername_new varchar(100), @gender_new char(1), @pulpit_new char(20), @in_new varchar(400);

print '�������� ���������';
set @teachershort_old = (select [TEACHER] from DELETED);
set @teachername_old = (select [TEACHER_NAME] from DELETED);
set @gender_old = (select [GENDER] from DELETED);
set @pulpit_old = (select [PULPIT] from DELETED);
set @in_old = '�� ���������: ' + rtrim(@teachershort_old) + ' ' + @teachername_old + ' ' + @gender_old + ' ' + rtrim(@pulpit_old);

set @teachershort_new = (select [TEACHER] from INSERTED);
set @teachername_new = (select [TEACHER_NAME] from INSERTED);
set @gender_new = (select [GENDER] from INSERTED);
set @pulpit_new = (select [PULPIT] from INSERTED);
set @in_new = '����� ���������: ' + rtrim(@teachershort_new) + ' ' + @teachername_new + ' ' + @gender_new + ' ' + rtrim(@pulpit_new);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @in_old + ' ' + @in_new);
return;

--�������� ������� ��� �����������:
update TEACHER set PULPIT = '����' where TEACHER = '���'
select * from TR_AUDIT order by ID;

--task4
--��� ����� �������! ���� ������� ����������, ����� �� ����������� ������
--drop trigger TR_TEACHER_INS;
--drop trigger TR_TEACHER_DEL;
--drop trigger TR_TEACHER_UPD;

go
create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE
	as
declare @teachershort char(10), @teachername varchar(100), @gender char(1), @pulpit char(20), @in varchar(400);

declare @teachershort_old char(10), @teachername_old varchar(100), @gender_old char(1), @pulpit_old char(20), @in_old varchar(400);
declare @teachershort_new char(10), @teachername_new varchar(100), @gender_new char(1), @pulpit_new char(20), @in_new varchar(400);

declare @ins int = (select count(*) from INSERTED), @del int = (select count(*) from DELETED); --����� ���������� ���� ��������

if  @ins > 0 and  @del = 0  --��������� �������
	begin
		print '������� Insert';
		set @teachershort = (select [TEACHER] from INSERTED);
		set @teachername = (select [TEACHER_NAME] from INSERTED);
		set @gender = (select [GENDER] from INSERTED);
		set @pulpit = (select [PULPIT] from INSERTED);
		set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @in);
		return;
	end;

if  @ins = 0 and  @del > 0  --��������� ��������
	begin
		print '������� Delete';
		set @teachershort = (select [TEACHER] from DELETED);
		set @teachername = (select [TEACHER_NAME] from DELETED);
		set @gender = (select [GENDER] from DELETED);
		set @pulpit = (select [PULPIT] from DELETED);
		set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL', @in);
		return;
	end;

if  @ins > 0 and  @del > 0  --��������� ����������
	begin
		print '������� Update';

		set @teachershort_old = (select [TEACHER] from DELETED);
		set @teachername_old = (select [TEACHER_NAME] from DELETED);
		set @gender_old = (select [GENDER] from DELETED);
		set @pulpit_old = (select [PULPIT] from DELETED);
		set @in_old = '�� ���������: ' + rtrim(@teachershort_old) + ' ' + @teachername_old + ' ' + @gender_old + ' ' + rtrim(@pulpit_old);

		set @teachershort_new = (select [TEACHER] from INSERTED);
		set @teachername_new = (select [TEACHER_NAME] from INSERTED);
		set @gender_new = (select [GENDER] from INSERTED);
		set @pulpit_new = (select [PULPIT] from INSERTED);
		set @in_new = '����� ���������: ' + rtrim(@teachershort_new) + ' ' + @teachername_new + ' ' + @gender_new + ' ' + rtrim(@pulpit_new);
		insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @in_old + ' ' + @in_new);
		return;
	end;

insert into TEACHER values ('����', '�������� ������� ��������', '�', '����');
update TEACHER set PULPIT = '������' where TEACHER = '����';
delete from TEACHER where TEACHER = '����';


select * from TR_AUDIT order by ID;

--task5

--�� ������������ �������� ����� �������� �����������:
insert into TEACHER values ('����', '�������� ������� �����	���', '�', '����');
select * from TR_AUDIT order by ID;

--task6

--������� ��� ���������� ��������, ����� ������ ���� ��������� ���
--drop trigger TR_TEACHER_INS;
--drop trigger TR_TEACHER_DEL;
--drop trigger TR_TEACHER_UPD;
--drop trigger TR_TEACHER;

go
create trigger TR_TEACHER_DEL1 on TEACHER after DELETE  
       as 
print 'TR_TEACHER_DEL1';
declare @teachershort char(10), @teachername varchar(100), @gender char(1), @pulpit char(20), @in varchar(400);
print '�������� ��������';
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
print '�������� ��������';
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
print '�������� ��������';
set @teachershort = (select [TEACHER] from DELETED);
set @teachername = (select [TEACHER_NAME] from DELETED);
set @gender = (select [GENDER] from DELETED);
set @pulpit = (select [PULPIT] from DELETED);
set @in = rtrim(@teachershort) + ' ' + @teachername + ' ' + @gender + ' ' + rtrim(@pulpit);
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL3', @in);
 return;  

--������� ������ ���� ��������� ������� Teacher
go
select t.name, e.type_desc 
         from sys.triggers t join sys.trigger_events e  
                  on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER'
--and  e.type_desc = 'DELETE' ;  

--������ ������� ���������� ��������� (order - ���� ��� none, ����� last � first) ��������� � ������� ��������� �������� 
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                     @order = 'First', @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                     @order = 'Last', @stmttype = 'DELETE';

--��������
delete from TR_AUDIT; --�������� ������� ���������� ��������

insert into TEACHER values ('����', '�������� ������� ��������', '�', '����');

delete from TEACHER where TEACHER = '����';

select * from TR_AUDIT order by ID;


--task7 AFTER-������� �������� ������ ����������, � ������ �������� ����������� ��������, ���������������� �������.
go
create trigger TEACHER_TRAN
	on TEACHER after INSERT, UPDATE, DELETE
as
	declare @teachercount int = (select Count(*) from TEACHER where PULPIT='����')
if (@teachercount >= 10 or @teachercount < 5)
	begin
		raiserror('���������� �������������� �� ������� ���� �������� ������� � �������� ����� - � ��������� �� 5 �� 10', 10, 1);
		rollback;
	end;
return;

insert into TEACHER values ('����', '������� ������� ��������', '�', '����');
--� ����� ��� �� �����:
insert into TEACHER values ('����', '��������� ������� ��������', '�', '����');


--task8  ����������� �������� ����� � �������. 

go
create trigger FACULTY_INSTEAD_OF
on FACULTY instead of DELETE
as 
	raiserror(N'��������� �������� �����������', 10, 1);
return;

delete from FACULTY where FACULTY = '���';
select * from FACULTY where FACULTY = '���';

--task 8-1

go
create trigger STUDENT_INSTEAD_OF
on STUDENT instead of UPDATE --������� INSTEAD OF ����������� ������ �������� � �������.
as 
	raiserror(N'��������� ���������� ������ ���������, ���� �� ���������� �������', 10, 1);
return;

update STUDENT set IDGROUP = 555 where IDSTUDENT = 1000; --������� ����������� �� �������� �����������! ������ 555 ���. 
select * from STUDENT where IDGROUP = 555

--������� ������ ���� ��������� �� Univer
go
select *
         from sys.triggers t join sys.trigger_events e  
                  on t.object_id = e.object_id  

--where OBJECT_NAME(t.parent_id) = 'FACULTY'
--and is_instead_of_trigger = 1;

--������ ���������:
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
create  trigger DDL_UNIVER on database --������� ��������� �� ����!
                          for DDL_DATABASE_LEVEL_EVENTS --����������� ��� ������������ DDL ���������� �� ����!
as   
  declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)'); --����������� ��� ������� � ���������� varchar(50)
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)'); --����������� ��� �������, �� ������� ��������� �������
  declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');  --����������� ��� �������,  �� ������� ��������� �������
  if @t1 = 'DOGSALES' 
begin
       print '��� �������: ' + @t;
       print '��� �������: ' + @t1;
       print '��� �������: ' + @t2;
       raiserror( N'�������� � �������� ������ ���������', 16, 1);  
       rollback;    
end;

--drop trigger DDL_UNIVER on database

drop table DOGSALES;
