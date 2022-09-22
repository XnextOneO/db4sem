--Транзакция -  это механизм базы данных, позволяющий таким образом объединять несколько операторов, изменяющих базу данных,
--чтобы при выполнении этой совокупности операторов они или все выполнились или все не выполнились. 
--Основные свойства транзакции: атомарность (операторы изменения БД, включенные в транзакцию, либо выполнятся все, либо не выполнится ни один);
--согласованность (транзакция должна фиксировать новое согласованное состояние БД); изолированность (отсутствие взаимного влияния параллельных
--транзакций на результаты их выполнения);
--долговечность (изменения в БД, выполненные и зафиксированные транзакцией, могут быть отменены только с помощью новой транзакции).
--Неявная транзакция - задает любую отдельную инструкцию INSERT, UPDATE или DELETE как единицу транзакции. Явная транзакция - обычно это
--группа инструкций языка Transact-SQL, начало и конец которой обозначаются такими инструкциями, 
--как BEGIN TRANSACTION, COMMIT и ROLLBACK.
--task1 НЕЯВНАЯ ТРАНЗАКЦИЯ
set nocount on
	if  exists (select * from  SYS.OBJECTS        -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.X') )	            
	drop table X;           
	declare @c int, @flag char = 'c';           -- commit или rollback? откат или фиксация
	SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции
	CREATE table X(K int );                         -- начало транзакции 
		INSERT X values (1),(2),(3);
		set @c = (select count(*) from X);
		print 'количество строк в таблице X: ' + cast( @c as varchar(2));
		if @flag = 'c'  commit;                   -- завершение транзакции: фиксация 
	          else   rollback;                                 -- завершение транзакции: откат  
      SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции
	
	if  exists (select * from  SYS.OBJECTS       -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.X') )
	print 'таблица X есть';  
      else print 'таблицы X нет'

	  --task2 АТОМАРНОСТЬ ЯВНОЙ ТРАНЗАКЦИИ --транзакция начинается внутри TRY блока и завершается COMMIT
	  Use univer
	  begin try
	  begin tran --начало явной транзакции
	  delete PROGRESS where PROGRESS.NOTE =4;
	  insert PULPIT values ('ИСиТ', 'Информационных систем и технологий ', 'ИТ' );
	  commit tran --фиксация
	  end try
	  begin catch
	  print 'ошибка: ' + case
	  when error_number()=2627 and patindex('%PULPIT_PK%',error_message())>0 --PATINDEX определяетвстроке позицию первого символа
	                                                                         --подстроки заданную шаблоном
	  then 'дублирование товара'
	  else 'неизвестная ошибка: ' + cast(error_number() as varchar(5)) + error_message()
	  end;
	  if @@TRANCOUNT>0 rollback tran; --@@TRANCOUNT возвращает уровень вложенности транзакции. 
	  end catch;

	  --task3Если транзакция состоит из нескольких независимых блоков операторов T-SQL, 
	  --изменяющих базу данных, то может быть использован оператор SAVE TRANSACTION, формирующий контрольную точку транзакции.
	  set nocount on
	  declare @point varchar(32);
	  begin try
	  begin tran
	  delete PROGRESS where PROGRESS.NOTE =5;
	  set @point ='p1'; save tran @point; --контрольная точка 1 для того если транзакция сост из нескольких незави блоков операторов
	  insert PULPIT values ('ИСиТ', 'Информационных систем и технологий ', 'ИТ' );
	  set @point = 'p2'; save tran @point; --контр точка 2
	  insert PULPIT values ('НКННЗ', 'Наука которую никто не знает', 'ХЗ')
	  commit tran --фиксация
	  end try
	  begin catch
	  print 'ошибка: ' + case
	  when error_number()=2627 and patindex('%PULPIT_PK%',error_message())>0
	  then 'дублирование товара'
	  else 'неизвестная ошибка: ' + cast(error_number() as varchar(5)) + error_message()
	  end;
	  if @@TRANCOUNT>0 rollback tran;
	  begin
	  print 'контрольная точка:' + @point;
	  end
	  end catch;

	  --task4
		--A-- явная транзакция с уровнем изолированности READ UNCOMMITED, Чтение незафиксированных данных
		DELETE FACULTY WHERE FACULTY_NAME = 'ФАК' 


		set transaction isolation level readю. uncommitted
		begin transaction
		select @@SPID,  * from FACULTY --@@SPID возвращает системный идентификатор процесса, назначенный сервером текущему подключению
		WHERE FACULTY = 'ФАК';
		select @@SPID, PULPIT.FACULTY FROM PULPIT
		WHERE FACULTY = 'ФАК';
		commit;
		--B-- явную транзакцию с уровнем изолированности READ COMMITED  Чтение зафиксированных данных
		begin transaction
		select @@SPID --возвращает системный идентификатор процесса, назначенный сервером текущему подключению.
		insert FACULTY values ('ФАК', 'ФАК')
		update PROGRESS set NOTE = 7
		where IDSTUDENT = 2
		commit;

		--task5
		-- уровень READ COMMITED не допускает неподтвержденного чтения, но при этом возможно неповторяющееся и фантомное чтение. 
		--Две последовательные операции чтения могут получать различные значения, т. к. дополнительные строки, называемые фантомными, 
		--могут добавляться другими транзакциями.
		set transaction isolation level READ COMMITTED 
	begin transaction 
	select count(*) from PULPIT 	where PULPIT = 'ПОИТ';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  ' PULPIT'  'результат', count(*)
	                           from PULPIT  where PULPIT = 'ПОИТ';
	commit; 

	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
          update PULPIT set PULPIT = 'ПОИТ' 
                                       where PULPIT = 'ПОУТ' 
          commit; 

		  --TASK6

		  set transaction isolation level  REPEATABLE READ 
	begin transaction 
	select PULPIT from PULPIT where PULPIT_NAME = 'Программное обеспечение информационных технологий';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  case
          when PULPIT = 'ИСИТ' then 'insert  PULPIT'  else ' ' 
end 'результат', PULPIT from PULPIT  where PULPIT_NAME = 'Информационные системы и технологии';
	commit; 

	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
          insert PULPIT values ('ИТ',  'ИТ',  'ИТ');
          commit; 

		  --TASK7--
--a
set transaction isolation level SERIALIZABLE
begin transaction
insert into PROGRESS values ('СУБД', 15, '2013-12-01', 9);
select * from PROGRESS where NOTE = 9;
commit;

--b—
set transaction isolation level READ COMMITTED
begin transaction
delete from PROGRESS where NOTE = 10;
insert into PROGRESS values ('СУБД', 15, '2013-12-01', 9);
insert into PROGRESS values ('ОАиП', 2, '2013-10-01', 9);
select * from PROGRESS where NOTE = 9;
commit;
      -------------------------- t2 --------------------

	  --task8
	
delete from progress where NOTE = 10
begin transaction

insert into PROGRESS values ('СУБД', 15, '2013-12-01', 9);

begin transaction
update PROGRESS set SUBJECT='ОАиП' where NOTE=8;
insert into PROGRESS values ('КГ', 21, '2013-05-06', 9);
commit;

select * from PROGRESS where NOTE=9;

if @@trancount > 0 rollback;
select * from PROGRESS where NOTE=9;

-- оператор COMMIT вложенной транзакции действует только на внутренние операции вложенной транзакции; 
--- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции; 
--- оператор ROLLBACK вложенной транзакции действует на операции внешней и внутренней транзакции, а также завершает обе транзакции; 
--- уровень вложенности транзакции можно определить с помощью системной функции @@TRANCOUT. 
