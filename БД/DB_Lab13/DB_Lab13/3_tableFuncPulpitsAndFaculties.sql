create function FFACPUL (@FACULTY varchar(20), @PULPIT varchar(20)) returns table
as return
	select f.FACULTY Факультет, p.PULPIT Кафедра
	from   FACULTY f left join PULPIT p 
	on	   p.FACULTY = f.FACULTY
	where  f.FACULTY = isnull(@FACULTY, f.FACULTY)
	and	   p.PULPIT = isnull (@PULPIT, p.PULPIT)

drop function FFACPUL

select * from FFACPUL(null, null)
select * from FFACPUL('ИЭФ', null)
select * from FFACPUL(null, 'ОХ')
select * from FFACPUL('ТТЛП', 'ТЛ')

--Функция принимает два параметра, задающих код факультета (столбец FACULTY.FACULTY) и код кафедры (столбец PULPIT.PULPIT).
--Использует SELECT-запрос c левым внешним соединением между таблицами FACULTY и PULPIT. 
--Если оба параметра функции равны NULL, то она возвращает список всех кафедр на всех факультетах. 
--Если задан первый параметр (второй равен NULL), функция возвращает список всех кафедр заданного факультета. 
--Если задан второй параметр (первый равен NULL), функция возвращает результирующий набор, содержащий строку, соответствующую
--заданной кафедре.
