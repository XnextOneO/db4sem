--B-- ����� ���������� � ������� ��������������� READ COMMITED  ������ ��������������� ������
		begin transaction
		select @@SPID --���������� ��������� ������������� ��������, ����������� �������� �������� �����������.
		insert FACULTY values ('���', '���')
		update PROGRESS set NOTE = 5
		where IDSTUDENT = 1020
		commit;
