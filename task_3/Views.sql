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
		

SELECT * FROM TransitCarsThrough174 ORDER BY [Номер машины]


CREATE VIEW NonResidentCars174
	AS 
	SELECT postId AS 'Номер поста', 
		UPPER(carNumber + carRegionCode) AS 'Номер машины',
		timeOfEvent AS 'Время',
		carStatus AS 'Направление'
		FROM Task3.PolicePost
	JOIN(SELECT	CAST(postId as varchar) + ' ' 
										+ carNumber + ' ' 
										+ carRegionCode AS 'Номер поста, номер автомобиля', 
										COUNT(postId) AS 'Количество проездов'
				FROM Task3.PolicePost
	JOIN(SELECT carNumber + carRegionCode AS 'Номер автомобиля' 
						FROM Task3.PolicePost GROUP BY carNumber + carRegionCode
						HAVING COUNT(*) > 1) AS Temp 
					ON PolicePost.carNumber + PolicePost.carRegionCode = Temp.[Номер автомобиля]
			WHERE carRegionCode != '74' and carRegionCode != '174' and carRegionCode != '774'
			GROUP BY CAST(PolicePost.postId as varchar) + ' ' 
				+ PolicePost.carNumber + ' ' 
				+ PolicePost.carRegionCode
				HAVING COUNT(postId) = 2) AS Temp
			ON Temp.[Номер поста, номер автомобиля] = CAST(PolicePost.postId as varchar) + ' ' 
													+ PolicePost.carNumber + ' '
													+ PolicePost.carRegionCode
			JOIN Task3.RegionCodes ON PolicePost.carRegionCode = RegionCodes.otherRegionCode
			JOIN Task3.Regions ON Task3.RegionCodes.regionCode = Regions.regionCode

SELECT * FROM NonResidentCars174 ORDER BY [Номер машины]

CREATE VIEW ResidentCars174
	AS 
	SELECT postId AS 'Номер поста', 
		UPPER(carNumber + carRegionCode) AS 'Номер машины',
		timeOfEvent AS 'Время',
		carStatus AS 'Направление'
		FROM Task3.PolicePost
	JOIN(SELECT	CAST(postId as varchar) + ' ' 
										+ carNumber + ' ' 
										+ carRegionCode AS 'Номер поста, номер автомобиля', 
										COUNT(postId) AS 'Количество проездов'
				FROM Task3.PolicePost
	JOIN(SELECT carNumber + carRegionCode AS 'Номер автомобиля' 
						FROM Task3.PolicePost GROUP BY carNumber + carRegionCode
						HAVING COUNT(*) > 1) AS Temp 
					ON PolicePost.carNumber + PolicePost.carRegionCode = Temp.[Номер автомобиля]
			WHERE carRegionCode = '74' OR carRegionCode = '174' OR carRegionCode = '774'
			GROUP BY CAST(PolicePost.postId as varchar) + ' ' 
				+ PolicePost.carNumber + ' ' 
				+ PolicePost.carRegionCode) AS Temp
			ON Temp.[Номер поста, номер автомобиля] = CAST(PolicePost.postId as varchar) + ' ' 
													+ PolicePost.carNumber + ' '
													+ PolicePost.carRegionCode
			JOIN Task3.RegionCodes ON PolicePost.carRegionCode = RegionCodes.otherRegionCode
			JOIN Task3.Regions ON Task3.RegionCodes.regionCode = Regions.regionCode

SELECT * FROM ResidentCars174 ORDER BY [Номер машины]

