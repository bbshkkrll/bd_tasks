USE [KB301_Bobeshko]
GO




CREATE PROCEDURE GetRatesTable 
	AS 
	BEGIN 
		DECLARE currencyes CURSOR FOR SELECT DISTINCT currencyNameFrom FROM Task2.Rates;
		OPEN currencyes;
		DECLARE 
			@currentCurrency MONEY;
		FETCH NEXT FROM currencyes INTO @currentCurrency;
		WHILE @@FETCH_STATUS = 0
			BEGIN 
				

