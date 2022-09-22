--11-7а
--a
set transaction isolation level SERIALIZABLE --фантомное чтение фикс
begin transaction
insert into PROGRESS values ('СУБД', 15, '2013-12-01', 9);
select * from PROGRESS where NOTE = 9;
commit;
