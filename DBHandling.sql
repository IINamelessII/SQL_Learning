CREATE TABLE Bill (
	BillId int
	, ClaimantID int
	, PatientID int
	, DateRecieved datetime
	, DateBilled datetime
	, TotalBillAmount float
	, ProviderID varchar(8)
	, ProviderName varchar(255)
	, Description varchar(MAX)
)

CREATE TABLE PaymentType (
	PaymentTypeID int
	, PaymentTypeDesc varchar(MAX)
	, SettlementFlag bit
)

drop table Bill

CREATE TABLE Bill (
	BillId int PRIMARY KEY IDENTITY(1,1)
	, ClaimantID int FOREIGN KEY REFERENCES Claimant(ClaimantID)
	, PatientID int FOREIGN KEY REFERENCES Patient(PatientID)
	, DateRecieved datetime
	, DateBilled datetime
	, TotalBillAmount float NOT NULL
	, ProviderID varchar(8)
	, ProviderName varchar(255)
	, Description varchar(MAX)
)

CREATE TABLE Payment (
	PaymentID int PRIMARY KEY IDENTITY(1,1)
	, ClaimantID int FOREIGN KEY REFERENCES Claimant(ClaimantID)
	, PaidAmount float NOT NULL
	, DatePaid datetime NOT NULL
	, EnteredBy varchar(63)
)

DROP TABLE Bill

CREATE TABLE Bill (
	BillId int
	, ClaimantID int
	, PatientID int
	, DateRecieved datetime
	, DateBilled datetime
	, TotalBillAmount float
	, ProviderID varchar(8)
	, ProviderName varchar(255)
	, Description varchar(MAX)
)

ALTER TABLE Bill
ALTER COLUMN ProviderId varchar(32)

ALTER TABLE Bill
ADD ExtraBillColumn varchar(MAX)

ALTER TABLE Bill
DROP COLUMN ExtraBillColumn

ALTER TABLE Bill
ALTER COLUMN BillId INT NOT NULL

ALTER TABLE Bill
ADD PRIMARY KEY (BillId)

ALTER TABLE Bill
ADD FOREIGN KEY (ClaimantID) REFERENCES Claimant(ClaimantID)


ALTER TABLE PaymentType
DROP COLUMN SettlementFlag

ALTER TABLE PaymentType
ALTER COLUMN PaymentTypeID INT NOT NULL
ALTER TABLE PaymentType
ADD PRIMARY KEY (PaymentTypeID)

ALTER TABLE Payment
ADD Notes varchar(MAX)

ALTER TABLE Payment
ADD PaymentTypeID INT NOT NULL
ALTER TABLE Payment
ADD FOREIGN KEY (PaymentTypeID) REFERENCES PaymentType(PaymentTypeID)


DECLARE @InflationRate FLOAT
SET @InflationRate = 0.02

SELECT UserName
	, ReserveLimit
	, ReserveLimit * (1 + @InflationRate) as NextYearRL
FROM Users

declare @PreviousUser varchar(30)
select top 1 @PreviousUser = OldValue
from ClaimLog
where PK = 24109 and FieldName = 'ExaminerCode' and EntryDate = (
	select max(EntryDate)
	from ClaimLog
	where pk = 24109
	and FieldName = 'ExaminerCode'
)
select @PreviousUser as PrevUser


declare @MedicalReserveTypes_Array table (
	MedicalReserveType varchar(MAX)
)

select * 
from @MedicalReserveTypes_Array


declare @TempTable table (
	ClaimNumber varchar(MAX)
	, TotalReserveAmount float
	, PatientName varchar(63)
)

select *
from @TempTable

declare @DateAsOf date
set @DateAsOf = '1/1/2018'

select *
from Attachment
where EntryDate < @DateAsOf