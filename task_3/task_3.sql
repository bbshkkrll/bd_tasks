USE master
GO

IF EXISTS (  
	 SELECT name  
	 FROM sys.databases  
	 WHERE name = N'KB301_Bobeshko'  
  
)  
DROP DATABASE [KB301_Bobeshko]  
GO  
  
--alter database [KB301_Bobeshko] set single_user with rollback immediate  

  
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
				THROW 55555, 'Время меьше 5 минут или направление совпадает', 1;
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
					(carNumber, regionCode) SELECT  UPPER(carNumber), carRegionCode 
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
			THROW 55555, 'Такого региона не существует', 1;
GO


CREATE PROCEDURE AddPostEvent
	@postId INT, 
	@timeOfEvent VARCHAR(8), 
	@carStatus VARCHAR(3), 
	@carNumber VARCHAR(6), 
	@carRegionCode VARCHAR(3)
	AS
	BEGIN
		INSERT INTO [KB301_Bobeshko].Task3.PolicePost
			VALUES (@timeOfEvent, @postId , @carStatus, @carNumber, @carRegionCode)
	END
GO


--DROP PROCEDURE AddPostEvent

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

/*
SELECT carNumber + carRegionCode AS 'Номер машины', carStatus, postId, timeOfEvent 
	FROM [KB301_Bobeshko].Task3.PolicePost 
	GROUP BY carNumber + carRegionCode, carStatus, postId, timeOfEvent
GO	
*/



CREATE VIEW TransitCarsThrough174
	AS 
	SELECT postId AS 'Номер поста', 
		UPPER(carNumber + carRegionCode) AS 'Номер машины',
		timeOfEvent AS 'Время',
		carStatus AS 'Направление'
		FROM Task3.PolicePost
		JOIN(
			SELECT	CAST(postId AS VARCHAR) + ' ' 
										+ carNumber + ' '
										+ carRegionCode AS 'Номер поста, номер автомобиля', 
					COUNT(postId) AS 'Количество проездов'
			FROM Task3.PolicePost
		JOIN(
			SELECT carNumber + carRegionCode AS 'Номер автомобиля' 
							FROM Task3.PolicePost 
							GROUP BY carNumber + carRegionCode
							HAVING COUNT(*) > 1) AS Temp 
							ON PolicePost.carNumber + PolicePost.carRegionCode = Temp.[Номер автомобиля]
				WHERE carRegionCode != '74' and carRegionCode != '174' and carRegionCode != '774'
				GROUP BY CAST(PolicePost.postId AS VARCHAR) + ' ' 
					+ PolicePost.carNumber + ' ' 
					 + PolicePost.carRegionCode
					HAVING COUNT(postId) = 1) AS Temp
				ON Temp.[Номер поста, номер автомобиля] = CAST(PolicePost.postId AS VARCHAR) + ' ' 
														+ PolicePost.carNumber + ' '
														+ PolicePost.carRegionCode
		JOIN Task3.RegionCodes ON PolicePost.carRegionCode = RegionCodes.otherRegionCode
		JOIN Task3.Regions ON Task3.RegionCodes.regionCode = Regions.regionCode
GO

DROP VIEW NonResidentCars174
CREATE VIEW NonResidentCars174
	AS 
	SELECT postId AS 'Номер поста', 
		UPPER(carNumber + carRegionCode) AS 'Номер машины',
		timeOfEvent AS 'Время',
		carStatus AS 'Направление'
		FROM Task3.PolicePost
	JOIN(SELECT	CAST(postId AS VARCHAR) + ' ' 
										+ carNumber + ' '
										+ carRegionCode AS 'Номер поста, номер автомобиля', 
					COUNT(postId) AS 'Количество проездов'
				FROM Task3.PolicePost
	JOIN(SELECT carNumber + carRegionCode AS 'Номер автомобиля' 
						FROM Task3.PolicePost GROUP BY carNumber + carRegionCode
						HAVING COUNT(*) > 1) AS Temp 
					ON PolicePost.carNumber + PolicePost.carRegionCode = Temp.[Номер автомобиля]
			WHERE carRegionCode != '74' and carRegionCode != '174' and carRegionCode != '774'
			GROUP BY CAST(PolicePost.postId AS VARCHAR) + ' ' 
					+ PolicePost.carNumber + ' ' 
					 + PolicePost.carRegionCode
				HAVING COUNT(postId) = 2) AS Temp
			ON Temp.[Номер поста, номер автомобиля] = CAST(PolicePost.postId as varchar) + ' ' 
													+ PolicePost.carNumber + ' '
													+ PolicePost.carRegionCode
			JOIN Task3.RegionCodes ON PolicePost.carRegionCode = RegionCodes.otherRegionCode
			JOIN Task3.Regions ON Task3.RegionCodes.regionCode = Regions.regionCode
GO

SELECT * FROM NonResidentCars174 ORDER BY [Номер машины]


CREATE VIEW ResidentCars174
	AS 
	SELECT postId AS 'Номер поста', 
		UPPER(carNumber + carRegionCode) AS 'Номер машины',
		timeOfEvent AS 'Время',
		carStatus AS 'Направление'
		FROM Task3.PolicePost
	JOIN(SELECT CAST(postId AS VARCHAR) + ' ' 
										+ carNumber + ' '
										+ carRegionCode AS 'Номер поста, номер автомобиля', 
					COUNT(postId) AS 'Количество проездов'
				FROM Task3.PolicePost
	JOIN(SELECT carNumber + carRegionCode AS 'Номер автомобиля' 
						FROM Task3.PolicePost GROUP BY carNumber + carRegionCode
						HAVING COUNT(*) > 1) AS Temp 
					ON PolicePost.carNumber + PolicePost.carRegionCode = Temp.[Номер автомобиля]
			WHERE carRegionCode = '74' OR carRegionCode = '174' OR carRegionCode = '774'
			GROUP BY CAST(PolicePost.postId AS VARCHAR) + ' ' 
					+ PolicePost.carNumber + ' ' 
					 + PolicePost.carRegionCode) AS Temp
			ON Temp.[Номер поста, номер автомобиля] = CAST(PolicePost.postId as varchar) + ' ' 
													+ PolicePost.carNumber + ' '
													+ PolicePost.carRegionCode
			JOIN Task3.RegionCodes ON PolicePost.carRegionCode = RegionCodes.otherRegionCode
			JOIN Task3.Regions ON Task3.RegionCodes.regionCode = Regions.regionCode
GO




SELECT * FROM ResidentCars174 ORDER BY [Номер машины]

CREATE VIEW Cars
	AS 
	SELECT postId AS 'Номер поста', 
		UPPER(carNumber + carRegionCode) AS 'Номер машины',
		timeOfEvent AS 'Время',
		carStatus AS 'Направление'
		FROM Task3.PolicePost
