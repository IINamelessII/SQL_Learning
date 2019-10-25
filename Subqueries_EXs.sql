--ex1
select ReserveAmount
from Reserve
where ReserveAmount > (
	select ReserveAmount
	from Reserve
	where ReserveID = 588785
	)


--ex2
select ReserveAmount
from Reserve
where ReserveAmount > (
	select avg(ReserveAmount)
	from Reserve
	)


--ex3
select top 1 ReserveId, ReserveAmount
from Reserve
where ReserveAmount in (
	select top 2 ReserveAmount
	from Reserve
	order by ReserveAmount desc
)
order by ReserveAmount


select * from ReservingTool

--ex4
select RT.ClaimNumber, FL.Last, FL.First, RT2.MedicalReservingAmount - RT3.MedicalReservingAmount as diff
from ReservingTool RT
join (
	select min(EnteredOn) as First, max(EnteredOn) as Last, ClaimNumber
	from ReservingTool
	group by ClaimNumber
) FL on RT.ClaimNumber = FL.ClaimNumber
join ReservingTool RT2 on RT2.EnteredOn = FL.Last and FL.ClaimNumber = RT2.ClaimNumber
join ReservingTool RT3 on RT3.EnteredOn = FL.First  and FL.ClaimNumber = RT3.ClaimNumber
group by RT.ClaimNumber, FL.Last, FL.First, RT2.MedicalReservingAmount, RT3.MedicalReservingAmount


