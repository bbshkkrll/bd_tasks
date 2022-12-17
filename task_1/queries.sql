USE [KB301_Bobeshko]
GO
 

SELECT * FROM Task1.Storage

-- максимальная цена определенного товара по имени товара.

SELECT product_name AS "Имя товара", MIN(cost) AS "Минимальная цена товара"
  FROM Task1.Storage INNER JOIN 
				Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
  WHERE Task1.Storage.fk_product_id = 1
  GROUP BY product_name;

--минимальная цена определенного товара по имени товара.
SELECT product_name AS "Имя товара", FORMAT(Min(cost), 'C') AS "Минимальная цена товара"
	FROM Task1.Storage INNER JOIN 
				Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE product_name = 'Пельмени'
	GROUP BY product_name;


-- максимальная цена определенного товара по имени товара.

SELECT product_name AS "Имя товара", FORMAT(Max(cost), 'C') AS "Максимальная цена товара"
	FROM Task1.Storage INNER JOIN 
			Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE product_name = 'Пельмени'
	GROUP BY product_name;


--средняя цена определенного товара по Id товара.

SELECT product_name AS "Имя товара", FORMAT(Avg(cost), 'C') AS "Минимальная цена товара"
  FROM Task1.Storage INNER JOIN 
				Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
  WHERE Task1.Storage.fk_product_id = 1
  GROUP BY product_name;

--средняя цена определенного товара по имени товара.
SELECT product_name AS "Имя товара", FORMAT(Avg(cost), 'C') AS "Минимальная цена товара"
	FROM Task1.Storage INNER JOIN 
				Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE product_name = 'Пельмени'
	GROUP BY product_name



--количество товара во всех магазинах по id товара

SELECT product_name AS "Имя товара", 			
		SUM(case when statusOfdate = 1 then countOfProduct else -countOfProduct end) AS "Количество товаров во всех магазинах"
	FROM Task1.Storage INNER JOIN 

			Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE Task1.Storage.fk_product_id = 3
	GROUP BY product_name;


--количество товара в каждом магазине по дате

SELECT product_name AS "Имя продукта",  FORMAT(shipment_date, 'D', 'Ru-ru') AS "Дата и время",  market_name AS "Имя магазина", 
		SUM(case when statusOfdate = 1 then countOfProduct else -countOfProduct end)  AS "Количество товара"
FROM Task1.Storage INNER JOIN 
			Task1.Market ON Task1.Storage.fk_market_id = Task1.Market.pk_id INNER JOIN
			Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE Task1.Storage.fk_product_id = 11 AND shipment_date BETWEEN '2000-11-11 00:00:00.00' AND '2020-12-12 23:59:59.999'
	GROUP BY shipment_date, market_name, product_name;


-- минимальная цена товара по Id за определенный срок
SELECT product_name AS "Имя продукта", FORMAT(shipment_date, 'D', 'Ru-ru') AS "Дата и время", market_name AS "Имя магазина", 
	FORMAT(AVG(cost), 'C') AS "Цена товра"
 	FROM Task1.Storage INNER JOIN 
		Task1.Market ON Task1.Storage.fk_market_id = Task1.Market.pk_id INNER JOIN
		Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE Task1.Storage.fk_product_id = 11 AND shipment_date BETWEEN '2000-11-11 00:00:00.00' AND '2020-12-12 23:59:59.999'
	GROUP BY shipment_date, market_name, product_name;


--Количество товара в конкретный день


SELECT product_name AS "Имя продукта",  FORMAT(shipment_date, 'D', 'Ru-ru') AS "Дата и время",  market_name AS "Имя магазина", 
		SUM(case when statusOfdate = 1 then countOfProduct else -countOfProduct end)  AS "Количество товара"
FROM Task1.Storage INNER JOIN 
			Task1.Market ON Task1.Storage.fk_market_id = Task1.Market.pk_id INNER JOIN
			Task1.Products ON Task1.Storage.fk_product_id = Task1.Products.pk_id
	WHERE Task1.Storage.fk_product_id = 11 AND FORMAT(shipment_date, 'D', 'Ru-ru') <= '20 апреля 2017 г.'
	GROUP BY shipment_date, market_name, product_name;