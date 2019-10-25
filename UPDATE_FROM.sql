/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP (1000) [OldClaimNumber]
      ,[NewClaimNumber]
  FROM [Insurance].[dbo].[ClaimNumberFixes]

select *
into ReservingTool2
from ReservingTool

select *
from ReservingTool2

update ReservingTool2
set ClaimNumber = C.NewClaimNumber
from ReservingTool2 RT2
join ClaimNumberFixes C on RT2.ClaimNumber = C.OldClaimNumber
