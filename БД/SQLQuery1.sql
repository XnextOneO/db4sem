select �������.ID_�������, ������.�����_������
		from ������ Inner join �������
		on ������.�����_������=�������.ID_�������
-------------------------------
select �������.ID_�������, ������.�����_������
		from ������ Inner join �������
		on ������.�����_������=�������.ID_������� and  ������.�����_������ Like '%222%'
-------------------------------------------------------

select t2.ID_�������, t1.�����_������ 
		from ������ as t1, ������� as t2
		where t1.�����_������=t2.�����_������

select t2.ID_�������, t1.�����_������ 
		from ������ as t1, ������� as t2
		where t1.�����_������=t2.�����_������ and t1.�����_������ like '%222%'
-------------------------------------------------

select �������.ID_�������, ������.�����_������
		from ������ cross join �������
		where ������.�����_������ = �������.ID_�������
-----------------------------------------------------
