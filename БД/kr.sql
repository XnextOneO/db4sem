use master;
create database test;

use test;
--//разработать скрипты для создания таблиц и их наполнения(по 4 записи ) : sessia (subj -предмет,foreign key??????? ;idst - код студента,foreign key ; pdate - дата экзамена;note - оценка) и student(idst - код студента,primary key ;idgroup - индентификатор группы;name - фамилия,имя,отчество;bday - дата рождения). Использовать identity ,ограничения not null,default,check ,установить связи.
create table student
(
    idst    int         not null primary key identity,
    idgroup int         check(idgroup>0),
    name    varchar(50) not null,
    bday    date        not null
); 
INSERT into STUDENT ( idgroup, name, bday)
	values ( 1, 'a','09-01-2022'),
	       ( 2, 'b','09-02-2022'),
	       ( 3, 'c','09-03-2022'),
		   ( 5, 'e','09-03-2022'),
	       ( 4, 'd','09-04-2022');
create table subject
(
    subj    varchar(50) not null primary key,
    idgroup int         not null
);
INSERT into SUBJECT ( subj, idgroup)
    values ( 'Математика', 1);
create table sessia
(
    idst  int         not null,	
    subj  varchar(50) not null,
    pdate date        not null,
    note  int         not null,
    foreign key (idst) references student (idst),
    foreign key (subj) references subject (subj)
);
INSERT into SESSIA ( idst, subj, pdate, note)
    values ( 1, 'Математика', '09-03-2022', 7),
	       ( 2, 'Математика', '09-03-2022', 8),
	       ( 3, 'Математика', '09-03-2022', 9),
		   ( 5, 'Математика', '09-03-2022', 4),
		   ( 4, 'Математика', '09-03-2022', 9);
--сформировать перечень студентов получивших экзаменационные оценки от 7 до 9 баллов в предмете математика.
select s.name, s.bday, s.idst from student s inner join sessia ses on s.idst = ses.idst where ses.subj = 'Математика' and ses.note between 7 and 9;
---2 zad кол-во оценок от 7 до 9 + сортировка + group by

select count(*) from sessia where note between 7 and 9 group by subj;