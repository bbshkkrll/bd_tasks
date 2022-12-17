use master
go

if exists (  
	 select name  
	 from sys.databases  
	 where name = N'KB301_Bobeshko'  
  
)  
drop database [KB301_Bobeshko]  
go  
  
--alter database [KB301_Bobeshko] set single_user with rollback immediate  

  
create database [KB301_Bobeshko]  
go		
  
use [KB301_Bobeshko]  
go 
if exists (  
	select *  
	from sys.schemas  
	where name = N'Books'  
  
)  
drop schema [Books]  
go 
create schema [Books]  
go


create table [Books].Authors (
	pkCodeAuthor integer,
	primary key (pkCodeAuthor),
	nameAuthor varchar(50),
	birthday date,
)
go

create table [Books].PublishingHouse (
	pkCodePublish integer,
	primary key (pkCodePublish),
	publish varchar(30),
	city varchar(20),
)
go

create table [Books].Books (
	pkCodeBook integer,
	primary key (pkCodeBook),
	titleBook varchar(30),
	pages integer,
	fkCodeAuthor integer,
	foreign key (fkCodeAuthor) references [Books].Authors (pkCodeAuthor),
	fkCodePublish integer,
	foreign key (fkCodePublish) references [Books].PublishingHouse (pkCodePublish)
)
go

create table [Books].Deliveries (
	pkCodeDelivery integer,
	primary key (pkCodeDelivery),
	nameDelivery varchar(30),
	nameCompany varchar(45),
	adress varchar(30),
	phone numeric(10),
	INN varchar(12),
)
go


create table [Books].Purchases (
	codePurchase integer,
	orderDate date,
	typePurchase bit,
	cost money,
	amount integer,
	fkCodeDelivery integer,
	foreign key (fkCodeDelivery) references [Books].Deliveries (pkCodeDelivery),
	fkCodeBook integer,
	foreign key (fkCodeBook) references [Books].Books (pkCodeBook),	
)
go