 use UNIVER
		----------1 �������----------

select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		from AUDITORIUM_TYPE Inner join AUDITORIUM
		on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE

		----------2 �������----------
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
		from AUDITORIUM_TYPE Inner join AUDITORIUM
		on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like '%���������%'  --like - ������� ����

		----------3 �������----------

select t2.AUDITORIUM, t1.AUDITORIUM_TYPENAME 
		from AUDITORIUM_TYPE as t1, AUDITORIUM as t2
		where t1.AUDITORIUM_TYPE=t2.AUDITORIUM_TYPE

select t2.AUDITORIUM, t1.AUDITORIUM_TYPENAME 
		from AUDITORIUM_TYPE as t1, AUDITORIUM as t2
		where t1.AUDITORIUM_TYPE=t2.AUDITORIUM_TYPE and t1.AUDITORIUM_TYPENAME like '%���������%'

		----------4 �������----------

select FACULTY.FACULTY ���������, PULPIT.PULPIT �������, PROFESSION �������������, SUBJECT_NAME �������, NAME ���,
	Case
		when(PROGRESS.NOTE = 6) then '�����'
		when(PROGRESS.NOTE = 7) then '����'
		when(PROGRESS.NOTE = 8) then '������'
		else ' < 6 or > 8'
	end [������]
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
		----------5 �������----------

		select FACULTY.FACULTY ���������, PULPIT.PULPIT �������, PROFESSION �������������, SUBJECT_NAME �������, NAME ���,
	Case
		when(PROGRESS.NOTE = 6) then '�����'
		when(PROGRESS.NOTE = 7) then '����'
		when(PROGRESS.NOTE = 8) then '������'
		else ' < 6 or > 8'
	end [������]
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


		----------6 �������----------

select PULPIT.PULPIT, isnull(TEACHER.TEACHER_NAME,'***')Teacher
		from PULPIT left outer join TEACHER
		on PULPIT.PULPIT = TEACHER.PULPIT
		where TEACHER_NAME is null

		----------7 �������----------

select PULPIT.PULPIT, isnull(TEACHER.TEACHER_NAME,'***')Teacher
		from TEACHER right outer join PULPIT
		on PULPIT.PULPIT = TEACHER.PULPIT
		where TEACHER_NAME is null

		----------8 �������----------

select PULPIT.PULPIT, isnull(TEACHER.TEACHER_NAME,'***')[Teacher]
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

select PULPIT.PULPIT, isnull(TEACHER.TEACHER_NAME,'***')[Teacher]
from TEACHER full outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER_NAME is null

		----------9 �������----------

select AUDITORIUM.AUDITORIUM,AUDITORIUM.AUDITORIUM_TYPE
from AUDITORIUM cross join AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE


		----------10 �������----------



		----------11 �������----------

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
		values( 1,'206-1', '����', '������ �������� �������������', '24.03.2022', 2);
