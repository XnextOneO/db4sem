--task 1
select * from Преподаватель

--task2

--create view [Количество кафедр] as
--select FACULTY.FACULTY, COUNT(PULPIT.PULPIT) [Количество кафедр]
--from FACULTY inner join PULPIT
--on FACULTY.FACULTY = PULPIT.FACULTY
--group by 
--FACULTY.FACULTY
select * from [Количество кафедр]

--task3

--CREATE view [Аудитории] as
--select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE
--FROM AUDITORIUM
--where AUDITORIUM.AUDITORIUM_TYPE LIKE 'ЛК%'

select * from Аудитории
insert Аудитории values('222-2', 'ЛК')


--TASK4

--create view [Лекционные аудитории] as
--select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE
--FROM AUDITORIUM
--where AUDITORIUM.AUDITORIUM_TYPE LIKE 'ЛК%' WITH CHECK OPTION

insert [Лекционные аудитории] values('321-3', 'ЛК')
insert [Лекционные аудитории] values('323-3', 'ЛБ')

--TASK5
--CREATE VIEW [Дисциплины] as
--select top 150 SUBJECT.SUBJECT, SUBJECT_NAME, SUBJECT.PULPIT
--from SUBJECT order by SUBJECT_NAME asc
select * from Дисциплины

--task6
alter view [Количество кафедр] with schemabinding as
select FACULTY.FACULTY, FACULTY.FACULTY_NAME, COUNT(PULPIT.PULPIT) [Количество кафедр]
from dbo.FACULTY inner join dbo.PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by 
FACULTY.FACULTY, FACULTY.FACULTY_NAME, 

insert into PULPIT (PULPIT.PULPIT)
values('dsakn')

