--SELECT basics 
SELECT UserName, LastFirstName
FROM Insurance.dbo.Users

SELECT *
FROM Insurance.dbo.Users

SELECT *
FROM Insurance.dbo.ClaimLog 
ORDER BY PK

SELECT TOP 4 UserName, LastFirstName, Title, PaymentLimit
FROM Insurance.dbo.Users
ORDER BY PaymentLimit DESC

select ClaimNumber, InjuryState, ExaminerCode
from Insurance.dbo.Claim
where ExaminerCode = 'lnikki'

select UserName, Title, ReserveLimit
from Insurance.dbo.Users
where Title like '%specialist'

select *
from Insurance.dbo.Claimant
where year(ClosedDate) = 2018




--SELECT: or, and, is, not, null
select LogId, PK, FieldName, OldValue, NewValue, EntryDate
from Insurance.dbo.ClaimLog
where FieldName = 'ExaminerCode' and OldValue = 'Unassigned'

select *
from Insurance.dbo.Users
where UserName = 'dclara' or Supervisor = 'dclara'

select ClaimantId
, ClosedDate
, ReopenedDate
,try_convert(int, ClosedDate - ReopenedDate) as DateFifference
from Insurance.dbo.Claimant
where ClosedDate is not null

select *
from Insurance.dbo.Claimant
where year(ClosedDate) = 2018 and ReopenedDate is not null




--SELECT:aggregate func-s: max,min,avg,count,sum
select max(PaymentLimit) as MaximumPaymentLimit
, min(PaymentLimit) as MinimumPaymentLimit
, avg(PaymentLimit) as AveragePaymentLimit
from Insurance.dbo.Users

select count(ReopenedDate) as ReopenedCount
, count(ClosedDate) as ClosedCount
, count(ClosedDate) - count(ReopenedDate) as Diff
from Insurance.dbo.Claimant

select avg(ReserveAmount) as AverageReserveAmount
from Insurance.dbo.Reserve




--SELECT: distinct, group by, !distinct doesnt work with aggregate funcs
select distinct ExaminerCode
from Insurance.dbo.Claim

select distinct ExaminerCode, InjuryState, JurisdictionID, year(EntryDate) as EntryYear
from Insurance.dbo.Claim

select ExaminerCode
from Insurance.dbo.Claim
group by ExaminerCode

select ExaminerCode, InjuryState, JurisdictionID, year(EntryDate) as EntryYear
from Insurance.dbo.Claim
group by ExaminerCode, InjuryState, JurisdictionID, year(EntryDate)

select ExaminerCode, Count(*) as NumberOfClaimsHandled
from Insurance.dbo.Claim
group by ExaminerCode

select Count(*) as Number, EnteredBy
from Insurance.dbo.ReservingTool
where IsPublished = 1
group by EnteredBy




--SELECT: into, in, having
select top 10 BusinessName, count(BusinessName) as Employees
into Insurance.dbo.Top10Inc
from Insurance.dbo.Patient
where BusinessName like '%inc%'
group by BusinessName
order by count(BusinessName) desc

select *
from Insurance.dbo.Attachment
where EnteredBy in ('qkemp', 'kgus', 'unassigned')

--LIKE doesnt work inside IN
select *
from Insurance.dbo.Attachment
where FileName like '%.ppt%' or FileName like '%.doc%'

--aggregate funcs dont work inside WHERE
select EnteredBy, Count(*) as Number
from Insurance.dbo.ReservingTool
where IsPublished = 1
group by EnteredBy
having count(*) > 50