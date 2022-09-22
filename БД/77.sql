use UNIVER
--1 Представление — виртуальная таблица, представляющая собой поименованный запрос,
--Они защищают данные, так как представления могут дать доступ к части таблицы, а не ко всей таблице.
create view Преподаватель
	as select TEACHER.TEACHER Код, TEACHER.TEACHER_NAME Преподаватель, TEACHER.GENDER Пол, TEACHER.PULPIT Код_кафедры
		from TEACHER 
		
select * from Преподаватель order by Пол 

drop view Преподаватель

--2
create view Количество_кафедр
	as select distinct FACULTY.FACULTY Факультет,   --distinct используется для указания на то, что следует работать только с уникальными значениями столбца.
		(select count(*) from PULPIT
			where PULPIT.FACULTY = FACULTY.FACULTY) Количество_кафедр
		from FACULTY 

select * from Количество_кафедр

drop view Количество_кафедр

select * from AUDITORIUM

--3
create view Аудитории
	as select AUDITORIUM.AUDITORIUM Код, AUDITORIUM.AUDITORIUM_NAME Наименование_аудитории
		from AUDITORIUM
		where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'

select * from Аудитории

insert Аудитории values ('778-1', 'ЛК-К') --Операторы INSERT осуществят вставку строк с новой информацией:

drop view Аудитории

--4
create view Лекционные_аудитории1
	as select AUDITORIUM.AUDITORIUM Код, AUDITORIUM.AUDITORIUM_NAME Наименование_аудитории, AUDITORIUM.AUDITORIUM_TYPE
		from AUDITORIUM
		where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'
		with check option
		--Чтобы операция вставки не могла осуществиться в том случае, когда информация не удовлетворяет условию
select * from Лекционные_аудитории1

insert Лекционные_аудитории1 values ('211-1', '244-1' ,'ЛБ-К')

drop view Лекционные_аудитории1

--5
create view Дисциплины	
	as select top(5) SUBJECT Код, SUBJECT_NAME Наименование_дисциплины, PULPIT Код_кафедры
		from SUBJECT
		order by Наименование_дисциплины

select * from Дисциплины

drop view Дисциплины

--6

	ALTER VIEW [Количество кафедр] WITH SCHEMABINDING
       as select DBO.FACULTY.FACULTY_NAME [Факультет],
	             COUNT (*) [Количество кафедр]
	             FROM DBO.FACULTY  INNER JOIN DBO.PULPIT P
	             ON FACULTY.FACULTY = P.FACULTY
				 GROUP BY FACULTY.FACULTY_NAME

SELECT * from [Количество кафедр]

