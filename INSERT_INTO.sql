declare @TempTable table (
	ClaimNumber varchar(MAX)
	, TotalReserveAmount float
	, PatientName varchar(63)
)

insert into @TempTable
select C.ClaimNumber
	,Sum(R.ReserveAmount) as ReserveSum
	, TRIM(P.LastName + ' ' + P.FirstName + P.MiddleName)
from Claim C
join Claimant Cl on C.ClaimID = Cl.ClaimID
join Reserve R on r.ClaimantID = Cl.ClaimantID
join Patient P on p.PatientID = Cl.PatientID
group by C.ClaimNumber
	, TRIM(P.LastName + ' ' + P.FirstName + P.MiddleName)


select * from @TempTable