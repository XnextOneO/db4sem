--это объект Ѕƒ, представл€ющий собой поименованный код T-SQL, CREATE DROP ALTER, Ќ≈Ћ№«я DDL и DML операторы,try-catch и транзакции
--“аблична€ функци€ возвращает таблицу.—кал€рна€ означает что возвращает значение которое может быть представлено одним числом. 
create function COUNT_STUDENTS (@FACULTY varchar(20)) returns int
as begin
	declare @COUNT int = (select count(*)
						  from STUDENT s
						  join GROUPS g on s.IDGROUP = g.IDGROUP
						  join FACULTY f on f.FACULTY = g.FACULTY
						  where g.FACULTY = @FACULTY)
	return @COUNT
end

drop function COUNT_STUDENTS

declare @RES int = dbo.COUNT_STUDENTS('»ƒиѕ')
print ' оличество студентов: ' + cast(@RES as varchar)