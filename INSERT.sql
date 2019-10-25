/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP (1000) [OfficeID]
      ,[OfficeCode]
      ,[OfficeDesc]
      ,[City]
      ,[State]
  FROM [Insurance].[dbo].[Office2]

  insert into Office2
--  (
--        [OfficeCode]
--      ,[OfficeDesc]
--      ,[City]
--      ,[State]
--)
values (
	'ATL'
	, 'Atlanta'
	, ''
	, 'GA'
)

declare @temp_table table
	(ClaimNumber varchar(30)
	, TotalReserveAmount float
	, PatientName varchar(63))

insert into @temp_table (
	ClaimNumber
	, TotalReserveAmount
	, PatientName
) values ('12345ABC', 100, 'Rob the Builder')
, ('992345GHF', 499, 'Mary')

select * from @temp_table

insert into Office2 values
('CHI', '', 'Chicago', NULL)

--update
SELECT TOP (1000) [OfficeID]
      ,[OfficeCode]
      ,[OfficeDesc]
      ,[City]
      ,[State]
  FROM [Insurance].[dbo].[Office2]

  update Office2
  set City = OfficeDesc
	, OfficeDesc = ''

update Office2
set State = 'IL'
where OfficeID = 7

--delete
delete from Office2
where OfficeID in (6, 7)

--insert into select from
