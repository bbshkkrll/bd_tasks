IF EXISTS (
	SELECT name
	FROM sys.databases
	WHERE name = N'KB301_Bobeshko'

)
DROP DATABASE [KB301_Bobeshko]
GO

alter database [KB301_Bobeshko] set single_user with rollback immediate
go

CREATE DATABASE [KB301_Bobeshko]
GO

USE [KB301_Bobeshko]
GO

IF EXISTS(
	SELECT *
	FROM sys.schemas
	WHERE name = N'Task2'

)
DROP SCHEMA [Task2]
GO

CREATE SCHEMA [Task2]
GO



CREATE TABLE [KB301_Bobeshko].Task2.Card(
	currencyName VARCHAR(3) NOT NULL,
	currencyBalance MONEY NOT NULL,
	PRIMARY KEY(currencyName)

)
GO


DROP TABLE [KB301_Bobeshko].Task2.Rates
GO

CREATE TABLE [KB301_Bobeshko].Task2.Rates(
	currencyNameFrom VARCHAR(3),
	currencyNameTo VARCHAR(3),
	rate DECIMAL(10,3)
	/*
	FOREIGN KEY (currencyNameFrom)  REFERENCES Task2.Card (currencyName),
	FOREIGN KEY (currencyNameTo)  REFERENCES Task2.Card (currencyName)
	*/
)

