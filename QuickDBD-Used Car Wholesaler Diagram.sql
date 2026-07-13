-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to original schema: https://app.quickdatabasediagrams.com/#/d/Bldj0Q
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE [Role] (
        [Role_ID] varchar(20) NOT NULL,
        [Role_Name] nvarchar(100) NOT NULL,
        [Hour_Rate] decimal(10,2) NOT NULL,
        [Full_Hours] decimal(6,2) NOT NULL,
        [Role_Description] nvarchar(500) NOT NULL,
        CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED (
            [Role_ID] ASC
        )
    );

    CREATE TABLE [Access_Rights_Assigned] (
        [Rights_ID] varchar(20) NOT NULL,
        [Rights_Level] int NOT NULL,
        [Level_Description] nvarchar(500) NOT NULL,
        CONSTRAINT [PK_Access_Rights_Assigned] PRIMARY KEY CLUSTERED (
            [Rights_ID] ASC
        ),
        CONSTRAINT [UQ_Access_Rights_Assigned_Level]
            UNIQUE ([Rights_Level]),
        CONSTRAINT [CK_Access_Rights_Assigned_Level]
            CHECK ([Rights_Level] >= 0)
    );

    CREATE TABLE [Employees] (
        [Employee_ID] char(12) NOT NULL,
        [Employee_Name] nvarchar(50) NOT NULL,
        [Employee_Surname] nvarchar(50) NOT NULL,
        [Emp_Phone] varchar(20) NOT NULL,
        [Emp_Email] varchar(100) NOT NULL,
        [Emp_Address] nvarchar(200) NOT NULL,
        [License_ID] varchar(20) NOT NULL,
        [SSN] varchar(20) NOT NULL,
        [DOB] date NOT NULL,
        [Role_ID] varchar(20) NOT NULL,
        [Rights_ID] varchar(20) NOT NULL,
        [Start_Date] date NOT NULL,
        [End_Date] date NULL,
        CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED (
            [Employee_ID] ASC
        ),
        CONSTRAINT [UQ_Employees_Email]
            UNIQUE ([Emp_Email]),
        CONSTRAINT [FK_Employees_Role_ID]
            FOREIGN KEY ([Role_ID])
            REFERENCES [Role] ([Role_ID]),
        CONSTRAINT [FK_Employees_Rights_ID]
            FOREIGN KEY ([Rights_ID])
            REFERENCES [Access_Rights_Assigned] ([Rights_ID]),
        CONSTRAINT [CK_Employees_Dates]
            CHECK ([End_Date] IS NULL OR [End_Date] >= [Start_Date])
    );

    CREATE TABLE [Auction] (
        [Auction_ID] char(5) NOT NULL,
        [Auction_Name] nvarchar(100) NOT NULL,
        [Address] nvarchar(200) NOT NULL,
        [Auction_Manager] nvarchar(100) NOT NULL,
        CONSTRAINT [PK_Auction] PRIMARY KEY CLUSTERED (
            [Auction_ID] ASC
        )
    );

    CREATE TABLE [Purchase_Invoice] (
        [Invoice_ID] char(10) NOT NULL,
        [Invoice_Num] varchar(30) NOT NULL,
        [Invoice_Date] date NOT NULL,
        [Invoice_Scan] varbinary(max) NULL,
        CONSTRAINT [PK_Purchase_Invoice] PRIMARY KEY CLUSTERED (
            [Invoice_ID] ASC
        ),
        CONSTRAINT [UQ_Purchase_Invoice_Num]
            UNIQUE ([Invoice_Num])
    );

    CREATE TABLE [Flooring] (
        [Flooring_ID] char(15) NOT NULL,
        [Company_Name] nvarchar(100) NOT NULL,
        [Floor_Manager] nvarchar(100) NOT NULL,
        [Phone_Mng] varchar(20) NOT NULL,
        [Email_Mng] varchar(100) NOT NULL,
        [Floor_Amount] decimal(12,2) NOT NULL,
        [Amount_Available] decimal(12,2) NOT NULL,
        [Floor_Date] date NOT NULL,
        [Floor_Invoice_Scan] varbinary(max) NULL,
        [Interest] decimal(5,2) NOT NULL,
        CONSTRAINT [PK_Flooring] PRIMARY KEY CLUSTERED (
            [Flooring_ID] ASC
        ),
        CONSTRAINT [CK_Flooring_Amounts]
            CHECK (
                [Floor_Amount] >= 0
                AND [Amount_Available] >= 0
                AND [Amount_Available] <= [Floor_Amount]
            ),
        CONSTRAINT [CK_Flooring_Interest]
            CHECK ([Interest] >= 0)
    );

    CREATE TABLE [Car] (
        [Car_VIN] char(17) NOT NULL,
        [Make] nvarchar(50) NOT NULL,
        [Model] nvarchar(50) NOT NULL,
        [Year] smallint NOT NULL,
        [Color] nvarchar(30) NOT NULL,
        [Package] nvarchar(100) NULL,
        CONSTRAINT [PK_Car] PRIMARY KEY CLUSTERED (
            [Car_VIN] ASC
        ),
        CONSTRAINT [CK_Car_Year]
            CHECK ([Year] BETWEEN 1886 AND 2100)
    );

    CREATE TABLE [Bill_Of_Sale] (
        [Bos_ID] char(10) NOT NULL,
        [Bos_Num] varchar(30) NOT NULL,
        [Bos_Scan] varbinary(max) NULL,
        CONSTRAINT [PK_Bill_Of_Sale] PRIMARY KEY CLUSTERED (
            [Bos_ID] ASC
        ),
        CONSTRAINT [UQ_Bill_Of_Sale_Num]
            UNIQUE ([Bos_Num])
    );

    CREATE TABLE [Car_Purchase] (
        [Car_Purchase_ID] char(10) NOT NULL,
        [Car_VIN] char(17) NOT NULL,
        [Auction_ID] char(5) NOT NULL,
        [Buy_Date] date NOT NULL,
        [Price] decimal(12,2) NOT NULL,
        [Buy_Fees] decimal(10,2) NOT NULL,
        [Reverse_Purchase_ID] char(10) NULL,
        [Flooring_ID] char(15) NULL,
        [Employee_ID] char(12) NOT NULL,
        [Invoice_ID] char(10) NOT NULL,
        [Photos] varbinary(max) NULL,
        CONSTRAINT [PK_Car_Purchase] PRIMARY KEY CLUSTERED (
            [Car_Purchase_ID] ASC
        ),
        CONSTRAINT [FK_Car_Purchase_Car]
            FOREIGN KEY ([Car_VIN])
            REFERENCES [Car] ([Car_VIN]),
        CONSTRAINT [FK_Car_Purchase_Auction]
            FOREIGN KEY ([Auction_ID])
            REFERENCES [Auction] ([Auction_ID]),
        CONSTRAINT [FK_Car_Purchase_Flooring]
            FOREIGN KEY ([Flooring_ID])
            REFERENCES [Flooring] ([Flooring_ID]),
        CONSTRAINT [FK_Car_Purchase_Employee]
            FOREIGN KEY ([Employee_ID])
            REFERENCES [Employees] ([Employee_ID]),
        CONSTRAINT [FK_Car_Purchase_Invoice]
            FOREIGN KEY ([Invoice_ID])
            REFERENCES [Purchase_Invoice] ([Invoice_ID]),
        CONSTRAINT [CK_Car_Purchase_Amounts]
            CHECK ([Price] >= 0 AND [Buy_Fees] >= 0)
    );

    CREATE TABLE [Reverse_Purchase] (
        [Reverse_Purchase_ID] char(10) NOT NULL,
        [Date_of_Reverse] date NOT NULL,
        [Reason] nvarchar(800) NOT NULL,
        [Car_Purchase_ID] char(10) NOT NULL,
        [Invoice_ID] char(10) NOT NULL,
        CONSTRAINT [PK_Reverse_Purchase] PRIMARY KEY CLUSTERED (
            [Reverse_Purchase_ID] ASC
        ),
        CONSTRAINT [UQ_Reverse_Purchase_Car_Purchase]
            UNIQUE ([Car_Purchase_ID]),
        CONSTRAINT [FK_Reverse_Purchase_Car_Purchase]
            FOREIGN KEY ([Car_Purchase_ID])
            REFERENCES [Car_Purchase] ([Car_Purchase_ID]),
        CONSTRAINT [FK_Reverse_Purchase_Invoice]
            FOREIGN KEY ([Invoice_ID])
            REFERENCES [Purchase_Invoice] ([Invoice_ID])
    );

    ALTER TABLE [Car_Purchase]
        ADD CONSTRAINT [FK_Car_Purchase_Reverse_Purchase]
        FOREIGN KEY ([Reverse_Purchase_ID])
        REFERENCES [Reverse_Purchase] ([Reverse_Purchase_ID]);

    CREATE TABLE [Sale] (
        [Sale_ID] int IDENTITY(1,1) NOT NULL,
        [Bos_ID] char(10) NOT NULL,
        [Car_VIN] char(17) NOT NULL,
        [Auction_ID] char(5) NOT NULL,
        [Sale_Amount] decimal(12,2) NOT NULL,
        [Sale_Fees] decimal(10,2) NOT NULL,
        [Employee_ID] char(12) NOT NULL,
        CONSTRAINT [PK_Sale] PRIMARY KEY CLUSTERED (
            [Sale_ID] ASC
        ),
        CONSTRAINT [UQ_Sale_Bos_ID]
            UNIQUE ([Bos_ID]),
        CONSTRAINT [FK_Sale_Bill_Of_Sale]
            FOREIGN KEY ([Bos_ID])
            REFERENCES [Bill_Of_Sale] ([Bos_ID]),
        CONSTRAINT [FK_Sale_Car]
            FOREIGN KEY ([Car_VIN])
            REFERENCES [Car] ([Car_VIN]),
        CONSTRAINT [FK_Sale_Auction]
            FOREIGN KEY ([Auction_ID])
            REFERENCES [Auction] ([Auction_ID]),
        CONSTRAINT [FK_Sale_Employee]
            FOREIGN KEY ([Employee_ID])
            REFERENCES [Employees] ([Employee_ID]),
        CONSTRAINT [CK_Sale_Amounts]
            CHECK ([Sale_Amount] >= 0 AND [Sale_Fees] >= 0)
    );

    CREATE TABLE [Completed_Work] (
        [Work_ID] int IDENTITY(1,1) NOT NULL,
        [Employee_ID] char(12) NOT NULL,
        [Worked_Hours] decimal(6,2) NOT NULL,
        [Month] tinyint NOT NULL,
        [Year] smallint NOT NULL,
        [Role_ID] varchar(20) NOT NULL,
        [Bonuses] decimal(10,2) NOT NULL
            CONSTRAINT [DF_Completed_Work_Bonuses] DEFAULT (0),
        [Days_Off] decimal(4,1) NOT NULL
            CONSTRAINT [DF_Completed_Work_Days_Off] DEFAULT (0),
        [Sick_Leave] decimal(4,1) NOT NULL
            CONSTRAINT [DF_Completed_Work_Sick_Leave] DEFAULT (0),
        CONSTRAINT [PK_Completed_Work] PRIMARY KEY CLUSTERED (
            [Work_ID] ASC
        ),
        CONSTRAINT [FK_Completed_Work_Employees]
            FOREIGN KEY ([Employee_ID])
            REFERENCES [Employees] ([Employee_ID]),
        CONSTRAINT [FK_Completed_Work_Role]
            FOREIGN KEY ([Role_ID])
            REFERENCES [Role] ([Role_ID]),
        CONSTRAINT [CK_Completed_Work_Month]
            CHECK ([Month] BETWEEN 1 AND 12),
        CONSTRAINT [CK_Completed_Work_Hours]
            CHECK (
                [Worked_Hours] >= 0
                AND [Days_Off] >= 0
                AND [Sick_Leave] >= 0
            ),
        CONSTRAINT [UQ_Completed_Work_Employee_Period]
            UNIQUE ([Employee_ID], [Month], [Year])
    );

    CREATE TABLE [Service] (
        [Service_ID] varchar(15) NOT NULL,
        [Service_Job] nvarchar(800) NOT NULL,
        [Car_VIN] char(17) NOT NULL,
        [Employee_ID] char(12) NOT NULL,
        [Checkin_Date] date NOT NULL,
        [Checkout_Date] date NULL,
        CONSTRAINT [PK_Service] PRIMARY KEY CLUSTERED (
            [Service_ID] ASC
        ),
        CONSTRAINT [FK_Service_Car]
            FOREIGN KEY ([Car_VIN])
            REFERENCES [Car] ([Car_VIN]),
        CONSTRAINT [FK_Service_Employees]
            FOREIGN KEY ([Employee_ID])
            REFERENCES [Employees] ([Employee_ID]),
        CONSTRAINT [CK_Service_Dates]
            CHECK (
                [Checkout_Date] IS NULL
                OR [Checkout_Date] >= [Checkin_Date]
            )
    );

    CREATE TABLE [Parts] (
        [Parts_ID] varchar(15) NOT NULL,
        [Car_VIN] char(17) NULL,
        [Part_Name] nvarchar(100) NOT NULL,
        [Parts_Price] decimal(10,2) NOT NULL,
        [Parts_Purchase_Date] date NOT NULL,
        [Parts_Returned] bit NOT NULL
            CONSTRAINT [DF_Parts_Returned] DEFAULT (0),
        [Return_Date] date NULL,
        [Location] nvarchar(100) NOT NULL,
        [Parts_Order_Num] varchar(30) NOT NULL,
        [Parts_Invoice_Scan] varbinary(max) NULL,
        CONSTRAINT [PK_Parts] PRIMARY KEY CLUSTERED (
            [Parts_ID] ASC
        ),
        CONSTRAINT [UQ_Parts_Order_Num]
            UNIQUE ([Parts_Order_Num]),
        CONSTRAINT [FK_Parts_Car]
            FOREIGN KEY ([Car_VIN])
            REFERENCES [Car] ([Car_VIN]),
        CONSTRAINT [CK_Parts_Price]
            CHECK ([Parts_Price] >= 0),
        CONSTRAINT [CK_Parts_Return_Date]
            CHECK (
                ([Parts_Returned] = 0 AND [Return_Date] IS NULL)
                OR
                (
                    [Parts_Returned] = 1
                    AND [Return_Date] IS NOT NULL
                    AND [Return_Date] >= [Parts_Purchase_Date]
                )
            )
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
