--Ex1
select *
from Insurance.dbo.Attachment
where FileName like '%.pdf' and EnteredBy = 'lnikki'

--Ex2
select *
from Insurance.dbo.ReserveType
where ReserveTypeDesc like '%medical%' or ParentID = reserveTypeID

select *
from Insurance.dbo.ReserveType
where reserveTypeID = 1 or ParentID = 1

--Ex3
select ClaimantID, count(*) as ReserveChangeCount
from Insurance.dbo.Reserve
group by ClaimantID
having count(*) >= 15

--Ex4
select top 0 *
into Insurance.dbo.Claim2
from Insurance.dbo.Claim

--Ex5
select right(FileName, 3) as DockType, count(*) as DocTypeCount
from Insurance.dbo.Attachment
group by right(FIleName, 3)

