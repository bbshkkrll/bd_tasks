--���������� ���������� ��������
EXEC AddRegion '����������� ���.', '74'
EXEC AddRegion '������������ ���.', '66'
EXEC AddRegion '������������ ����.', '02'

--���������� ������������� �������
EXEC AddRegion '��������� ���.', '999'

--���������� �������������� ����� ��������
EXEC AddOtherRegionCode '74', '174'
EXEC AddOtherRegionCode '74', '774'
EXEC AddOtherRegionCode '66', '96'
EXEC AddOtherRegionCode '66', '196'
EXEC AddOtherRegionCode '02', '102'
EXEC AddOtherRegionCode '74', '702'
/*
--���������� ����� ���������� ������
EXEC CreateCarNumber '�191��', '174'

--���������� ������������� ��������������� ����
EXEC AddOtherRegionCode '74', '999'

--���������� ����� ������ � ����������� �������
EXEC CreateCarNumber '�000��', '174'
EXEC CreateCarNumber '�1234��', '174'


--���������� ����� ������ � ����������� ����� �������
EXEC CreateCarNumber '�191��', '999'
EXEC CreateCarNumber '�191��', '999'

--���������� ����� ������ � ������������ �������
EXEC CreateCarNumber 'GG191G', '174'
*/

--���������� ������ � ������� ����� ���
EXEC AddPostEvent 1,  '01:01:00', 'IN', '�191��', '174' 
EXEC AddPostEvent 1,  '02:30:00', 'OUT', '�191��', '174' 

--���������� ����������� ������ 
EXEC AddPostEvent 1,  '01:34:00', 'IN', '�901��', '102' 
EXEC AddPostEvent 1,  '03:15:00', 'OUT', '�901��', '102' 

EXEC AddPostEvent 1,  '12:45:00', 'IN', '�123��', '66' 
EXEC AddPostEvent 1,  '16:05:00', 'OUT', '�123��', '66' 


--���������� ���������� ������ 
EXEC AddPostEvent 1,  '12:55:00', 'IN', '�888��', '02' 
EXEC AddPostEvent 2,  '16:07:00', 'OUT', '�888��', '02' 


EXEC AddPostEvent 2,  '13:34:00', 'IN', '�666��', '196' 
EXEC AddPostEvent 3,  '16:12:01', 'OUT', '�666��', '196'

--���������� ������ � ������������ �������
EXEC AddPostEvent 2,  '13:34:00', 'IN', '�����', '196' 
EXEC AddPostEvent 2,  '13:34:00', 'IN', '�000��', '196' 
EXEC AddPostEvent 2,  '13:34:00', 'IN', '�123��', '196' 
EXEC AddPostEvent 2,  '13:34:00', 'IN', '�1234��', '196' 
EXEC AddPostEvent 2,  '13:34:00', 'IN', '�����', '999' 


--����� ������ �� ������ ����� ��� ����� 5 �����
EXEC AddPostEvent 1,  '11:11:11', 'IN', '�123��', '174' 
EXEC AddPostEvent 1,  '11:14:00', 'OUT', '�123��', '174' 

--�������� ������ � ������������ ������������ 
EXEC AddPostEvent 1,  '10:38:11', 'IN', '�567��', '66' 
EXEC AddPostEvent 1,  '18:15:10', 'IN', '�567��', '66' 


/*
EXEC AddPostEvent 1,  '01:00:00', 'IN', '�555��', '102'
EXEC AddPostEvent 1,  '02:35:00', 'OUT', '�555��', '102'

EXEC AddPostEvent 1,  '03:44:00', 'IN', '�801��', '66'
EXEC AddPostEvent 1,  '06:00:00', 'OUT', '�801��', '66'


EXEC AddPostEvent 1,  '03:45:00', 'IN', '�802��', '66'
EXEC AddPostEvent 2,  '06:01:00', 'OUT', '�802��', '66'


EXEC AddPostEvent 1,  '22:50:10', 'IN', '�001��', '02'
EXEC AddPostEvent 2,  '23:34:00', 'OUT', '�001��', '02'
*/

SELECT * FROM [KB301_Bobeshko].Task3.PolicePost
SELECT * FROM Cars ORDER BY [����� ������]
SELECT * FROM ResidentCars174 ORDER BY [����� ������]
SELECT * FROM TransitCarsThrough174 ORDER BY [����� ������]
SELECT * FROM NonResidentCars174 ORDER BY [����� ������]
