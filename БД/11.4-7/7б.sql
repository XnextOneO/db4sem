--11-7�
set transaction isolation level READ COMMITTED
begin transaction
delete from PROGRESS where NOTE = 10;
insert into PROGRESS values ('����', 15, '2013-12-01', 9);
insert into PROGRESS values ('����', 2, '2013-10-01', 9);
select * from PROGRESS where NOTE = 9;
commit;