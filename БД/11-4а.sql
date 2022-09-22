--A-- явная транзакция с уровнем изолированности READ UNCOMMITED, Чтение незафиксированных данных
		DELETE FACULTY WHERE FACULTY_NAME = 'ФАК' 
		set transaction isolation level read uncommitted
		begin transaction
		select @@SPID,  * from FACULTY --@@SPID возвращает системный идентификатор процесса, назначенный сервером текущему подключению
		WHERE FACULTY = 'ФАК';
		select @@SPID, PULPIT.FACULTY FROM PULPIT
		WHERE FACULTY = 'ФАК';
		commit;