---1
select COUNT(ORDER_NUM) [Количество заказов], AVG(AMOUNT)
[Средняя цена заказов:]
from ORDERS
SELECT CUST [Покупатель],
 COUNT(ORDER_NUM) [Количество заказов],
 AVG(AMOUNT) [Средняя цена заказов:]
from ORDERS
group by CUST
ORDER BY AVG(AMOUNT)
---2
select NAME [Имя сотрудника], AMOUNT [ЦЕНА]
from SALESREPS join ORDERS 
on EMPL_NUM = REP
where AMOUNT >= 15000
order by AMOUNT desc
---3
select MFR_ID [Производитель], SUM(QTY_ON_HAND) [Количество товаров], AVG(PRICE) [Средняя цена]
from PRODUCTS
group by MFR_ID
---4
select COMPANY [ПОКУПАТЕЛЬ] , CUST [НОМЕР ЗАКАЗА]
from CUSTOMERS left outer join ORDERS 
ON CUSTOMERS.CUST_NUM = ORDERS.CUSTWHERE CUST is nullgroup by CUST, COMPANY---5---6select NAME [COTRUDNIK], AMOUNT [ЦЕНА]FROM SALESREPS join ORDERSON SALESREPS.EMPL_NUM = ORDERS.REPwhere AMOUNT >= 2000order by AMOUNT desc---7select NAME [COTRUDNIK], ORDER_NUM [ЗАКАЗ]FROM SALESREPS left outer join ORDERSON SALESREPS.EMPL_NUM = ORDERS.REPwhere ORDER_NUM is  nullgroup by NAME, ORDER_NUM---8select NAME, count (ORDER_NUM) [Номер заказа], avg (AMOUNT) [средняя цена]from SALESREPS join ORDERSon SALESREPS.EMPL_NUM = ORDERS.REPgroup by NAMEorder by avg (AMOUNT)---9select top(3) PRODUCT_ID, QTYfrom PRODUCTS join ORDERSon MFR_ID = MFR order by QTY ---10select top(3) PRODUCT [Код продукта], Count(ORDER_NUM) [Частота заказа] 
from ORDERS
group by PRODUCT
order by [Частота заказа] desc---11select NAME [ИМЯ СОТРУДНИКА] , COUNT (PRODUCT) [ПРОДУКТЫ], AVG(AMOUNT) [AVG PRICE]from SALESREPS join ORDERSon SALESREPS.EMPL_NUM = ORDERS.REPgroup by NAMEorder by  AVG(AMOUNT) desc---12select top(3) COMPANY [КОМПАНИЯ] ,count(PRODUCT) [PRODUCTI]from CUSTOMERS join ORDERSon CUSTOMERS.CUST_NUM = ORDERS.CUSTwhere CREDIT_LIMIT < 30000 group by COMPANYorder by count(PRODUCT) desc---13select OFFICE from OFFICESwhere OFFICE not in (select OFFICE from OFFICES join SALESREPS on OFFICE = REP_OFFICE join ORDERS on EMPL_NUM = REP where ORDER_DATE between '01.01.2007' and '01.01.2008')--14 ДУБЛЬ ДВА БОЛЬШОЙ ДОКУМЕНТ  1select NAME ,avg(AMOUNT/QTY)[Номер заказа], avg (AMOUNT) [СР ЦЕНА заказа] from SALESREPS left outer join ORDERS on EMPL_NUM = REPgroup by NAMEorder by avg (AMOUNT) desc----2select NAME , AMOUNTfrom SALESREPS join orderson EMPL_NUM = REPwhere AMOUNT > 2000order by NAME desc---3select NAME , avg(AMOUNT)[ср цена]from SALESREPS left outer join ORDERSon EMPL_NUM = REPgroup by NAME---4select NAME , ORDER_NUMfrom SALESREPS left outer join ORDERSon EMPL_NUM = REPwhere ORDER_NUM is null ---5select ORDER_NUM, NAME, REGION from ORDERS inner join SALESREPS on EMPL_NUM = REP inner join OFFICES on EMPL_NUM = MGRwhere REGION like 'east%'-----select OFFICE from OFFICES where OFFICE not in(select OFFICE FROM OFFICES join SALESREPS on OFFICE = REP_OFFICE join ORDERSon EMPL_NUM = REP where ORDER_DATE between '01.01.2007' and '01.01.2008')----select top(3) COMPANY, CREDIT_LIMIT from CUSTOMERSwhere CREDIT_LIMIT < 30000group by COMPANY, CREDIT_LIMITORDER BY CREDIT_LIMIT desc------select top(3) PRODUCT_ID, QTYfrom PRODUCTS join orders on MFR_ID = MFR and PRODUCT_ID = PRODUCTgroup by PRODUCT_ID, QTYorder by QTY desc---select COMPANY, count(CUST), avg(AMOUNT)from CUSTOMERS left outer join ORDERSon CUST_NUM = CUSTgroup by COMPANYorder by avg(AMOUNT) descselect NAME ,AMOUNT from SALESREPS join ORDERS on EMPL_NUM = REPgroup by NAME, AMOUNTorder by AMOUNT descselect PRODUCT_ID ,avg(AMOUNT)from PRODUCTS join ORDERSon MFR_ID = MFR and PRODUCT_ID = PRODUCTGROUP BY PRODUCT_IDorder by avg(AMOUNT) descselect COMPANY, ORDER_NUMfrom CUSTOMERS left outer JOIN ORDERSON CUST_NUM = CUSTwhere ORDER_NUM is nullselect ORDER_NUM, NAME, REGIONfrom ORDERS join SALESREPS on EMPL_NUM = REP join OFFICES on EMPL_NUM = MGR where REGION like 'east%'group by ORDER_NUM, NAME, REGIONorder by REGION descselect avg(AMOUNT), NAME from ORDERS join SALESREPSon EMPL_NUM = REP group by NAMEorder by avg(AMOUNT) descselect OFFICE FROM OFFICES where OFFICE NOT IN (select OFFICE FROM OFFICES join SALESREPS on OFFICE = REP_OFFICE join ORDERS on EMPL_NUM = REP where ORDER_DATE between '01.01.2007' and '01.01.2008')-----------select NAME, ORDER_NUM from SALESREPS left outer join ORDERS on EMPL_NUM = REPwhere ORDER_NUM is nullgroup by NAME, ORDER_NUMorder by ORDER_NUM descselect ORDER_NUM, MANAGER, REGION from ORDERS join SALESREPS on EMPL_NUM = REP join OFFICES on EMPL_NUM = MGR where REGION like 'WEst%'group by ORDER_NUM, MANAGER, REGION order by ORDER_NUMselect COUNT(QTY),AVG(AMOUNT), COMPANY from ORDERS right outer JoiN CUSTOMERS on CUST_NUM = CUSTgroup by COMPANYorder by AVG(AMOUNT) descselect count(ORDER_NUM), avg(AMOUNT), CUSTFROM ORDERSgroup by CUSTorder by  avg(AMOUNT)