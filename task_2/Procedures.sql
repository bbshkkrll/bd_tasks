USE KB301_Bobeshko
GO

--Внести указанную сумму в указанной валюте на счет, если счета нет - создать.
CREATE PROCEDURE Deposit 
	@currencyName VARCHAR(3),
	@count MONEY 
	AS
	BEGIN
		IF EXISTS(SELECT * FROM Task2.Card WHERE currencyName = @currencyName)
			BEGIN 
				UPDATE Task2.Card SET currencyBalance = currencyBalance + @count WHERE currencyName = @currencyName;
				PRINT('Счет успешно пополнен.')
			END
		ELSE 
			BEGIN
				INSERT INTO Task2.Card (currencyName, currencyBalance) 
					VALUES (@currencyName, @count)
				PRINT('Счет успешно создан и пополнен.')
			END
	END

--Показ баланса всех счетов, где остаток > 0
CREATE PROCEDURE CheckCardBalance 
	AS 
	BEGIN
		SELECT currencyName as Валюта, FORMAT(currencyBalance, 'F3')  as Баланс
			FROM Task2.Card 
			WHERE currencyBalance >= 0 
			GROUP BY currencyName, currencyBalance
	END


--Снять указанное количество средств с указанного счета 
CREATE PROCEDURE Withdraw
	@currencyName VARCHAR(3),
	@count MONEY
	AS
	BEGIN 
		IF EXISTS(SELECT * FROM Task2.Card WHERE currencyName = @currencyName and currencyBalance >= @count)
			BEGIN 
				UPDATE Task2.Card SET currencyBalance = currencyBalance - @count WHERE currencyName = @currencyName
				PRINT('Транзакция проведена успешно.')
			END
		ELSE
			BEGIN
				PRINT('Недостаточно средств для проведения транзакции.')
			END
	END

DROP PROCEDURE Withdraw


--Продать указанное количество средств за указаннуб валюту
CREATE PROCEDURE Change
	@currencyNameFrom	VARCHAR(3),
	@count MONEY,
	@currencyNameTo VARCHAR(3)
	AS 
	BEGIN
		IF EXISTS(SELECT * FROM Task2.Card WHERE currencyName = @currencyNameFrom and currencyBalance >= @count)
			BEGIN 
				EXEC Withdraw @currencyNameFrom, @count
				DECLARE @rate DECIMAL(10,3)
				SELECT @rate = rate  FROM Task2.Rates
					WHERE currencyNameFrom = @currencyNameFrom and currencyNameTo = @currencyNameTo
				DECLARE @balance MONEY = @rate * @count;
				EXEC Deposit @currencyNameTo, @balance
			END
		ELSE 
			BEGIN
				PRINT('Недостаточно средств для проведения транзакции.')
			END
	END

DROP PROCEDURE Change	


--Продать все средства за указанную валюту
CREATE PROCEDURE ChangeAll 
	@currencyNameTo VARCHAR(3)
	AS
	BEGIN
		IF EXISTS(SELECT * FROM Task2.Card WHERE currencyName NOT LIKE @currencyNameTo)
			BEGIN 
				DECLARE currencyes CURSOR FOR SELECT * FROM Task2.Card WHERE currencyName NOT LIKE @currencyNameTo
				OPEN currencyes 
				DECLARE 
					@currencyNameFromCur VARCHAR(3),
					@currencyBalanceCur MONEY
				FETCH NEXT FROM currencyes INTO @currencyNameFromCur, @currencyBalanceCur
				WHILE @@FETCH_STATUS = 0
					BEGIN 
						EXEC Change @currencyNameFromCur, @currencyBalanceCur, @currencyNameTo
						FETCH NEXT FROM currencyes INTO @currencyNameFromCur, @currencyBalanceCur
					END
				CLOSE currencyes
			END
		ELSE 
			BEGIN
				PRINT('Что-то пошло не так.') 
			END
	END 