--xml
--XML (Extensible Markup Language) – расширяемый язык разметки. XML-формат часто используется для обмена данными между компонентами 
--информационных систем. При работе с базами данных важными являются две задачи:
--преобразование табличных данных в XML-структуры и преобразование XML-структур в строки реляционной таблицы
use Univer;

--task1
--В режиме RAW в результате SELECT-запроса создается XML-фрагмент, состоящий из последовательности элементов с именем row.
--Каждый элемент row соответствует строке результирующего набора, 
--имена его атрибутов совпадают с именами столбцов результирующего набора, а значения атрибутов равны их значениям

select TEACHER, TEACHER_NAME, GENDER, PULPIT from TEACHER 
where PULPIT = 'ИСиТ'
for xml raw

select TEACHER, TEACHER_NAME, GENDER, PULPIT from TEACHER 
where PULPIT = 'ИСиТ'
for xml raw('Преподаватель')

select TEACHER, TEACHER_NAME, GENDER, PULPIT from TEACHER 
where PULPIT = 'ИСиТ'
for xml raw('Преподаватель'), root ('Преподаватели_ИСИТ'), elements

--task2
--Особенность режима AUTO проявляется в многотабличных запросах. 
--В этом случае режим AUTO позволяет построить XML-фрагмент с применением вложенных элементо

select AUDITORIUM_NAME, AUDITORIUM_TYPENAME, AUDITORIUM_CAPACITY from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = 'ЛК'
for xml auto, root ('Лекционные_аудитории'), elements

--При использовании режима PATH каждый столбец конфигурируется независимо с помощью псевдонима этого столбца

select AUDITORIUM_NAME, AUDITORIUM_TYPENAME, AUDITORIUM_CAPACITY from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = 'ЛК'
for xml path ('Аудитория'), root ('Лекционные_аудитории'), elements


--task3

delete from SUBJECT where SUBJECT='КМСИД' or SUBJECT='ОС' or SUBJECT='КСИС'

go
declare @handle int = 0,
        @x varchar(2500) = '<?xml version="1.0" encoding="windows-1251" ?>
       <Предметы> 
       <subj Предмет="КМСИД" Название="Компьютерные мультимедийные системы в ИД" Кафедра="ИСиТ"/> 
       <subj Предмет="ОС" Название="Операционные системы" Кафедра="ИСиТ"/>
	   <subj Предмет="КСИС" Название="Компьютерные системы и сети" Кафедра="ИСиТ"/> 
       </Предметы>';
exec sp_xml_preparedocument @handle output, @x;
select * from openxml(@handle, '/Предметы/subj', 0)  --openxml для преобразования xml-данных в строки таблицы(дескриптоп-путь-число опред режим раюоты

--0 - используется атрибутивная модель сопоставления, каждый XML-атрибут преобразовывается в столбец таблицы; 1- аналогично типу 0
--, но для необработанных столбцов применяется сопоставление на основе элементов XML-документа; 2 - используется сопоставление на основе
--элементов, каждый элемент преобразовывается в столбец таблицы). 

with ([Предмет] char(10), [Название] varchar(100), [Кафедра] char(20)); --указана структура формируемого результата.  

insert into SUBJECT 
	select * from openxml(@handle, '/Предметы/subj', 0)
	with ([Предмет] char(10), [Название] varchar(100), [Кафедра] char(20));

select * from SUBJECT;


--task4

create table BSTUSTUDENT
(
IDSTUDENT int identity(1,1) primary key,
NAME varchar(200),
PASSPORT xml
)

insert into BSTUSTUDENT
values
('Журавлёв Андрей Евгеньевич', '<Паспорт><Серия>MP</Серия><Номер>1736654</Номер><Личный_номер>070803</Личный_номер><Дата_выдачи>2018-07-07</Дата_выдачи>
<Адрес>г. Минск, ул. Мирошниченко, д. 9, кв. 202</Адрес></Паспорт>'),
('Савенко Евгения Павловна', '<Паспорт><Серия>MP</Серия><Номер>1236454</Номер><Личный_номер>112088</Личный_номер><Дата_выдачи>2019-08-07</Дата_выдачи>
<Адрес>г. Минск, ул. Восточная, д. 14, кв. 55</Адрес></Паспорт>'),
('Кришталь Дарья Сергеевна', '<Паспорт><Серия>MP</Серия><Номер>1778854</Номер><Личный_номер>254567</Личный_номер><Дата_выдачи>2020-01-01</Дата_выдачи>
<Адрес>г. Минск, ул. Мирошниченко, д. 27, кв. 252</Адрес></Паспорт>')

select * from BSTUSTUDENT;

update BSTUSTUDENT
	   set PASSPORT = '<Паспорт><Серия>MP</Серия><Номер>1736654</Номер><Личный_номер>070803</Личный_номер><Дата_выдачи>2022-05-22</Дата_выдачи>
<Адрес>г. Минск, ул. Мирошниченко, д. 9, кв. 202</Адрес></Паспорт>'
       where PASSPORT.value('(/Паспорт/Личный_номер)[1]', 'varchar(10)') = '070803';

select NAME, 
       PASSPORT.value('(/Паспорт/Серия)[1]', 'varchar(5)') [Серия],
	   PASSPORT.value('(/Паспорт/Номер)[1]', 'varchar(25)') [Номер],
	   PASSPORT.value('(/Паспорт/Личный_номер)[1]', 'varchar(25)') [Личный номер],
	   PASSPORT.query ('/Паспорт/Дата_выдачи') [Дата выдачи],
	   PASSPORT.query ('/Паспорт/Адрес') [Полный адрес]
from BSTUSTUDENT

--task5

go

-- обновление схемы :

-- 1. отключаем использование схемы в xml-поле таблицы, если таковое существует
alter table STUDENT alter column INFO xml 

-- 2. удаляем схему, если таковая существует
drop xml schema collection Student

-- 3. создаем схему
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xs:element name="студент">  
	   <xs:complexType>
	   <xs:sequence>
		   <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
			   <xs:complexType>
				   <xs:attribute name="серия" type="xs:string" use="required" />
				   <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
				   <xs:attribute name="дата"  use="required" >  
						 <xs:simpleType>  
							  <xs:restriction base ="xs:string">
									<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
							  </xs:restriction> 	
						 </xs:simpleType>
				   </xs:attribute> 
				</xs:complexType> 
			</xs:element>
			<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
			<xs:element name="адрес">   
				<xs:complexType>
					<xs:sequence>
						<xs:element name="страна" type="xs:string" />
						<xs:element name="город" type="xs:string" />
						<xs:element name="улица" type="xs:string" />
						<xs:element name="дом" type="xs:string" />
						<xs:element name="квартира" type="xs:string" />
					</xs:sequence>
			   </xs:complexType>
		    </xs:element>
	   </xs:sequence>
	   </xs:complexType>
   </xs:element>
</xs:schema>';

-- 4. используем схему в поле таблицы
alter table STUDENT alter column INFO xml(Student);

--!!!!!!!!!!!!!!!!!!!!!!! УДАЛИТЬ alter table STUDENT drop column STAMP

select * from STUDENT;

--вставка значения без ошибок:
insert into STUDENT (IDGROUP, NAME, BDAY, INFO, FOTO) values 
(3, 'Журавлёв Андрей Евгеньевич', '2002-08-07', 
'<?xml version="1.0" encoding="windows-1251" ?>
<студент>
<паспорт серия="MP" номер="0708303" дата="22.05.2022"></паспорт>
<телефон>7655641</телефон>
<адрес><страна>Беларусь</страна><город>Минск</город><улица>Мирошниченко</улица><дом>9</дом><квартира>202</квартира></адрес>
</студент>', NULL);

--вставка с ошибкой: (дата без точки, не пройдет по регулярному выражению схемы)
insert into STUDENT (IDGROUP, NAME, BDAY, INFO, FOTO) values 
(3, 'Кришталь Андрей Евгеньевич', '2002-08-07', 
'<?xml version="1.0" encoding="windows-1251" ?>
<студент>
<паспорт серия="MP" номер="0708303" дата="22052022"></паспорт>
<телефон>7655641</телефон>
<адрес><страна>Беларусь</страна><город>Минск</город><улица>Мирошниченко</улица><дом>9</дом><квартира>202</квартира></адрес>
</студент>', NULL);

--не даст обновить: (дата без точки, не пройдет по регулярному выражению схемы)
update STUDENT set INFO = '<?xml version="1.0" encoding="windows-1251" ?>
<студент>
<паспорт серия="MP" номер="0708303" дата="22052022"></паспорт>
<телефон>7655641</телефон>
<адрес><страна>Беларусь</страна><город>Минск</город><улица>Мирошниченко</улица><дом>9</дом><квартира>202</квартира></адрес>
</студент>' where NAME='Шейбак Дарья Кирилловна'

--даст обновить:
update STUDENT set INFO = '<?xml version="1.0" encoding="windows-1251" ?>
<студент>
<паспорт серия="MP" номер="0708303" дата="18.07.2019"></паспорт>
<телефон>7655641</телефон>
<адрес><страна>Беларусь</страна><город>Минск</город><улица>Мирошниченко</улица><дом>9</дом><квартира>202</квартира></адрес>
</студент>' where NAME='Шейбак Дарья Кирилловна'


--создадим свою схему и применим ее к полю INFO таблицы SUBJECT

create xml schema collection SubjectInfo as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xs:element name="Дисциплина">  
	   <xs:complexType>
	   <xs:sequence>
		   <xs:element name="Информация" maxOccurs="1" minOccurs="1">
			   <xs:complexType>
				   <xs:attribute name="Преподаватель" type="xs:string" use="required" />
				   <xs:attribute name="Кафедра" type="xs:string" use="required"/>
				</xs:complexType> 
			</xs:element>
		    <xs:element name="План">   
				<xs:complexType>
					<xs:sequence>
						<xs:element name="Количество_часов" type="xs:unsignedInt" />
						<xs:element name="Количество_пар" type="xs:unsignedInt" />
						<xs:element name="Количество_студентов" type="xs:unsignedInt" />
					</xs:sequence>
			   </xs:complexType>
		    </xs:element>
	   </xs:sequence>
	   </xs:complexType>
   </xs:element>
</xs:schema>';

alter table SUBJECT add INFO xml (SubjectInfo)

select * from SUBJECT;

insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT, INFO) values 
('АЛГ', 'Линейная алгебра', 'ИСиТ', 
'<?xml version="1.0" encoding="windows-1251" ?>
<Дисциплина>
<Информация Преподаватель="Барковский Евгений Валерьевич" Кафедра="ИСиТ"></Информация>
<План><Количество_часов>56</Количество_часов><Количество_пар>25</Количество_пар><Количество_студентов>78</Количество_студентов></План>
</Дисциплина>');