--SUBQUERIES
select C.ClaimNumber
from
	(
	select top 10 *
	from Claim
	) C


--WHERE
select Supervisor, UserName
from Users
where UserName in (
	select distinct EnteredBy
	from ReservingTool
	)


select top 1MedicalReservingAmount, EnteredOn, IsPublished
from ReservingTool
where IsPublished = 1
order by EnteredOn desc

select MedicalReservingAmount, EnteredOn, IsPublished
from ReservingTool
where EnteredOn = (
	select max(EnteredOn)
	from ReservingTool
	where IsPublished = 1
	)
and IsPublished = 1


--FROM Subqueries
select C.ClaimNumber, R.ReserveAmount, ReserveSum.TotalReserveAmount
	, R.ReserveAmount/TotalReserveAmount as ReserveProportion
from (
	select Cl2.ClaimantID, sum(R2.ReserveAmount) as TotalReserveAmount
	from Reserve R2
	inner join  Claimant Cl2 on Cl2.ClaimantID = R2.ClaimantID
	inner join Claim C2 on C2.ClaimID = Cl2.ClaimID
	where C2.ClaimNumber = '500008648-1'
	group by Cl2.ClaimantID
	) ReserveSum
inner join Reserve R on ReserveSum.ClaimantID = R.ClaimantID
inner join  Claimant Cl on Cl.ClaimantID = R.ClaimantID
inner join Claim C on C.ClaimID = Cl.ClaimID
where C.ClaimNumber = '500008648-1'


select C.ClaimNumber
	, R.ReserveAmount
	, SUM(ReserveAmount) over (Partition By C.ClaimNumber) as TotalReserveSum
from Reserve R
inner join  Claimant Cl on Cl.ClaimantID = R.ClaimantID
inner join Claim C on C.ClaimID = Cl.ClaimID
where C.ClaimNumber = '500008648-1'


select * from Claim
select * from ClaimLog

select C.ClaimID, C.ExaminerCode, LD.LatestDate
from Claim C
join (
	select PK, MAX(EntryDate) as LatestDate
	from ClaimLog
	where FieldName = 'ExaminerCode'
	group by PK
	) LD on LD.PK = C.ClaimID