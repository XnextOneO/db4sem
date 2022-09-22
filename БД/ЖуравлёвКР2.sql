
---вариант 3
use K_MyBase
---1
go
Create procedure AddProduct(@MFR_ID nvarchar(50),@PRODUCT_ID nvarchar(20),@DESCRIPTION nvarchar(50), @price float, @QTY_ON_HAND int) 
   AS begin
    insert into Products(MFR_ID,PRODUCT_ID, DESCRIPTION, Price, QTY_ON_HAND) values(@MFR_ID, @PRODUCT_ID ,@DESCRIPTION, @price, @QTY_ON_HAND );
end
---2
go
Create function GetOrdersCount(@MFR nvarchar(50)) 
   
   RETURNS int AS begin
  declare @peremennaya int = (select count(*) from ORDERS where MFR like @MFR);	
	 if(@@ERROR > 0) return -1;
	return @peremennaya;
end
--3
go
 create proc GetOrdersByQty(@QTY_ORDERED int) as begin
    select* from Orders where QTY > @QTY_ORDERED order by AMOUNT desc;
end

--4
go
create function GetSubordinatesCount(@NAME nvarchar(50)) 
   RETURNS int AS begin
   declare @abc int = (select count(*) from SALESREPS as s join SALESREPS ON SALESREPS.MANAGER = s.EMPL_NUM where SALESREPS.NAME = @NAME);
   if(@@ERROR > 0) return -1;
	return @abc;
end
    
	DROP function dbo.GetSubordinatesCount