use UNIVER
--1 ������������� � ����������� �������, �������������� ����� ������������� ������,
--��� �������� ������, ��� ��� ������������� ����� ���� ������ � ����� �������, � �� �� ���� �������.
create view �������������
	as select TEACHER.TEACHER ���, TEACHER.TEACHER_NAME �������������, TEACHER.GENDER ���, TEACHER.PULPIT ���_�������
		from TEACHER 
		
select * from ������������� order by ��� 

drop view �������������

--2
create view ����������_������
	as select distinct FACULTY.FACULTY ���������,   --distinct ������������ ��� �������� �� ��, ��� ������� �������� ������ � ����������� ���������� �������.
		(select count(*) from PULPIT
			where PULPIT.FACULTY = FACULTY.FACULTY) ����������_������
		from FACULTY 

select * from ����������_������

drop view ����������_������

select * from AUDITORIUM

--3
create view ���������
	as select AUDITORIUM.AUDITORIUM ���, AUDITORIUM.AUDITORIUM_NAME ������������_���������
		from AUDITORIUM
		where AUDITORIUM.AUDITORIUM_TYPE like '��%'

select * from ���������

insert ��������� values ('778-1', '��-�') --��������� INSERT ���������� ������� ����� � ����� �����������:

drop view ���������

--4
create view ����������_���������1
	as select AUDITORIUM.AUDITORIUM ���, AUDITORIUM.AUDITORIUM_NAME ������������_���������, AUDITORIUM.AUDITORIUM_TYPE
		from AUDITORIUM
		where AUDITORIUM.AUDITORIUM_TYPE like '��%'
		with check option
		--����� �������� ������� �� ����� ������������� � ��� ������, ����� ���������� �� ������������� �������
select * from ����������_���������1

insert ����������_���������1 values ('211-1', '244-1' ,'��-�')

drop view ����������_���������1

--5
create view ����������	
	as select top(5) SUBJECT ���, SUBJECT_NAME ������������_����������, PULPIT ���_�������
		from SUBJECT
		order by ������������_����������

select * from ����������

drop view ����������

--6

	ALTER VIEW [���������� ������] WITH SCHEMABINDING
       as select DBO.FACULTY.FACULTY_NAME [���������],
	             COUNT (*) [���������� ������]
	             FROM DBO.FACULTY  INNER JOIN DBO.PULPIT P
	             ON FACULTY.FACULTY = P.FACULTY
				 GROUP BY FACULTY.FACULTY_NAME

SELECT * from [���������� ������]

