create table Menu_Items_Admin(
  Item_id int identity(1,1) primary key,
  Name Varchar(30),
  Price decimal(5,2),
  Active varchar(3),
  Date_of_launch date,
  Category varchar(20),
  Free_delivery varchar(3));

  
  insert into Menu_Items_Admin(Name,Price,Active,Date_of_launch,Category,Free_delivery)
  values ('Sandwich',99,'Yes','2017-03-15','Main Course','Yes'),
  ('Burger',129,'Yes','2017-12-27','Main Course','No'),
  ('Pizza',149,'Yes','2017-08-21','Main Course','No'), 
  ('French Fries',57,'No','2017-07-02','Starters','Yes'),
  ('Chocolate Brownie',32,'Yes','2022-11-02','Dessert','Yes');
 
 create table Menu_Items_Customer(
  Item_id int identity(1,1) primary key,
  Name Varchar(30),
  Price decimal(5,2),
  Active varchar(3),
  Date_of_launch date,
  Category varchar(20),
  Free_delivery varchar(3));
  
insert into Menu_Items_Customer(Name,Price,Active,Date_of_launch,Category,Free_delivery) 
select Name,Price,Active,Date_of_launch,Category,Free_delivery from Menu_Items_Admin
where (Date_of_launch<=Getdate() and Active='Yes');
 
 create table user_table
(
  user_id int identity(1,1) primary key,
  no_of_items int,
);
create table cart
(
  user_id int,
  Item_id int,
  constraint fk_user foreign key(user_id) references user_table(user_id),
  constraint fk_Item foreign key(Item_id) references Menu_Items_Customer(Item_id)
 );
 
 Insert into user_table(no_of_items)
values(0),(3);


--To edit and update menu items
create procedure Edit_Menu @Item_id int
as 
begin
select * from Menu_Items_Admin
where Item_id=@Item_id
end
go

create procedure Update_Menu @Item_id int,@Name varchar(30),@Price decimal(5,2),@Active varchar(3),@Date_of_launch date,@Category varchar(20),@Free_delivery varchar(3)
as 
begin
update Menu_Items_Admin
set 
Name=@Name,
Price=@Price,
Active=@Active,
Date_of_launch=@Date_of_launch,
Category=@Category, 
Free_delivery=@Free_delivery
where Item_id=@Item_id
end
go

--To insert into cart
 create procedure insert_cart @user_id int, @Item_id int
 as
 begin 
 insert into cart(user_id,Item_id)
 values(@user_id,@Item_id)                             
 end
go
exec insert_cart 2,1;
exec insert_cart 2,2;
exec insert_cart 2,3;

--To display cart items and total
select b.user_id,a.Name,a.Free_delivery,a.price from Menu_Items_Customer as a inner join cart as b 
on a.Item_id=b.Item_id
where user_id=2;

create procedure view_total
as
begin
select b.user_id, sum(a.Price) from Menu_Items_Customer as a inner join cart as b 
on a.Item_id=b.Item_id
group by b.user_id
end
go
exec view_total;

--to remove item from cart
create procedure remove_item @user_id int,@Item_id int
as
begin
delete from cart
where (user_id=@user_id and Item_id=@Item_id)
end
go




