--ex1
CREATE TABLE Prices (
	PriceID int PRIMARY KEY IDENTITY(1,1)
	, ReserveTypeID int FOREIGN KEY REFERENCES ReserveType (ReserveTypeID)
	, ProcedureCode varchar(6)
	, ProcedureName varchar(63)
	, ExpectedPrice float
)

select *
from Prices

--ex2
CREATE TABLE BillDetail (
	BillDetailId int primary key identity(1,1)
	, BillID int foreign key references Bill(BillId)
	, LineNumber int not null
	, ProcedureCode varchar(6)
	, Description varchar(MAX)
	, Quantity int
	, PricePerUnit float
	,TotalPrice float not null
)

select *
from BillDetail

--ex3
declare @DocumentType varchar(15)
set @DocumentType = 'pdf'
select @DocumentType

--ex4
declare @ReserveSum table (
	ClaimantID int primary key identity(1,1)
	, ReserveAmountSum float not null
)

select *
from @ReserveSum