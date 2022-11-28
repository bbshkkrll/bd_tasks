USE master
GO

IF EXISTS (  
	 SELECT name  
	 FROM sys.databases  
	 WHERE name = N'KB301_Bobeshko'  
  
)  
DROP DATABASE [KB301_Bobeshko]  
GO  
  
alter database [KB301_Bobeshko] set single_user with rollback immediate  

  
CREATE DATABASE [KB301_Bobeshko]  
GO  
  
USE [KB301_Bobeshko]  
GO  
  
IF EXISTS(  
	SELECT *  
	FROM sys.schemas  
	WHERE name = N'Task3'  
  
)  
DROP SCHEMA [Task3]  
GO  
CREATE SCHEMA [Task3]  
GO  
  
  
 
  
CREATE TABLE [KB301_Bobeshko].Task3.Regions(  
   regionName VARCHAR(35) NOT NULL,  
   --Проверка кода региона на корректность 
   regionCode VARCHAR(3) NOT NULL  
		CHECK((regionCode LIKE '[0-9][0-9]' OR 
			regionCode LIKE '[1][0-9][0-9]' OR
			regionCode LIKE '[2][0-9][0-9]' OR
			regionCode LIKE '[7][0-9][0-9]') AND 
			regionCode NOT LIKE '[0][0]')

   PRIMARY KEY(regionCode)  
)  
  
CREATE TABLE [KB301_Bobeshko].Task3.RegionCodes(  
    regionCode VARCHAR(3) NOT NULL,  
    --Проверка кода региона на корректность 
    otherRegionCode VARCHAR(3) NOT NULL  
		CHECK((otherRegionCode LIKE '[0-9][0-9]' OR
		otherRegionCode LIKE '[1][0-9][0-9]' OR
		otherRegionCode LIKE '[2][0-9][0-9]' OR
		otherRegionCode LIKE '[7][0-9][0-9]') AND 
		otherRegionCode NOT LIKE '[0][0]')
    FOREIGN KEY (regionCode) REFERENCES [KB301_Bobeshko].Task3.Regions (regionCode), 
    PRIMARY KEY (otherRegionCode), 
) 
 
 
CREATE TABLE [KB301_Bobeshko].Task3.CarNumber( 

	carNumber VARCHAR(6) NOT NULL check (
    carNumber LIKE '_[0-9][0-9][0-9]__' AND
    carNumber NOT LIKE '_[0][0][0]__' AND
    carNumber LIKE '[АВЕКМНОРСТУХ]___[АВЕКМНОРСТУХ][АВЕКМНОРСТУХ]'
  ),  
	regionCode VARCHAR(3) NOT NULL,
	PRIMARY KEY (carNumber, regionCode),
) 
GO

CREATE TABLE [KB301_Bobeshko].Task3.PolicePost( 
	timeOfEvent TIME(0),
	postId INT NOT NULL, 
	carStatus VARCHAR(3) NOT NULL, 
	carNumber VARCHAR(6) NOT NULL,
	carRegionCode VARCHAR (3) NOT NULL,
	PRIMARY KEY (postId, timeOfEvent),
) 
GO

ALTER TABLE [KB301_Bobeshko].Task3.PolicePost ADD
	CONSTRAINT fkCarNumber FOREIGN KEY (carNumber, carRegionCode)
	REFERENCES [KB301_Bobeshko].Task3.CarNumber (carNumber, regionCode)
	ON UPDATE CASCADE
GO



 
CREATE TRIGGER PolicePost_Insert 
	ON [KB301_Bobeshko].Task3.PolicePost
	INSTEAD OF INSERT
	AS 
		DECLARE @newTimeEvent TIME;
		SELECT @newTimeEvent = timeOfEvent 
			FROM inserted; 
		DECLARE @newCarStatus VARCHAR(3);
		SELECT @newCarStatus = carStatus FROM inserted;

		IF EXISTS(SELECT carStatus, timeOfEvent 
			FROM [KB301_Bobeshko].Task3.PolicePost
				WHERE carNumber = (SELECT carNumber FROM inserted)
				AND carRegionCode = (SELECT carRegionCode FROM inserted)) 
		BEGIN
			DECLARE @oldTimeEvent TIME;
			SELECT TOP 1 @oldTimeEvent = timeOfEvent 
				FROM [KB301_Bobeshko].Task3.PolicePost 
					WHERE carNumber = (SELECT carNumber FROM inserted) 
					ORDER BY timeOfEvent DESC 

			DECLARE @oldCarStatus VARCHAR(3);
			SELECT TOP 1 @oldCarStatus = carStatus FROM [KB301_Bobeshko].Task3.PolicePost 
					WHERE  carNumber = (SELECT carNumber FROM inserted) 
					AND carRegionCode = (SELECT carRegionCode FROM inserted) 
					AND @oldTimeEvent = timeOfEvent
					ORDER BY timeOfEvent DESC 

			IF (DATEDIFF(mi, @oldTimeEvent, @newTimeEvent) < 5) OR (@oldCarStatus LIKE @newCarStatus)
			BEGIN 
				PRINT(DATEDIFF(mi, @newTimeEvent, @oldTimeEvent));
				RAISERROR('Время меьше 5 минут или направление совпадает', 1, 0);
			END
			ELSE
			BEGIN
				INSERT INTO [KB301_Bobeshko].Task3.PolicePost
				 ( timeOfEvent, postId, carStatus, carNumber, carRegionCode) 
						SELECT timeOfEvent, postId,  carStatus, carNumber, carRegionCode 
						FROM inserted
			END
		END
		ELSE 
		BEGIN 
			IF NOT EXISTS(SELECT carNumber FROM [KB301_Bobeshko].Task3.CarNumber
				WHERE carNumber = (SELECT carNumber FROM inserted)
				AND regionCode = (SELECT carRegionCode FROM inserted))
			BEGIN 
				INSERT INTO [KB301_Bobeshko].Task3.CarNumber
					(carNumber, regionCode) SELECT  carNumber, carRegionCode 
					FROM inserted
			END
			INSERT INTO [KB301_Bobeshko].Task3.PolicePost
				 (timeOfEvent, postId,  carStatus, carNumber, carRegionCode) 
					SELECT timeOfEvent, postId,  carStatus, carNumber, carRegionCode 
					FROM inserted
		END
GO 

CREATE TRIGGER CarNumber_Insert
	ON [KB301_Bobeshko].Task3.CarNumber
	INSTEAD OF INSERT
	AS 
		DECLARE @inputRegionCode VARCHAR(3);
		SELECT @inputRegionCode = regionCode FROM inserted
		IF EXISTS (SELECT * FROM  [KB301_Bobeshko].Task3.RegionCodes 
			WHERE otherRegionCode = @inputRegionCode)
		BEGIN 
			INSERT INTO [KB301_Bobeshko].Task3.CarNumber 
			(carNumber, regionCode) SELECT UPPER(carNumber), regionCode FROM inserted
		END 
		ELSE 
			RAISERROR ('Такого региона не существует', 1, 0);
GO


CREATE PROCEDURE AddPostEvent
	@postId INT, 
	@timeOfEvent TIME, 
	@carStatus VARCHAR(3), 
	@carNumber VARCHAR(6), 
	@carRegionCode VARCHAR(3)
	AS
	BEGIN
		INSERT INTO [KB301_Bobeshko].Task3.PolicePost
			VALUES (@timeOfEvent, @postId , @carStatus, @carNumber, @carRegionCode)
	END
GO

CREATE PROCEDURE CreateCarNumber
	@carNumber VARCHAR(6),
	@regionCode VARCHAR(3)
	AS
	BEGIN 
		INSERT INTO [KB301_Bobeshko].Task3.CarNumber
			VALUES (@carNumber, @regionCode)
	END
GO

CREATE PROCEDURE AddRegion
	@regionName VARCHAR(35),
	@regionCode VARCHAR(3)
	AS
	BEGIN 
		INSERT INTO [KB301_Bobeshko].Task3.Regions
			VALUES (@regionName, @regionCode)

		INSERT INTO [KB301_Bobeshko].Task3.RegionCodes
			VALUES (@regionCode, @regionCode)
	END
GO

CREATE PROCEDURE AddOtherRegionCode
	@mainRegionCode VARCHAR(3),
	@otherRegionCode VARCHAR(3)
	AS 
	BEGIN 
		INSERT INTO [KB301_Bobeshko].Task3.RegionCodes
			VALUES (@mainRegionCode, @otherRegionCode)
	END
GO

--Добавление корректных регионов
EXEC AddRegion 'Челябинская обл.', '74'
EXEC AddRegion 'Свердловская обл.', '66'
EXEC AddRegion 'Башкортостан респ.', '02'

--Добавление неккоректного региона
EXEC AddRegion 'Тюменская обл.', '999'

--Добавление дополнительных кодов регионов
EXEC AddOtherRegionCode '74', '174'
EXEC AddOtherRegionCode '74', '774'
EXEC AddOtherRegionCode '66', '96'
EXEC AddOtherRegionCode '66', '196'
EXEC AddOtherRegionCode '02', '102'
EXEC AddOtherRegionCode '74', '702'

--Добавление новой корректной машины
EXEC CreateCarNumber 'У191УК', '174'

--Добавление неккоректного дополнительного кода
EXEC AddOtherRegionCode '74', '999'

--Добавление новой машины с неккоретным номером
EXEC CreateCarNumber 'У000УК', '174'

--Добавление новой машины с неккоретным кодом региона
EXEC CreateCarNumber 'У191УК', '999'

--Добавление новой машины с неккоретными буквами
EXEC CreateCarNumber 'GG191G', '174'

--Добавление записи в таблицу Поста ГАИ
DECLARE @time time(0) = CAST('12:00:00' AS time(0))
EXEC AddPostEvent 1,  @time, 'IN', 'У191УК', '174' 

--Выезд машины из города более чем через 5 минут
DECLARE @time time(0) = CAST('13:15:00' AS time(0))
EXEC AddPostEvent 1,  @time, 'OUT', 'У191УК', '174' 

--Выезд машины из города менее чем через 5 минут
DECLARE @time time(0) = CAST('13:16:00' AS time(0))
EXEC AddPostEvent 1,  @time, 'IN', 'У191УК', '174' 

--Выезд машины из города менее в неккоректном направлении
DECLARE @time time(0) = CAST('14:15:00' AS time(0))
EXEC AddPostEvent 1,  @time, 'OUT', 'У191УК', '174' 


--Вьезд машины которой нет в таблице CarNumber
DECLARE @time time(0) = CAST('14:15:00' AS time(0))
EXEC AddPostEvent 2,  @time, 'IN', 'А001АА', '66' 

--Вьезд машины с некорректным номером
DECLARE @time time(0) = CAST('01:00:00' AS time(0))
EXEC AddPostEvent 2,  @time, 'IN', 'А000АА', '102' 

SELECT * FROM Task3.PolicePost
SELECT * FROM Task3.RegionCodes ORDER BY regionCode, otherRegionCode