--Хранимая процедура – это поименованный код на языке Transact-SQL. Хранимая процедура может быть создана с
--помощью CREATE, изменена с помощью ALTER и удалена с помощью оператора DROP. Процедура может принимать входные и формировать выходные параметры.
--Результатом ее выполнения может быть целочисленное значение, которое возвращается к точке вызова оператором RETURN, либо один или более 
--результирующих наборов, сформированных операторами SELECT, либо содержимое стандартного выходного потока, полученного при выполнении операторов PRINT. 
--Вызов процедуры осуществляется оператором EXECUTE (EXEC).
--В хранимых процедурах допускается применение основных DDL, DML и TCL-операторов, конструкций TRY/CATCH, курсоров, временных таблиц.

create proc PSUBJECT as
begin
	declare @COUNT int = (select count(*) from SUBJECT)
	--select s.SUBJECT Код, s.SUBJECT_NAME Дисциплина, s.PULPIT Кафедра from SUBJECT s
	return @COUNT
end

drop proc PSUBJECT

declare @COUNT_OUTPUT int = 0
exec @COUNT_OUTPUT = PSUBJECT
print 'Количество дисциплин: ' + cast(@COUNT_OUTPUT as varchar)