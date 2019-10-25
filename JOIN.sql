--INNER JOIN ON
select Reserve.ClaimantID
	--,Reserve.ReserveTypeID
	--,ReserveType.reserveTypeID
	, ReserveType.ReserveTypeDesc as ReserveType
	, Reserve.ReserveAmount
from Reserve
inner join ReserveType on Reserve.ReserveTypeID = ReserveType.reserveTypeID

select C.ClaimNumber, CT.ClaimantTypeDesc as ClaimantType
from Claim C
inner join Claimant Clmt on C.ClaimID = Clmt.ClaimID
inner join ClaimantType CT on Clmt.ClaimantTypeID = CT.ClaimantTypeID

select top 100 ClaimNumber, CL.*
from Claim C
inner join ClaimLog CL on C.ClaimID = CL.PK
order by pk




--LEFT JOIN ON
select ClaimNumber
from Claim
order by ClaimNumber

select C.ClaimNumber, SUM(RT.ExpenseReservingAmount) as ExpensesSum
from Claim C
inner join ReservingTool RT on C.ClaimNumber = RT.ClaimNumber
group by C.ClaimNumber
order by SUM(RT.ExpenseReservingAmount)

select C.ClaimNumber, SUM(RT.ExpenseReservingAmount) as ExpensesSum
from Claim C
left join ReservingTool RT on C.ClaimNumber = RT.ClaimNumber
group by C.ClaimNumber
order by SUM(RT.ExpenseReservingAmount)

select * from ClaimStatus
select * from Patient
select * from Claimant

select ClaimStatusDesc, P.*
from ClaimStatus CS
inner join Claimant Clmt on CS.ClaimStatusId = Clmt.claimStatusID
inner join Patient P on Clmt.PatientID = P.PatientID
where P.MiddleName != ''

select * from ClaimLog
select * from Claim

select C.ClaimNumber, count(CL.PK) as TimesWasLocked
from Claim C
left join ClaimLog CL on C.ClaimID = CL.PK and CL.FieldName = 'LockedBy'
--where CL.FieldName = 'LockedBy'
group by C.ClaimNumber
order by count(CL.PK)




--WHERE JOIN
select C.ClaimNumber, SUM(RT.ExpenseReservingAmount) as ExpensesSum
from Claim C, ReservingTool RT
where C.ClaimNumber = RT.ClaimNumber
group by C.ClaimNumber
--RIGHT JOIN(Useless), FULL JOIN(rarely used)

--INNER JOIN = JOIN
--LEFT JOIN = LEFT OUTER JOIN
--RIGHT JOIN = RIGHT OUTER JOIN
--FULL JOIN = FULL OUTER JOIN
