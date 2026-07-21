-- This stored procedure adds a new service record for a selected vehicle.

USE UsedCarWholesalerDB;
GO

DROP PROCEDURE IF EXISTS dbo.usp_AddService;
GO

CREATE PROCEDURE dbo.usp_AddService
    @Service_Job varchar(100),
    @Car_VIN char(17),
    @Employee_ID int,
    @Checkin_Date date,
    @Checkout_Date date = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Service
    (
        Service_Job,
        Car_VIN,
        Employee_ID,
        Checkin_Date,
        Checkout_Date
    )
    VALUES
    (
        @Service_Job,
        @Car_VIN,
        @Employee_ID,
        @Checkin_Date,
        @Checkout_Date
    );
END;
GO

-- This stored procedure marks a selected part as returned and records the return date and location.

DROP PROCEDURE IF EXISTS dbo.usp_ReturnPart;
GO

CREATE PROCEDURE dbo.usp_ReturnPart
    @Parts_ID int,
    @Return_Date date,
    @Location varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Parts
    SET
        Parts_Returned = 1,
        Return_Date = @Return_Date,
        Location = @Location
    WHERE Parts_ID = @Parts_ID;
END;
GO


-- This stored procedure closes a service record by adding the checkout date.

DROP PROCEDURE IF EXISTS dbo.usp_CloseService;
GO

CREATE PROCEDURE dbo.usp_CloseService
    @Service_ID int,
    @Checkout_Date date
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Service
    SET Checkout_Date = @Checkout_Date
    WHERE Service_ID = @Service_ID;
END;
GO


-- Calling procedures trough Xact

SQL XACT 