-- Display the list of employees and their roles.

SELECT
    e.Employee_ID,
    e.Employee_Name,
    e.Employee_Surname,
    r.Role_Name,
    r.Hour_Rate
FROM Employees AS e
INNER JOIN Role AS r
    ON e.Role_ID = r.Role_ID
ORDER BY
    e.Employee_Surname,
    e.Employee_Name;

-- Display all vehicles serviced within a selected date range, including the performed service, replaced parts, and the employee responsible for the work.

DECLARE @DateFrom date = '2024-01-01';
DECLARE @DateTo   date = '2024-12-31';

SELECT
    c.Car_VIN,
    c.Make,
    c.Model,
    c.[Year] AS Car_Year,
    s.Service_ID,
    s.Service_Job,
    s.Checkin_Date,
    s.Checkout_Date,
    p.Part_Name,
    p.Parts_Price,
    p.Parts_Purchase_Date,
    e.Employee_ID,
    e.Employee_Name,
    e.Employee_Surname
FROM Service AS s
INNER JOIN Car AS c
    ON s.Car_VIN = c.Car_VIN
INNER JOIN Employees AS e
    ON s.Employee_ID = e.Employee_ID
LEFT JOIN Parts AS p
    ON s.Car_VIN = p.Car_VIN
    AND p.Parts_Purchase_Date >= s.Checkin_Date
    AND p.Parts_Purchase_Date <= ISNULL(s.Checkout_Date, @DateTo)
WHERE s.Checkin_Date <= @DateTo
  AND ISNULL(s.Checkout_Date, s.Checkin_Date) >= @DateFrom
ORDER BY
    s.Checkin_Date,
    c.Make,
    c.Model,
    p.Part_Name;

-- This query displays the total earnings of each employee for the most recent year available in the database.
-- If you want to calculate earnings for the last 12 months instead of the latest calendar year, you would need to construct a date using the "Month" and "Year" fields.

    DECLARE @LastYear smallint;

SELECT @LastYear = MAX([Year])
FROM Completed_Work;

SELECT
    e.Employee_ID,
    e.Employee_Name,
    e.Employee_Surname,
    @LastYear AS Earnings_Year,
    SUM(cw.Worked_Hours) AS Total_Worked_Hours,
    SUM(cw.Bonuses) AS Total_Bonuses,
    SUM(cw.Worked_Hours * r.Hour_Rate) AS Basic_Earnings,
    SUM((cw.Worked_Hours * r.Hour_Rate) + cw.Bonuses) AS Total_Earnings
FROM Completed_Work AS cw
INNER JOIN Employees AS e
    ON cw.Employee_ID = e.Employee_ID
INNER JOIN Role AS r
    ON cw.Role_ID = r.Role_ID
WHERE cw.[Year] = @LastYear
GROUP BY
    e.Employee_ID,
    e.Employee_Name,
    e.Employee_Surname
ORDER BY
    Total_Earnings DESC;

-- This query displays all parts that were returned to the store during the last quarter.

DECLARE @LatestReturnDate date;

SELECT @LatestReturnDate = MAX(Return_Date)
FROM dbo.Parts
WHERE Parts_Returned = 1;

SELECT
    Parts_ID,
    Car_VIN,
    Part_Name,
    Parts_Price,
    Parts_Purchase_Date,
    Return_Date,
    Location,
    Parts_Order_Num
FROM dbo.Parts
WHERE Parts_Returned = 1
  AND Return_Date IS NOT NULL
  AND Return_Date >= DATEADD(MONTH, -3, @LatestReturnDate)
ORDER BY Return_Date DESC;


-- Prevents the same vehicle from being sold more than once.

USE UsedCarWholesalerDB;
GO

CREATE TRIGGER TR_PreventDuplicateSale
ON Sale
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM Sale s
        INNER JOIN inserted i
            ON s.Car_VIN = i.Car_VIN
    )
    BEGIN
        RAISERROR('This vehicle has already been sold.',16,1);
        RETURN;
    END;

    INSERT INTO Sale
    (
        Bos_ID,
        Car_VIN,
        Auction_ID,
        Sale_Amount,
        Sale_Fees,
        Employee_ID
    )
    SELECT
        Bos_ID,
        Car_VIN,
        Auction_ID,
        Sale_Amount,
        Sale_Fees,
        Employee_ID
    FROM inserted;
END;
GO

-- This query displays all vehicles purchased using flooring financing and shows the remaining available flooring amount after each purchase.

SELECT
    cp.Buy_Date,
    c.Car_VIN,
    c.Make,
    c.Model,
    c.[Year],
    cp.Price AS Purchase_Price,
    cp.Buy_Fees,
    f.Company_Name,
    f.Amount_Available AS Remaining_Flooring
FROM Car_Purchase cp
INNER JOIN Car c
    ON cp.Car_VIN = c.Car_VIN
INNER JOIN Flooring f
    ON cp.Flooring_ID = f.Flooring_ID
ORDER BY cp.Buy_Date;

-- This view displays all sold vehicles together with their sale amount and the employee responsible for the sale.

CREATE VIEW vw_SoldCars
AS
SELECT
    c.Car_VIN,
    c.Make,
    c.Model,
    c.[Year],
    s.Sale_Amount,
    s.Sale_Fees,
    e.Employee_Name,
    e.Employee_Surname
FROM Sale s
INNER JOIN Car c
    ON s.Car_VIN = c.Car_VIN
INNER JOIN Employees e
    ON s.Employee_ID = e.Employee_ID;
GO