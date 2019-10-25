select * from Patient
select * from Claimant
select * from Claim

--ex1
select BusinessName, FirstName, MiddleName, LastName
from Patient
join Claimant on Patient.PatientID = Claimant.PatientID
join Claim on Claimant.ClaimID = Claim.ClaimID
where Claim.ClaimNumber = '752663830-X'


select * from Office
select * from Users

--ex2
select O.OfficeDesc, count(U.UserName) as UsersCount
from Office O
left join Users U on O.OfficeID = U.OfficeID
group by O.OfficeDesc
order by count(U.UserName) desc


select * from Reserve
select * from Users
select * from Office

--ex3
select *
from Reserve R
join Users U on R.EnteredBy = U.UserName
join Office O on U.OfficeID = O.OfficeID
where O.OfficeCode = 'SF'


select * from ReserveType
select * from Reserve
select * from Patient

select RT.ReserveTypeDesc, R.*
from Reserve R
join ReserveType RT on R.ReserveTypeID = RT.reserveTypeID
where RT.ReserveTypeCode <> ''

--ex4
select isnull(RT2.ReserveTypeDesc, RT1.ReserveTypeDesc) as ReserveBucket, R.*
from Reserve R
join ReserveType RT1 on R.ReserveTypeID = RT1.reserveTypeID
left join ReserveType RT2 on RT2.reserveTypeID = RT1.ParentID