USE [KB301_Bobeshko]
GO
 

SELECT * FROM Task1.Storage

-- ������������ ���� ������������� ������ �� ����� ������.

SELECT product_name AS "��� ������", MIN(cost) AS "����������� ���� ������"
  FROM Task1.Storage INNER JOIN 
				Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
  WHERE Task1.Storage.fk_product_id = 1
  GROUP BY product_name;

--����������� ���� ������������� ������ �� ����� ������.
SELECT product_name AS "��� ������", FORMAT(Min(cost), 'C') AS "����������� ���� ������"
	FROM Task1.Storage INNER JOIN 
				Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE product_name = '��������'
	GROUP BY product_name;


-- ������������ ���� ������������� ������ �� ����� ������.

SELECT product_name AS "��� ������", FORMAT(Max(cost), 'C') AS "������������ ���� ������"
	FROM Task1.Storage INNER JOIN 
			Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE product_name = '��������'
	GROUP BY product_name;


--������� ���� ������������� ������ �� Id ������.

SELECT product_name AS "��� ������", FORMAT(Avg(cost), 'C') AS "����������� ���� ������"
  FROM Task1.Storage INNER JOIN 
				Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
  WHERE Task1.Storage.fk_product_id = 1
  GROUP BY product_name;

--������� ���� ������������� ������ �� ����� ������.
SELECT product_name AS "��� ������", FORMAT(Avg(cost), 'C') AS "����������� ���� ������"
	FROM Task1.Storage INNER JOIN 
				Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE product_name = '��������'
	GROUP BY product_name



--���������� ������ �� ���� ��������� �� id ������

SELECT product_name AS "��� ������", 			
		SUM(case when statusOfdate = 1 then countOfProduct else -countOfProduct end) AS "���������� ������� �� ���� ���������"
	FROM Task1.Storage INNER JOIN 

			Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE Task1.Storage.fk_product_id = 3
	GROUP BY product_name;


--���������� ������ � ������ �������� �� ����

SELECT product_name AS "��� ��������",  FORMAT(shipment_date, 'D', 'Ru-ru') AS "���� � �����",  market_name AS "��� ��������", 
		SUM(case when statusOfdate = 1 then countOfProduct else -countOfProduct end)  AS "���������� ������"
FROM Task1.Storage INNER JOIN 
			Task1.Market ON Task1.Storage.fk_market_id = Task1.Market.pk_id INNER JOIN
			Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE Task1.Storage.fk_product_id = 11 AND shipment_date BETWEEN '2000-11-11 00:00:00.00' AND '2020-12-12 23:59:59.999'
	GROUP BY shipment_date, market_name, product_name;


-- ����������� ���� ������ �� Id �� ������������ ����
SELECT product_name AS "��� ��������", FORMAT(shipment_date, 'D', 'Ru-ru') AS "���� � �����", market_name AS "��� ��������", 
	FORMAT(AVG(cost), 'C') AS "���� �����"
 	FROM Task1.Storage INNER JOIN 
		Task1.Market ON Task1.Storage.fk_market_id = Task1.Market.pk_id INNER JOIN
		Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE Task1.Storage.fk_product_id = 11 AND shipment_date BETWEEN '2000-11-11 00:00:00.00' AND '2020-12-12 23:59:59.999'
	GROUP BY shipment_date, market_name, product_name;


--���������� ������ � ���������� ����


SELECT product_name AS "��� ��������",  FORMAT(shipment_date, 'D', 'Ru-ru') AS "���� � �����",  market_name AS "��� ��������", 
		SUM(case when statusOfdate = 1 then countOfProduct else -countOfProduct end)  AS "���������� ������"
FROM Task1.Storage INNER JOIN 
			Task1.Market ON Task1.Storage.fk_market_id = Task1.Market.pk_id INNER JOIN
			Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE Task1.Storage.fk_product_id = 11 AND FORMAT(shipment_date, 'D', 'Ru-ru') <= '20 ������ 2017 �.'
	GROUP BY shipment_date, market_name, product_name;