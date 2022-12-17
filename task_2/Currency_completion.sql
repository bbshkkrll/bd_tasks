USE KB301_Bobeshko
GO


--Пополнить рублёвый счет на 500 руб.
EXEC CheckCardBalance

EXEC Deposit 'RUB', 55000

EXEC CheckCardBalance

EXEC Deposit 'EUR', 0.1

EXEC Withdraw 'EUR', 100

EXEC Change 'RUB', 1000, 'EUR'

EXEC ChangeAll 'RUB'

EXEC Deposit 'RUB', 55000
EXEC Deposit 'USD', 1500
EXEC Deposit 'JPY', 75000
EXEC Deposit 'EUR', 500

EXEC CheckCardBalance

EXEC Change 'RUB', 1000, 'EUR'

EXEC CheckCardBalance

EXEC ChangeAll 'USD'

EXEC Change 'USD', 100, 'RUB'


