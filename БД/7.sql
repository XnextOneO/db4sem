--task 1
select * from �������������

--task2

--create view [���������� ������] as
--select FACULTY.FACULTY, COUNT(PULPIT.PULPIT) [���������� ������]
--from FACULTY inner join PULPIT
--on FACULTY.FACULTY = PULPIT.FACULTY
--group by 
--FACULTY.FACULTY
select * from [���������� ������]

--task3

--CREATE view [���������] as
--select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE
--FROM AUDITORIUM
--where AUDITORIUM.AUDITORIUM_TYPE LIKE '��%'

select * from ���������
insert ��������� values('222-2', '��')


--TASK4

--create view [���������� ���������] as
--select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE
--FROM AUDITORIUM
--where AUDITORIUM.AUDITORIUM_TYPE LIKE '��%' WITH CHECK OPTION

insert [���������� ���������] values('321-3', '��')
insert [���������� ���������] values('323-3', '��')

--TASK5
--CREATE VIEW [����������] as
--select top 150 SUBJECT.SUBJECT, SUBJECT_NAME, SUBJECT.PULPIT
--from SUBJECT order by SUBJECT_NAME asc
select * from ����������

--task6
alter view [���������� ������] with schemabinding as
select FACULTY.FACULTY, FACULTY.FACULTY_NAME, COUNT(PULPIT.PULPIT) [���������� ������]
from dbo.FACULTY inner join dbo.PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by 
FACULTY.FACULTY, FACULTY.FACULTY_NAME, 

insert into PULPIT (PULPIT.PULPIT)
values('dsakn')

