select NewValue as StartingUser
into #Temp
from ClaimLog
where FieldName = 'ExaminerCode'
and OldValue = 'unassigned'

select * from #Temp

drop table #Temp

select PK as ClaimID
	, NewValue as StartingUser
	, NULL as FollowingUser
	, 0 as Level
into #Temp
from ClaimLog
where FieldName = 'ExaminerCode'
and OldValue = 'unassigned'

create table #Temp 
	(
	ClaimID int
	, CurrentExaminer varchar(50)
	, PreviousExaminer varchar(50)
	, AssignedDate datetime
	, level int
	)

insert into #Temp
select CL.PK as ClaimID
	, CL.NewValue as CurrentExaminer
	, NULL as PreviousExaminer
	, LatestAssignedDate as AssignedDate
	, 0 as Level
from (
	select PK
		, MAX(EntryDate) as LatestAssignedDate
	from ClaimLog
	where FieldName = 'ExaminerCode'
	group by PK
	) x
join ClaimLog CL on x.PK = CL.PK
and x.LatestAssignedDate = Cl.EntryDate
and CL.FieldName = 'ExaminerCode'
order by CL.PK


insert into #Temp
select CL.PK as ClaimID
	, CL.NewValue as CurrentExaminer
	, NULL as PreviousExaminer
	, LatestAssignedDate as AssignedDate
	, 0 as Level
from (
	select CL.PK
		, MAX(CL.EntryDate) as LatestAssignedDate
	from ClaimLog CL
	join #Temp T on T.ClaimID = CL.PK
	where CL.FieldName = 'ExaminerCode'
	and CL.EntryDate < T.AssignedDate
	group by PK
	) x
join ClaimLog CL on x.PK = CL.PK
and x.LatestAssignedDate = Cl.EntryDate
and CL.FieldName = 'ExaminerCode'
join #Temp T2 on T2.ClaimID = Cl.PK
order by CL.PK