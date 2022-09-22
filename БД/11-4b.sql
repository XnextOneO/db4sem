--B-- явную транзакцию с уровнем изолированности READ COMMITED  Чтение зафиксированных данных
		begin transaction
		select @@SPID --возвращает системный идентификатор процесса, назначенный сервером текущему подключению.
		insert FACULTY values ('ФАК', 'ФАК')
		update PROGRESS set NOTE = 5
		where IDSTUDENT = 1020
		commit;
