--11-6б Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 

	begin transaction 	  
	-------------------------- t1 --------------------
          insert PULPIT values ('ИТ',  'ИТ',  'ИТ');
          commit; 