--11-7�
--a
set transaction isolation level SERIALIZABLE --��������� ������ ����
begin transaction
insert into PROGRESS values ('����', 15, '2013-12-01', 9);
select * from PROGRESS where NOTE = 9;
commit;
