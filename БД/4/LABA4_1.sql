 use UNIVER
		----------1 задание----------

select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		from AUDITORIUM_TYPE Inner join AUDITORIUM
		on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE

		----------2 задание----------
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		from AUDITORIUM_TYPE Inner join AUDITORIUM
		on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like '%компьютер%'  --like - условие типо

		----------3 задание----------

select t2.AUDITORIUM, t1.AUDITORIUM_TYPENAME 
		from AUDITORIUM_TYPE as t1, AUDITORIUM as t2
		where t1.AUDITORIUM_TYPE=t2.AUDITORIUM_TYPE

select t2.AUDITORIUM, t1.AUDITORIUM_TYPENAME 
		from AUDITORIUM_TYPE as t1, AUDITORIUM as t2
		where t1.AUDITORIUM_TYPE=t2.AUDITORIUM_TYPE and t1.AUDITORIUM_TYPENAME like '%компьютер%'

		----------4 задание----------

select FACULTY.FACULTY Факультет, PULPIT.PULPIT Кафедра, PROFESSION Специальность, SUBJECT_NAME Предмет, NAME ФИО,
	Case
		when(PROGRESS.NOTE = 6) then 'шесть'
		when(PROGRESS.NOTE = 7) then 'семь'
		when(PROGRESS.NOTE = 8) then 'восемь'
		else ' < 6 or > 8'
	end [Оценка]
	from FACULTY
		inner join GROUPS
			on GROUPS.FACULTY = FACULTY.FACULTY
		inner join STUDENT
			on STUDENT.IDGROUP = GROUPS.IDGROUP
		inner join PROGRESS
			on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		inner join SUBJECT
			on SUBJECT.SUBJECT = PROGRESS.SUBJECT
		inner join PULPIT
			on PULPIT.PULPIT = SUBJECT.PULPIT and (PROGRESS.NOTE between 6 and 8)
	order by FACULTY.FACULTY, PULPIT.PULPIT, GROUPS.PROFESSION, STUDENT.NAME 
		----------5 задание----------

		select FACULTY.FACULTY Факультет, PULPIT.PULPIT Кафедра, PROFESSION Специальность, SUBJECT_NAME Предмет, NAME ФИО,
	Case
		when(PROGRESS.NOTE = 6) then 'шесть'
		when(PROGRESS.NOTE = 7) then 'семь'
		when(PROGRESS.NOTE = 8) then 'восемь'
		else ' < 6 or > 8'
	end [Оценка]
	from FACULTY
		inner join GROUPS
			on GROUPS.FACULTY = FACULTY.FACULTY
		inner join STUDENT
			on STUDENT.IDGROUP = GROUPS.IDGROUP
		inner join PROGRESS
			on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		inner join SUBJECT
			on SUBJECT.SUBJECT = PROGRESS.SUBJECT
		inner join PULPIT
			on PULPIT.PULPIT = SUBJECT.PULPIT and (PROGRESS.NOTE between 6 and 8)
	order by (case
			when(PROGRESS.NOTE = 6) then 3
			when(PROGRESS.NOTE = 7) then 1
			when(PROGRESS.NOTE = 8) then 2
			end)


		----------6 задание----------

select PULPIT.PULPIT, isnull(TEACHER.TEACHER_NAME,'***')Teacher
		from PULPIT left outer join TEACHER
		on PULPIT.PULPIT = TEACHER.PULPIT
		where TEACHER_NAME is null

		----------7 задание----------

select PULPIT.PULPIT, isnull(TEACHER.TEACHER_NAME,'***')Teacher
		from TEACHER right outer join PULPIT
		on PULPIT.PULPIT = TEACHER.PULPIT
		where TEACHER_NAME is null

		----------8 задание----------

select PULPIT.PULPIT, isnull(TEACHER.TEACHER_NAME,'***')[Teacher]
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

select PULPIT.PULPIT, isnull(TEACHER.TEACHER_NAME,'***')[Teacher]
from TEACHER full outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER_NAME is null

		----------9 задание----------

select AUDITORIUM.AUDITORIUM,AUDITORIUM.AUDITORIUM_TYPE
from AUDITORIUM cross join AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE


		----------10 задание----------



		----------11 задание----------

create table TIMETABLE
(
IDGROUP  int,
AUDITORIUM   char(20) not null foreign key references AUDITORIUM(AUDITORIUM), 
SUBJECT varchar(100),
TEACHER  varchar(100) not null foreign key references TEACHER(TEACHER_NAME), 
day_of_week date,
countpare int
);
insert into TIMETABLE(IDGROUP, AUDITORIUM, SUBJECT, TEACHER, day_of_week, countpare)
		values( 1,'206-1', 'СУБД', 'Смелов Владимир Владиславович', '24.03.2022', 2);
