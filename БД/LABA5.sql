use UNIVER

--1 �������   IN,	��������� ���������� �������� ������� � ��� ������, ���� ��������, ��������� 
--����� �� 
--��������� ����� IN, ����� ���� �� ������ �� �������� ������, ���������� �����

select PULPIT.PULPIT_NAME, FACULTY.FACULTY
from FACULTY, PULPIT, PROFESSION
where FACULTY.FACULTY = PULPIT.FACULTY and PROFESSION.FACULTY = FACULTY.FACULTY and PROFESSION_NAME in (select PROFESSION_NAME from PROFESSION 
where(PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������%')) 

--2 �������

	select PULPIT.PULPIT_NAME, FACULTY.FACULTY
from PULPIT inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY 
			 inner join PROFESSION on PROFESSION.FACULTY = PULPIT.FACULTY
where PROFESSION_NAME in (select PROFESSION_NAME from PROFESSION 
where(PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������%'))

--3 ������� ��� ����������(Inner join ��� 3 ������)

	select PULPIT.PULPIT_NAME, FACULTY.FACULTY
from PULPIT inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY 
			 inner join PROFESSION on PROFESSION.FACULTY = PULPIT.FACULTY
where(PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������%')

--4 ������� SELECT TOP ������������ ��� �������� ���������� ������������ �������.

select AUDITORIUM_CAPACITY, AUDITORIUM_TYPE
from AUDITORIUM p
where AUDITORIUM_CAPACITY in --!!!!
(select top(8)	p.AUDITORIUM_CAPACITY from AUDITORIUM) order by AUDITORIUM_CAPACITY desc

--5 ������� exist(���������, ���������� �� ��������� �����-���� ��������) � ��������������� ���������(������ � ������� ����������� ������� �� �������� �������)

select distinct FACULTY_NAME 
from FACULTY, PULPIT p
where exists (select p.FACULTY from PULPIT)

--6 ������� ��� ����������������� ���������� � ������ SELECT /avg- avg �������	

select top(1) 
(select avg(NOTE) from PROGRESS
where SUBJECT like '����') [����],
(select avg(NOTE) from PROGRESS
where SUBJECT like '��') [��],
(select avg(NOTE) from PROGRESS
where SUBJECT like '����') [����]
from PROGRESS

--7 ������� all � ����������� 

select NOTE, SUBJECT
from PROGRESS
where NOTE >= all(select NOTE from PROGRESS where SUBJECT like '�%') and (SUBJECT like '����')

--8 ������� ANY  � �����������.  like ��� ������ ���������� ������� � �������

select NOTE, SUBJECT
from PROGRESS
where NOTE > any(select NOTE from PROGRESS where SUBJECT like '�%')
