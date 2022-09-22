use UNIVER

--1 задание   IN,	формирует логическое значение «истина» в том случае, если значение, указанное 
--слева от 
--ключевого слова IN, равно хотя бы одному из значений списка, указанного справ

select PULPIT.PULPIT_NAME, FACULTY.FACULTY
from FACULTY, PULPIT, PROFESSION
where FACULTY.FACULTY = PULPIT.FACULTY and PROFESSION.FACULTY = FACULTY.FACULTY and PROFESSION_NAME in (select PROFESSION_NAME from PROFESSION 
where(PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии%')) 

--2 задание

	select PULPIT.PULPIT_NAME, FACULTY.FACULTY
from PULPIT inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY 
			 inner join PROFESSION on PROFESSION.FACULTY = PULPIT.FACULTY
where PROFESSION_NAME in (select PROFESSION_NAME from PROFESSION 
where(PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии%'))

--3 задание без подзапроса(Inner join для 3 таблиц)

	select PULPIT.PULPIT_NAME, FACULTY.FACULTY
from PULPIT inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY 
			 inner join PROFESSION on PROFESSION.FACULTY = PULPIT.FACULTY
where(PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии%')

--4 задание SELECT TOP используется для указания количества возвращаемых записей.

select AUDITORIUM_CAPACITY, AUDITORIUM_TYPE
from AUDITORIUM p
where AUDITORIUM_CAPACITY in --!!!!
(select top(8)	p.AUDITORIUM_CAPACITY from AUDITORIUM) order by AUDITORIUM_CAPACITY desc

--5 задание exist(проверяет, возвращает ли подзапрос какое-либо значение) и коррелированный подзапрос(запрос в котором упоминается таблица из внешнего запроса)

select distinct FACULTY_NAME 
from FACULTY, PULPIT p
where exists (select p.FACULTY from PULPIT)

--6 задание три некоррелированных подзапроса в списке SELECT /avg- avg столбца	

select top(1) 
(select avg(NOTE) from PROGRESS
where SUBJECT like 'ОАиП') [ОАиП],
(select avg(NOTE) from PROGRESS
where SUBJECT like 'БД') [БД],
(select avg(NOTE) from PROGRESS
where SUBJECT like 'СУБД') [СУБД]
from PROGRESS

--7 задание all с подзапросом 

select NOTE, SUBJECT
from PROGRESS
where NOTE >= all(select NOTE from PROGRESS where SUBJECT like 'О%') and (SUBJECT like 'ОАиП')

--8 задание ANY  с подзапросом.  like для поиска указанного шаблона в столбце

select NOTE, SUBJECT
from PROGRESS
where NOTE > any(select NOTE from PROGRESS where SUBJECT like 'О%')
