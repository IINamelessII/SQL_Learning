USE Insurance
GO

CREATE PROCEDURE SPGetReserve
AS
BEGIN
	SELECT 
		ReserveId, ClaimantId, ReserveAmount
	FROM Reserve
END

SPGetReserve
EXEC SPGetReserve
EXECUTE SPGetReserve


ALTER PROCEDURE SPGetReserve
	@ReserveType varchar(30) = NULL
	, @ReserveAmountMin float = 0
AS
BEGIN
	SELECT 
		R.ReserveID, R.ClaimantID, R.ReserveAmount, R.ReserveTypeID, RT.ReserveTypeDesc
	FROM Reserve R
	JOIN ReserveType RT ON R.ReserveTypeID = RT.reserveTypeID
	WHERE RT.ReserveTypeDesc = @ReserveType
		AND R.ReserveAmount > @ReserveAmountMin
END

SPGetReserve @ReserveType = 'Medical', @ReserveAmountMin = 1000


CREATE TABLE #Temp1
(
	ReserveID INT PRIMARY KEY
	, ClaimantID INT
	, ReserveAmount FLOAT
	, ReserveTypeID INT
	, ReserveTypeDesc VARCHAR(30)
)

INSERT INTO #Temp1
EXEC SPGetReserve @ReserveType = 'Medical', @ReserveAmountMin = 1000

SELECT * FROM #Temp1

DROP TABLE #Temp1

EXEC SPGetReserve