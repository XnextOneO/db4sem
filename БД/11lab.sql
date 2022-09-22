--���������� -  ��� �������� ���� ������, ����������� ����� ������� ���������� ��������� ����������, ���������� ���� ������,
--����� ��� ���������� ���� ������������ ���������� ��� ��� ��� ����������� ��� ��� �� �����������. 
--�������� �������� ����������: ����������� (��������� ��������� ��, ���������� � ����������, ���� ���������� ���, ���� �� ���������� �� ����);
--��������������� (���������� ������ ����������� ����� ������������� ��������� ��); ��������������� (���������� ��������� ������� ������������
--���������� �� ���������� �� ����������);
--������������� (��������� � ��, ����������� � ��������������� �����������, ����� ���� �������� ������ � ������� ����� ����������).
--������� ���������� - ������ ����� ��������� ���������� INSERT, UPDATE ��� DELETE ��� ������� ����������. ����� ���������� - ������ ���
--������ ���������� ����� Transact-SQL, ������ � ����� ������� ������������ ������ ������������, 
--��� BEGIN TRANSACTION, COMMIT � ROLLBACK.
--task1 ������� ����������
set nocount on
	if  exists (select * from  SYS.OBJECTS        -- ������� X ����?
	            where OBJECT_ID= object_id(N'DBO.X') )	            
	drop table X;           
	declare @c int, @flag char = 'c';           -- commit ��� rollback? ����� ��� ��������
	SET IMPLICIT_TRANSACTIONS  ON   -- �����. ����� ������� ����������
	CREATE table X(K int );                         -- ������ ���������� 
		INSERT X values (1),(2),(3);
		set @c = (select count(*) from X);
		print '���������� ����� � ������� X: ' + cast( @c as varchar(2));
		if @flag = 'c'  commit;                   -- ���������� ����������: �������� 
	          else   rollback;                                 -- ���������� ����������: �����  
      SET IMPLICIT_TRANSACTIONS  OFF   -- ������. ����� ������� ����������
	
	if  exists (select * from  SYS.OBJECTS       -- ������� X ����?
	            where OBJECT_ID= object_id(N'DBO.X') )
	print '������� X ����';  
      else print '������� X ���'

	  --task2 ����������� ����� ���������� --���������� ���������� ������ TRY ����� � ����������� COMMIT
	  Use univer
	  begin try
	  begin tran --������ ����� ����������
	  delete PROGRESS where PROGRESS.NOTE =4;
	  insert PULPIT values ('����', '�������������� ������ � ���������� ', '��' );
	  commit tran --��������
	  end try
	  begin catch
	  print '������: ' + case
	  when error_number()=2627 and patindex('%PULPIT_PK%',error_message())>0 --PATINDEX ����������������� ������� ������� �������
	                                                                         --��������� �������� ��������
	  then '������������ ������'
	  else '����������� ������: ' + cast(error_number() as varchar(5)) + error_message()
	  end;
	  if @@TRANCOUNT>0 rollback tran; --@@TRANCOUNT ���������� ������� ����������� ����������. 
	  end catch;

	  --task3���� ���������� ������� �� ���������� ����������� ������ ���������� T-SQL, 
	  --���������� ���� ������, �� ����� ���� ����������� �������� SAVE TRANSACTION, ����������� ����������� ����� ����������.
	  set nocount on
	  declare @point varchar(32);
	  begin try
	  begin tran
	  delete PROGRESS where PROGRESS.NOTE =5;
	  set @point ='p1'; save tran @point; --����������� ����� 1 ��� ���� ���� ���������� ���� �� ���������� ������ ������ ����������
	  insert PULPIT values ('����', '�������������� ������ � ���������� ', '��' );
	  set @point = 'p2'; save tran @point; --����� ����� 2
	  insert PULPIT values ('�����', '����� ������� ����� �� �����', '��')
	  commit tran --��������
	  end try
	  begin catch
	  print '������: ' + case
	  when error_number()=2627 and patindex('%PULPIT_PK%',error_message())>0
	  then '������������ ������'
	  else '����������� ������: ' + cast(error_number() as varchar(5)) + error_message()
	  end;
	  if @@TRANCOUNT>0 rollback tran;
	  begin
	  print '����������� �����:' + @point;
	  end
	  end catch;

	  --task4
		--A-- ����� ���������� � ������� ��������������� READ UNCOMMITED, ������ ����������������� ������
		DELETE FACULTY WHERE FACULTY_NAME = '���' 


		set transaction isolation level read�. uncommitted
		begin transaction
		select @@SPID,  * from FACULTY --@@SPID ���������� ��������� ������������� ��������, ����������� �������� �������� �����������
		WHERE FACULTY = '���';
		select @@SPID, PULPIT.FACULTY FROM PULPIT
		WHERE FACULTY = '���';
		commit;
		--B-- ����� ���������� � ������� ��������������� READ COMMITED  ������ ��������������� ������
		begin transaction
		select @@SPID --���������� ��������� ������������� ��������, ����������� �������� �������� �����������.
		insert FACULTY values ('���', '���')
		update PROGRESS set NOTE = 7
		where IDSTUDENT = 2
		commit;

		--task5
		-- ������� READ COMMITED �� ��������� ����������������� ������, �� ��� ���� �������� ��������������� � ��������� ������. 
		--��� ���������������� �������� ������ ����� �������� ��������� ��������, �.��. �������������� ������, ���������� ����������, 
		--����� ����������� ������� ������������.
		set transaction isolation level READ COMMITTED 
	begin transaction 
	select count(*) from PULPIT 	where PULPIT = '����';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  ' PULPIT'  '���������', count(*)
	                           from PULPIT  where PULPIT = '����';
	commit; 

	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
          update PULPIT set PULPIT = '����' 
                                       where PULPIT = '����' 
          commit; 

		  --TASK6

		  set transaction isolation level  REPEATABLE READ 
	begin transaction 
	select PULPIT from PULPIT where PULPIT_NAME = '����������� ����������� �������������� ����������';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  case
          when PULPIT = '����' then 'insert  PULPIT'  else ' ' 
end '���������', PULPIT from PULPIT  where PULPIT_NAME = '�������������� ������� � ����������';
	commit; 

	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
          insert PULPIT values ('��',  '��',  '��');
          commit; 

		  --TASK7--
--a
set transaction isolation level SERIALIZABLE
begin transaction
insert into PROGRESS values ('����', 15, '2013-12-01', 9);
select * from PROGRESS where NOTE = 9;
commit;

--b�
set transaction isolation level READ COMMITTED
begin transaction
delete from PROGRESS where NOTE = 10;
insert into PROGRESS values ('����', 15, '2013-12-01', 9);
insert into PROGRESS values ('����', 2, '2013-10-01', 9);
select * from PROGRESS where NOTE = 9;
commit;
      -------------------------- t2 --------------------

	  --task8
	
delete from progress where NOTE = 10
begin transaction

insert into PROGRESS values ('����', 15, '2013-12-01', 9);

begin transaction
update PROGRESS set SUBJECT='����' where NOTE=8;
insert into PROGRESS values ('��', 21, '2013-05-06', 9);
commit;

select * from PROGRESS where NOTE=9;

if @@trancount > 0 rollback;
select * from PROGRESS where NOTE=9;

-- �������� COMMIT ��������� ���������� ��������� ������ �� ���������� �������� ��������� ����������; 
--- �������� ROLLBACK ������� ���������� �������� ��������������� �������� ���������� ����������; 
--- �������� ROLLBACK ��������� ���������� ��������� �� �������� ������� � ���������� ����������, � ����� ��������� ��� ����������; 
--- ������� ����������� ���������� ����� ���������� � ������� ��������� ������� @@TRANCOUT. 
