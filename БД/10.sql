use UNIVER
go

----1Курсор является программной конструкцией, которая дает возможность пользователю обрабатывать строки
----результирующего набора запись за записью. Курсоры бывают локальные и глобальные (по умолчанию), статические и динамические (по умолчанию). 

--declare @sub nvarchar(50), @allsub nvarchar(500) = ''
--declare cur cursor
--				for select SUBJECT from SUBJECT --получаем все предметы
--open cur
--	fetch cur into @sub  --fetch  FETCH считывает одну строку из результирующего набора и продвигает указатель на следующую строку
--	while @@FETCH_STATUS = 0 --возвращает статус последнего оператора FETCH курсора 0-выполнен успешно -1 неудача или за пределы набора
--		begin
--			set @allsub = rtrim(@sub) + ' ,' + @allsub --Возвращает строку символов после усечения всех завершающих пробелов
--			fetch cur into @sub
--		end
--	print @allsub
--close cur

----2
--declare sub cursor local 
--					--global                           
--	             for select SUBJECT, PULPIT from SUBJECT;
--declare @tv char(20), @cena char(20);      
--open sub;	  
--		fetch sub into @tv, @cena; 	
--		print '1. ' + @tv + @cena;   
--go
--declare @tv char(20), @cena char(20);     	
--fetch sub into @tv, @cena; 	
--print '2. ' + @tv + @cena;  
--go  
--close sub
--deallocate sub

--select * from STUDENT
--3
	--GO
	--DECLARE @tid char(40), @tnm int;  
	--DECLARE stud cursor local static 
	--			  --dynamic                             
	--	 for SELECT NAME, IDSTUDENT 
	--		   FROM STUDENT where IDGROUP = 10;           
	--OPEN stud;
	--  print 'Количество студентов : '+cast(@@CURSOR_ROWS as varchar(5)); 

	--  update STUDENT set Name = 'Андревфый' where IDSTUDENT = 34

	--  FETCH stud into @tid, @tnm;     
	--  WHILE @@fetch_status = 0                                    
	--	  BEGIN 
	--		  print @tid + ' '+ cast(@tnm as varchar(50));      
	--		  FETCH stud into @tid, @tnm; 
	--	  END;          
	--CLOSE stud;



--4 SCROLL, позволяющий применять оператор FETCH с дополнительными опциями позиционирования. 

--declare @tc int, @rn char(50);  
--declare Primer1 cursor local dynamic SCROLL                               
--	for SELECT row_number() over (order by NAME) N, NAME
--		FROM STUDENT
--		where IDGROUP = 10
--OPEN Primer1;
--	FETCH  Primer1 into  @tc, @rn;  
--	print 'Первая строка           : ' + cast(@tc as varchar(3)) + ' ' + rtrim(@rn)

--	fetch next from Primer1 into @tc, @rn
--	print 'Следующая строка        : ' + cast(@tc as varchar(3)) + ' ' + rtrim(@rn)      

--	fetch last from  Primer1 into @tc, @rn;       
--	print 'Последняя строка        : ' +  cast(@tc as varchar(3)) + ' ' + rtrim(@rn)    

--	fetch prior from Primer1 into @tc, @rn
--	print 'Предыдущая строка       : ' + cast(@tc as varchar(3)) + ' ' + rtrim(@rn)

--	fetch absolute 5 from Primer1 into @tc, @rn
--	print 'Пятая строка с начала   : ' + cast(@tc as varchar(3)) + ' ' + rtrim(@rn)

--	fetch relative 3 from Primer1 into @tc, @rn
--	print 'Третья строка от текущей: ' + cast(@tc as varchar(3)) + ' ' + rtrim(@rn)

--CLOSE Primer1;

--5
	declare @tn char(50), @tc int, @tk int
	declare Primer2 cursor local dynamic
		for select NAME,  IDGROUP ,IDSTUDENT
			from STUDENT 
			where IDGROUP = 9 for update
	open Primer2
	fetch Primer2 into @tn, @tc, @tk
	delete STUDENT where current of Primer2
	fetch last from Primer2 into @tn, @tc, @tk
	update STUDENT set NAME = 'Андревфый'
		where current of Primer2
	fetch first from Primer2 into @tn, @tc, @tk
	while @@fetch_status = 0                                    
	      begin 
	          print @tn + ' ' + cast(@tc as varchar(50)) + ' ' + cast(@tk as varchar(50));      
	          fetch Primer2 into @tn, @tc, @tk; 
	       end;   
	close Primer2

select * from PROGRESS
	join STUDENT on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
	join GROUPS on GROUPS.IDGROUP = STUDENT.IDGROUP
--6.1
--declare @note int, @id int, @name char(50)
--declare Primer3 cursor local dynamic
--	for select NOTE, PROGRESS.IDSTUDENT, NAME
--		from PROGRESS
--			join STUDENT
--				on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
--			join GROUPS 
--				on GROUPS.IDGROUP = STUDENT.IDGROUP
--			where NOTE < 6 for update
--open Primer3
--fetch Primer3 into @note, @id, @name
--while @@fetch_status = 0                                    
--	begin 
--		print @name + ' ' + cast(@id as varchar(50)) + ' ' + cast(@note as varchar(50));
--		delete PROGRESS where current of Primer3
--        fetch Primer3 into @note, @id, @name; 
--    end; 
--close Primer3

----6.2
--declare @note int, @id int, @name char(50)
--declare Primer3 cursor local dynamic
--	for select NOTE, PROGRESS.IDSTUDENT, NAME
--		from PROGRESS
--			join STUDENT
--				on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
--			join GROUPS 
--				on GROUPS.IDGROUP = STUDENT.IDGROUP
--			where PROGRESS.IDSTUDENT = 19 for update
--open Primer3
--fetch Primer3 into @note, @id, @name
--print @name + ' ' + cast(@id as varchar(50)) + '      ' + cast(@note as varchar(50));
--update PROGRESS set NOTE = NOTE + 1
--	where current of Primer3
--print @name + ' ' + cast(@id as varchar(50)) + '      ' + cast(@note as varchar(50));
--close Primer3
