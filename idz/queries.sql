use [KB301_Bobeshko].Books
go

--1
--������� �� ������� Books ���� ����, �������� � ���������� ������� (���� Code_book, Title_book � Pages), 
--������������� ��������� �� ��������� ���� (���� Title_book �� �����������) � �� ���� Pages (�� ��������).
select pkCodeBook as '���', titleBook as '��������', pages as '����� �������' 
	from Books.Books order by titleBook desc, pages asc

--2 
--������� �� ������� Books �������� ���� � ���������� ������� (���� Title_book � Pages), 
--� �� ������� Deliveries ������� ��� ���������������� ���������� ����� (���� Name_delivery).
select titleBook as '��������', pages as '����� �������' from Books.Purchases

--3 
--������� ������ �������� ����������� (���� Publish) �� ������� Publishing_house, 
--������� �� ��������� � ������ �������' (������� �� ���� City).
select publish as '������������' from Books.PublishingHouse where city != '������'


--4
--������� ������ �������, ����, ������� ������� (���� Name_author) �� ������� Authors, 
--� ������� ������� ���������� �� ���� �� ���� ��������� ��' - ��' (������� �� ���� Name_author).
select nameAuthor as '�����' from Books.Authors where nameAuthor not like '[�-�]%'

--5
--������� �������� ����������� (���� Publish) �� ������� Publishing_house, 
--������� �������� � �������� ��������� �����'.
select publish as '������������' from Books.PublishingHouse where publish like '%����%'

--6
--������� ������ �������� ��������-����������� (���� Name_company) � �������� ���� (���� Title_book), 
--������� ��� ��������� � ������ � 01.01.2002 �� 31.12.2003 (������� �� ���� Date_order).
select Books.Books.titleBook as '�����', Books.Deliveries.nameCompany as '��������' from Books.Purchases 
	join Books.Books on Books.pkCodeBook =  Purchases.fkCodeBook 
	join Books.Deliveries on Deliveries.pkCodeDelivery = Purchases.fkCodeDelivery
	where orderDate between '01.01.2002' and '31.12.2003'


--7
--������� ��������� ����� �������� �������� ������ ����� (������������ ���� Cost � Pages) 
--� �������� ��������������� ���� (���� Title_book).
select titleBook as '�����', Purchases.cost / pages as '��������� ��������' from Books.Books
	join Books.Purchases on Purchases.fkCodeBook = Books.pkCodeBook

--8
--������� ��� �������� � �������� (��� ���� ������� Purchases),
--� ����� �������� ����� (���� Title_book) � ����������� ����� ���������� (������������ ���� Cost � Amount).
select top 1 codePurchase as '��� ��������', 
			 FORMAT(orderDate, 'D', 'Ru-ru') as '���� ��������',
			 typePurchase as '��� ��������',
			 cost as '����',
			 amount as '����������' ,
			 fkCodeDelivery as '��� ����������', 
			 fkCodeBook as '��� �����',
			 Books.titleBook as '�������� �����'
	from Books.Purchases 
	join Books.Books on Books.pkCodeBook = fkCodeBook
	order by cost * amount

--9
--������� ������ ������ (��� ���� �� ������� Purchases) 
--�� ��������� ����� (������� � �������������� ���� Date_order).
select codePurchase as '��� ��������', 
			 FORMAT(orderDate, 'D', 'Ru-ru') as '���� ��������',
			 typePurchase as '��� ��������',
			 cost as '����',
			 amount as '����������' ,
			 fkCodeDelivery as '��� ����������', 
			 fkCodeBook as '��� �����',
			 Books.titleBook as '�������� �����'
		from Books.Purchases 
		join Books.Books on Books.pkCodeBook = fkCodeBook
		where datediff(mm, orderDate, getdate()) <= 1

--10 
--������� ������ ����������� (���� Name_company), 
--����� ������� ���� ���������� �� ���� 150 ���. (���� Cost).
select PublishingHouse.publish from Books.Purchases 
	join Books.Books on Books.pkCodeBook = Purchases.fkCodeBook
	join Books.PublishingHouse on PublishingHouse.pkCodePublish = Books.fkCodePublish
	where cost = 150

--11 
--������� ������ ������� (���� Name_author), 
--������� ������� ������ �������� �������� ���� ������� � ������� (������� �� ����Birthday).
select nameAuthor from Books.Authors 
	where datediff(yy, birthday, getdate()) < (select avg(datediff(yy, birthday, getdate())) from Books.Authors)

--12
--�������� � ������� Books ���������� ���� Pages �� 300, 
--���� ��� ������ (���� Code_author) =56 � �������� ����� (���� Title_book) ='�������'.
update Books.Books set pages = 300 
	where Books.fkCodeAuthor = 56 and Books.titleBook = '�������'

--13
--�������� � ������� Publish_house ����� ������, ������ ������ ��������� ���� ��������� ��� (���� Code_publish), �������������
--����������� �� ������� �� ������������� ���� � �������, ������
--�������� ������ - �������' (���� City), ������ ������������ - ������' (���� Publish).

insert Books.PublishingHouse (pkCodePublish, publish, city) values
	((select max(pkCodePublish) + 1 from  Books.PublishingHouse), '�����', '������')

--��������
select * from Books.PublishingHouse

--14
--������� ������� ��� ������ INSERT � UPDATE ������� Books, 
--����������� ����������� ��������� ��� ������������, � �������� �� ��������� ���� �����.
create trigger Books_Insert
	on Books.Books
	instead of insert, update
	as 
	declare @city int
	select @city = PublishingHouse.city from PublishingHouse where pkCodePublish = (select fkCodePublish from inserted)
	if (@city is null)
	begin 
		THROW 51000,'������������ ��������', 1;
	end
	else 
	begin 
		if  not exists(select pkCodeBook from Books.Books where pkCodeBook = (select pkCodeBook from inserted))
		begin
			insert into Books.Books (pkCodeBook, titleBook, pages, fkCodeAuthor, fkCodePublish) 
			select pkCodeBook, titleBook, pages, fkCodeAuthor, fkCodePublish from inserted
		end
		else 
		begin
			update Books.Books set pkCodeBook = inserted.pkCodeBook, 
							   titleBook = inserted.titleBook, 
							   pages = inserted.pages,
							   fkCodeAuthor = inserted.fkCodeAuthor, 
							   fkCodePublish = inserted.fkCodePublish
							   from Books.Books
							   join inserted on inserted.pkCodeBook = Books.pkCodeBook
		end
	end

		
insert into Books.PublishingHouse values
	(20, 'publish20', null)

select * from Books.PublishingHouse

insert into Books.Books values 
	(99, 'bookname99', 999, 11, 20)


update Books.PublishingHouse set city = null where pkCodePublish = 1
update Books.Books set pages = 999 where fkCodePublish = 1 and pkCodeBook = 2

--15
--������� ���������, ������� ��� ���������� ������������ ������� ���������� � ��������: ����, �����, ���������, ����� ���������, 
--��������������� �� ����, �� ������� ������ �������� ����, �������� ����� ����.
create procedure PublishEarnings
@publish varchar(30)
as
	begin
		select  orderDate as '����',
				B.titleBook as '�����',
				nameDelivery as '���������',
				P.Cost * P.Amount as 'C��������'
		into Report
		from Books.Purchases as P
			join Books.Books as B on P.fkCodeBook = B.pkCodeBook
			join Books.Deliveries as D on P.fkCodeDelivery = D.pkCodeDelivery
			join Books.PublishingHouse as PH on B.fkCodePublish = PH.pkCodePublish
		where PH.Publish =  @publish
		group by orderDate, Amount, cost, nameDelivery, titleBook
		declare @current_month smallint = 1
		declare @current_money int = 0
		declare @all_money int = 0
		while @current_month <= 12
		begin
			select * into MonthReport from Report
				where month([Report].����) = @current_month 
			if (exists(select * from MonthReport)) --�������� ������ �� ������, �� ������� ���� ������
			begin
				set @current_money = (select sum([MonthReport].[C��������]) 
										from MonthReport)
				set @all_money = @all_money + @current_money
				select FORMAT([����], 'D', 'Ru-ru') as '����',
					   [�����],
					   [���������],
					   [C��������] from MonthReport
			end
			drop table MonthReport
			set @current_month = @current_month + 1
		end
		select FORMAT([����], 'D', 'Ru-ru') as '����',
					   [�����],
					   [���������],
					   [C��������]  from Report
		drop table Report
	end
go
--drop procedure PublishEarnings
exec PublishEarnings @publish = '�����-����'
