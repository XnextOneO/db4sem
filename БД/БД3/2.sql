--//разработать скрипты для создания таблиц и их наполнения(по 4 записи ) :
-- sessia (subj -предмет,primary key ;idst - код студента,foreign key ; pdate - дата экзамена;note - оценка) и
-- student(idst - код студента,primary key ;idgroup - индентификатор группы;name - фамилия,имя,отчество;bday - дата рождения).
-- Использовать identity ,ограничения not null,default,check ,установить связи.

create table student
(
    idst    int primary key,
    idgroup int,
    name    varchar(50),
    bday    date
);
INSERT into STUDENT ( idgroup, name, bday)
  values ( 1, 'a','09-03-2022');
create table sessia
(
    subj    varchar(50),
    idst    int,
    pdate   date,
    note    int
);
INSERT into SESSIA ( idst, subj, pdate, note)
    values ( 1, 'Математика', '09-03-2022', 5);




















