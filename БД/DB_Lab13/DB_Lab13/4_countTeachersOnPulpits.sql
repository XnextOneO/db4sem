create function FCTEACHER (@PULPIT varchar(20)) returns int
as begin
	declare @COUNT int = (select count(*)
						  from   TEACHER t
						  where  t.PULPIT = isnull(@PULPIT, t.PULPIT))
	return @COUNT
end

drop function FCTEACHER

print 'Кол-во преподавателей всего: ' + cast(dbo.FCTEACHER(null) as varchar)
print 'Кол-во преподавателей ИСиТ:  ' + cast(dbo.FCTEACHER('ИСиТ') as varchar)
select PULPIT Кафедра, dbo.FCTEACHER(PULPIT) [Кол-во преподавателей]
from   PULPIT
--Функция принимает один параметр, задающий код кафедры. Функция возвращает количество преподавателей на заданной 
--параметром кафедре. Если параметр равен NULL, то возвращается общее количество преподавателей. 
