--A-- ����� ���������� � ������� ��������������� READ UNCOMMITED, ������ ����������������� ������
		DELETE FACULTY WHERE FACULTY_NAME = '���' 
		set transaction isolation level read uncommitted
		begin transaction
		select @@SPID,  * from FACULTY --@@SPID ���������� ��������� ������������� ��������, ����������� �������� �������� �����������
		WHERE FACULTY = '���';
		select @@SPID, PULPIT.FACULTY FROM PULPIT
		WHERE FACULTY = '���';
		commit;