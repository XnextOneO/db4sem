--xml
--XML (Extensible Markup Language) � ����������� ���� ��������. XML-������ ����� ������������ ��� ������ ������� ����� ������������ 
--�������������� ������. ��� ������ � ������ ������ ������� �������� ��� ������:
--�������������� ��������� ������ � XML-��������� � �������������� XML-�������� � ������ ����������� �������
use Univer;

--task1
--� ������ RAW � ���������� SELECT-������� ��������� XML-��������, ��������� �� ������������������ ��������� � ������ row.
--������ ������� row ������������� ������ ��������������� ������, 
--����� ��� ��������� ��������� � ������� �������� ��������������� ������, � �������� ��������� ����� �� ���������

select TEACHER, TEACHER_NAME, GENDER, PULPIT from TEACHER 
where PULPIT = '����'
for xml raw

select TEACHER, TEACHER_NAME, GENDER, PULPIT from TEACHER 
where PULPIT = '����'
for xml raw('�������������')

select TEACHER, TEACHER_NAME, GENDER, PULPIT from TEACHER 
where PULPIT = '����'
for xml raw('�������������'), root ('�������������_����'), elements

--task2
--����������� ������ AUTO ����������� � �������������� ��������. 
--� ���� ������ ����� AUTO ��������� ��������� XML-�������� � ����������� ��������� ��������

select AUDITORIUM_NAME, AUDITORIUM_TYPENAME, AUDITORIUM_CAPACITY from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = '��'
for xml auto, root ('����������_���������'), elements

--��� ������������� ������ PATH ������ ������� ��������������� ���������� � ������� ���������� ����� �������

select AUDITORIUM_NAME, AUDITORIUM_TYPENAME, AUDITORIUM_CAPACITY from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = '��'
for xml path ('���������'), root ('����������_���������'), elements


--task3

delete from SUBJECT where SUBJECT='�����' or SUBJECT='��' or SUBJECT='����'

go
declare @handle int = 0,
        @x varchar(2500) = '<?xml version="1.0" encoding="windows-1251" ?>
       <��������> 
       <subj �������="�����" ��������="������������ �������������� ������� � ��" �������="����"/> 
       <subj �������="��" ��������="������������ �������" �������="����"/>
	   <subj �������="����" ��������="������������ ������� � ����" �������="����"/> 
       </��������>';
exec sp_xml_preparedocument @handle output, @x;
select * from openxml(@handle, '/��������/subj', 0)  --openxml ��� �������������� xml-������ � ������ �������(����������-����-����� ����� ����� ������

--0 - ������������ ������������ ������ �������������, ������ XML-������� ����������������� � ������� �������; 1- ���������� ���� 0
--, �� ��� �������������� �������� ����������� ������������� �� ������ ��������� XML-���������; 2 - ������������ ������������� �� ������
--���������, ������ ������� ����������������� � ������� �������). 

with ([�������] char(10), [��������] varchar(100), [�������] char(20)); --������� ��������� ������������ ����������.  

insert into SUBJECT 
	select * from openxml(@handle, '/��������/subj', 0)
	with ([�������] char(10), [��������] varchar(100), [�������] char(20));

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
('������� ������ ����������', '<�������><�����>MP</�����><�����>1736654</�����><������_�����>070803</������_�����><����_������>2018-07-07</����_������>
<�����>�. �����, ��. ������������, �. 9, ��. 202</�����></�������>'),
('������� ������� ��������', '<�������><�����>MP</�����><�����>1236454</�����><������_�����>112088</������_�����><����_������>2019-08-07</����_������>
<�����>�. �����, ��. ���������, �. 14, ��. 55</�����></�������>'),
('�������� ����� ���������', '<�������><�����>MP</�����><�����>1778854</�����><������_�����>254567</������_�����><����_������>2020-01-01</����_������>
<�����>�. �����, ��. ������������, �. 27, ��. 252</�����></�������>')

select * from BSTUSTUDENT;

update BSTUSTUDENT
	   set PASSPORT = '<�������><�����>MP</�����><�����>1736654</�����><������_�����>070803</������_�����><����_������>2022-05-22</����_������>
<�����>�. �����, ��. ������������, �. 9, ��. 202</�����></�������>'
       where PASSPORT.value('(/�������/������_�����)[1]', 'varchar(10)') = '070803';

select NAME, 
       PASSPORT.value('(/�������/�����)[1]', 'varchar(5)') [�����],
	   PASSPORT.value('(/�������/�����)[1]', 'varchar(25)') [�����],
	   PASSPORT.value('(/�������/������_�����)[1]', 'varchar(25)') [������ �����],
	   PASSPORT.query ('/�������/����_������') [���� ������],
	   PASSPORT.query ('/�������/�����') [������ �����]
from BSTUSTUDENT

--task5

go

-- ���������� ����� :

-- 1. ��������� ������������� ����� � xml-���� �������, ���� ������� ����������
alter table STUDENT alter column INFO xml 

-- 2. ������� �����, ���� ������� ����������
drop xml schema collection Student

-- 3. ������� �����
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xs:element name="�������">  
	   <xs:complexType>
	   <xs:sequence>
		   <xs:element name="�������" maxOccurs="1" minOccurs="1">
			   <xs:complexType>
				   <xs:attribute name="�����" type="xs:string" use="required" />
				   <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
				   <xs:attribute name="����"  use="required" >  
						 <xs:simpleType>  
							  <xs:restriction base ="xs:string">
									<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
							  </xs:restriction> 	
						 </xs:simpleType>
				   </xs:attribute> 
				</xs:complexType> 
			</xs:element>
			<xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
			<xs:element name="�����">   
				<xs:complexType>
					<xs:sequence>
						<xs:element name="������" type="xs:string" />
						<xs:element name="�����" type="xs:string" />
						<xs:element name="�����" type="xs:string" />
						<xs:element name="���" type="xs:string" />
						<xs:element name="��������" type="xs:string" />
					</xs:sequence>
			   </xs:complexType>
		    </xs:element>
	   </xs:sequence>
	   </xs:complexType>
   </xs:element>
</xs:schema>';

-- 4. ���������� ����� � ���� �������
alter table STUDENT alter column INFO xml(Student);

--!!!!!!!!!!!!!!!!!!!!!!! ������� alter table STUDENT drop column STAMP

select * from STUDENT;

--������� �������� ��� ������:
insert into STUDENT (IDGROUP, NAME, BDAY, INFO, FOTO) values 
(3, '������� ������ ����������', '2002-08-07', 
'<?xml version="1.0" encoding="windows-1251" ?>
<�������>
<������� �����="MP" �����="0708303" ����="22.05.2022"></�������>
<�������>7655641</�������>
<�����><������>��������</������><�����>�����</�����><�����>������������</�����><���>9</���><��������>202</��������></�����>
</�������>', NULL);

--������� � �������: (���� ��� �����, �� ������� �� ����������� ��������� �����)
insert into STUDENT (IDGROUP, NAME, BDAY, INFO, FOTO) values 
(3, '�������� ������ ����������', '2002-08-07', 
'<?xml version="1.0" encoding="windows-1251" ?>
<�������>
<������� �����="MP" �����="0708303" ����="22052022"></�������>
<�������>7655641</�������>
<�����><������>��������</������><�����>�����</�����><�����>������������</�����><���>9</���><��������>202</��������></�����>
</�������>', NULL);

--�� ���� ��������: (���� ��� �����, �� ������� �� ����������� ��������� �����)
update STUDENT set INFO = '<?xml version="1.0" encoding="windows-1251" ?>
<�������>
<������� �����="MP" �����="0708303" ����="22052022"></�������>
<�������>7655641</�������>
<�����><������>��������</������><�����>�����</�����><�����>������������</�����><���>9</���><��������>202</��������></�����>
</�������>' where NAME='������ ����� ����������'

--���� ��������:
update STUDENT set INFO = '<?xml version="1.0" encoding="windows-1251" ?>
<�������>
<������� �����="MP" �����="0708303" ����="18.07.2019"></�������>
<�������>7655641</�������>
<�����><������>��������</������><�����>�����</�����><�����>������������</�����><���>9</���><��������>202</��������></�����>
</�������>' where NAME='������ ����� ����������'


--�������� ���� ����� � �������� �� � ���� INFO ������� SUBJECT

create xml schema collection SubjectInfo as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xs:element name="����������">  
	   <xs:complexType>
	   <xs:sequence>
		   <xs:element name="����������" maxOccurs="1" minOccurs="1">
			   <xs:complexType>
				   <xs:attribute name="�������������" type="xs:string" use="required" />
				   <xs:attribute name="�������" type="xs:string" use="required"/>
				</xs:complexType> 
			</xs:element>
		    <xs:element name="����">   
				<xs:complexType>
					<xs:sequence>
						<xs:element name="����������_�����" type="xs:unsignedInt" />
						<xs:element name="����������_���" type="xs:unsignedInt" />
						<xs:element name="����������_���������" type="xs:unsignedInt" />
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
('���', '�������� �������', '����', 
'<?xml version="1.0" encoding="windows-1251" ?>
<����������>
<���������� �������������="���������� ������� ����������" �������="����"></����������>
<����><����������_�����>56</����������_�����><����������_���>25</����������_���><����������_���������>78</����������_���������></����>
</����������>');