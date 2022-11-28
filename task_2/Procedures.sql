USE KB301_Bobeshko
GO

--������ ��������� ����� � ��������� ������ �� ����, ���� ����� ��� - �������.
CREATE PROCEDURE Deposit 
	@currencyName VARCHAR(3),
	@count MONEY 
	AS
	BEGIN
		IF EXISTS(SELECT * FROM Task2.Card WHERE currencyName = @currencyName)
			BEGIN 
				UPDATE Task2.Card SET currencyBalance = currencyBalance + @count WHERE currencyName = @currencyName;
				PRINT('���� ������� ��������.')
			END
		ELSE 
			BEGIN
				INSERT INTO Task2.Card (currencyName, currencyBalance) 
					VALUES (@currencyName, @count)
				PRINT('���� ������� ������ � ��������.')
			END
	END

--����� ������� ���� ������, ��� ������� > 0
CREATE PROCEDURE CheckCardBalance 
	AS 
	BEGIN
		SELECT currencyName as ������, FORMAT(currencyBalance, 'F3')  as ������
			FROM Task2.Card 
			WHERE currencyBalance >= 0 
			GROUP BY currencyName, currencyBalance
	END


--����� ��������� ���������� ������� � ���������� ����� 
CREATE PROCEDURE Withdraw
	@currencyName VARCHAR(3),
	@count MONEY
	AS
	BEGIN 
		IF EXISTS(SELECT * FROM Task2.Card WHERE currencyName = @currencyName and currencyBalance >= @count)
			BEGIN 
				UPDATE Task2.Card SET currencyBalance = currencyBalance - @count WHERE currencyName = @currencyName
				PRINT('���������� ��������� �������.')
			END
		ELSE
			BEGIN
				PRINT('������������ ������� ��� ���������� ����������.')
			END
	END

DROP PROCEDURE Withdraw


--������� ��������� ���������� ������� �� ��������� ������
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
				PRINT('������������ ������� ��� ���������� ����������.')
			END
	END

DROP PROCEDURE Change	


--������� ��� �������� �� ��������� ������
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
				PRINT('���-�� ����� �� ���.') 
			END
	END 