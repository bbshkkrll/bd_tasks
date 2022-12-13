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
/*
--Добавление новой корректной машины
EXEC CreateCarNumber 'У191УК', '174'

--Добавление неккоректного дополнительного кода
EXEC AddOtherRegionCode '74', '999'

--Добавление новой машины с неккоретным номером
EXEC CreateCarNumber 'У000УК', '174'
EXEC CreateCarNumber 'У1234УК', '174'


--Добавление новой машины с неккоретным кодом региона
EXEC CreateCarNumber 'У191УК', '999'
EXEC CreateCarNumber 'У191УК', '999'

--Добавление новой машины с неккоретными буквами
EXEC CreateCarNumber 'GG191G', '174'
*/

--Добавление записи в таблицу Поста ГАИ
EXEC AddPostEvent 1,  '01:01:00', 'IN', 'У191УК', '174' 
EXEC AddPostEvent 1,  '02:30:00', 'OUT', 'У191УК', '174' 

--Добавление иногородней машины 
EXEC AddPostEvent 1,  '01:34:00', 'IN', 'В901АК', '102' 
EXEC AddPostEvent 1,  '03:15:00', 'OUT', 'В901АК', '102' 

EXEC AddPostEvent 1,  '12:45:00', 'IN', 'Т123ВА', '66' 
EXEC AddPostEvent 1,  '16:05:00', 'OUT', 'Т123ВА', '66' 


--Добавление транзитной машины 
EXEC AddPostEvent 1,  '12:55:00', 'IN', 'М888УУ', '02' 
EXEC AddPostEvent 2,  '16:07:00', 'OUT', 'М888УУ', '02' 


EXEC AddPostEvent 2,  '13:34:00', 'IN', 'У666ВУ', '196' 
EXEC AddPostEvent 3,  '16:12:01', 'OUT', 'У666ВУ', '196'

--Добавление машины с некорректным номером
EXEC AddPostEvent 2,  '13:34:00', 'IN', 'ААААА', '196' 
EXEC AddPostEvent 2,  '13:34:00', 'IN', 'А000АА', '196' 
EXEC AddPostEvent 2,  '13:34:00', 'IN', 'Ц123АА', '196' 
EXEC AddPostEvent 2,  '13:34:00', 'IN', 'А1234АА', '196' 
EXEC AddPostEvent 2,  '13:34:00', 'IN', 'ААААА', '999' 


--Выезд машины из города более чем через 5 минут
EXEC AddPostEvent 1,  '11:11:11', 'IN', 'О123ОО', '174' 
EXEC AddPostEvent 1,  '11:14:00', 'OUT', 'О123ОО', '174' 

--Движение машыны в некорректном направлнении 
EXEC AddPostEvent 1,  '10:38:11', 'IN', 'Т567АК', '66' 
EXEC AddPostEvent 1,  '18:15:10', 'IN', 'Т567АК', '66' 


/*
EXEC AddPostEvent 1,  '01:00:00', 'IN', 'Х555АМ', '102'
EXEC AddPostEvent 1,  '02:35:00', 'OUT', 'Х555АМ', '102'

EXEC AddPostEvent 1,  '03:44:00', 'IN', 'М801АМ', '66'
EXEC AddPostEvent 1,  '06:00:00', 'OUT', 'М801АМ', '66'


EXEC AddPostEvent 1,  '03:45:00', 'IN', 'М802АМ', '66'
EXEC AddPostEvent 2,  '06:01:00', 'OUT', 'М802АМ', '66'


EXEC AddPostEvent 1,  '22:50:10', 'IN', 'х001хх', '02'
EXEC AddPostEvent 2,  '23:34:00', 'OUT', 'х001хх', '02'
*/

SELECT * FROM [KB301_Bobeshko].Task3.PolicePost
SELECT * FROM Cars ORDER BY [Номер машины]
SELECT * FROM ResidentCars174 ORDER BY [Номер машины]
SELECT * FROM TransitCarsThrough174 ORDER BY [Номер машины]
SELECT * FROM NonResidentCars174 ORDER BY [Номер машины]
