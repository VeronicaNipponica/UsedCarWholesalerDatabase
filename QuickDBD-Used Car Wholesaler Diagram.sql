-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/Bldj0Q
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


SET XACT_ABORT ON

BEGIN TRANSACTION QUICKDBD

CREATE TABLE [Car_Purchase] (
    [Car_Purchase_ID] char(10)  NOT NULL ,
    [Car_VIN] char(20)  NOT NULL ,
    [Auction_ID] char(5)  NOT NULL ,
    [Buy_Date] date  NOT NULL ,
    [Price] money(3)  NOT NULL ,
    [Buy_Fees] money  NOT NULL ,
    [Reverse_Purchase_ID] char(10)  NOT NULL ,
    [Flooring_ID] char(15)  NOT NULL ,
    [Employee_ID] char(12)  NOT NULL ,
    [Invoice_ID] char(10)  NOT NULL ,
    [Photos] VARBINARY(MAX)  NOT NULL ,
    CONSTRAINT [PK_Car_Purchase] PRIMARY KEY CLUSTERED (
        [Car_Purchase_ID] ASC
    )
)

CREATE TABLE [Car] (
    [Car_VIN] char(20)  NOT NULL ,
    [Make] string  NOT NULL ,
    [Model] string  NOT NULL ,
    [Year] int  NOT NULL ,
    [Color] string  NOT NULL ,
    [Package] varchar  NOT NULL ,
    -- multiple parts
    [Parts_ID] varchar  NOT NULL ,
    CONSTRAINT [PK_Car] PRIMARY KEY CLUSTERED (
        [Car_VIN] ASC
    )
)

-- can be used from the table 'Parts'
CREATE TABLE [Auction] (
    [Auction_ID] char(5)  NOT NULL ,
    [Auction_Name] sting  NOT NULL ,
    [Address] string  NOT NULL ,
    [Auction_Manager] string  NOT NULL ,
    CONSTRAINT [PK_Auction] PRIMARY KEY CLUSTERED (
        [Auction_ID] ASC
    )
)

CREATE TABLE [Purchase_Invoice] (
    [Invoice_ID] char(10)  NOT NULL ,
    [Invoice_Num] char(10)  NOT NULL ,
    [Invoice_Date] date  NOT NULL ,
    [Invoice_Scan] VARBINARY(MAX)  NOT NULL ,
    CONSTRAINT [PK_Purchase_Invoice] PRIMARY KEY CLUSTERED (
        [Invoice_ID] ASC
    )
)

CREATE TABLE [Flooring] (
    [Floring_ID] char(15)  NOT NULL ,
    [Company_Name] string  NOT NULL ,
    [Floor_Manager] string  NOT NULL ,
    [Phone_Mng] char(10)  NOT NULL ,
    [Email_Mng] varchar  NOT NULL ,
    [Floor_Amount] money  NOT NULL ,
    [Amount_Available] money  NOT NULL ,
    [Floor_Date] date  NOT NULL ,
    [Floor_Invoice_Scan] VARBINARY(MAX)  NOT NULL ,
    [Interest] decimal  NOT NULL ,
    CONSTRAINT [PK_Flooring] PRIMARY KEY CLUSTERED (
        [Floring_ID] ASC
    )
)

CREATE TABLE [Bill_Of_Sale] (
    [Bos_ID] char(10)  NOT NULL ,
    [Bos_Num] char(10)  NOT NULL ,
    [Bos_Scan] VARBINARY(MAX)  NOT NULL ,
    CONSTRAINT [PK_Bill_Of_Sale] PRIMARY KEY CLUSTERED (
        [Bos_ID] ASC
    )
)

CREATE TABLE [Sale] (
    [Bos_ID] char(10)  NOT NULL ,
    [Car_VIN] char(20)  NOT NULL ,
    [Auction_ID] char(5)  NOT NULL ,
    [Sale_Amount] money  NOT NULL ,
    [Sale_Fees] money  NOT NULL ,
    [Employee_ID] char(12)  NOT NULL 
)

CREATE TABLE [Reverse_Purchase] (
    [Reverse_Purchase_ID] char(10)  NOT NULL ,
    [Date_of_Reverse] date  NOT NULL ,
    [Reason] string(800)  NOT NULL ,
    [Car_Purchase_ID] char(10)  NOT NULL ,
    [Invoice_ID] char(10)  NOT NULL ,
    CONSTRAINT [PK_Reverse_Purchase] PRIMARY KEY CLUSTERED (
        [Reverse_Purchase_ID] ASC
    )
)

CREATE TABLE [Employees] (
    [Employee_ID] char(12)  NOT NULL ,
    [Employee_Name] string(15)  NOT NULL ,
    [Employee_Surname] string(15)  NOT NULL ,
    [Emp_Phone] char(10)  NOT NULL ,
    [Emp_Email] varchar(25)  NOT NULL ,
    [Emp_Address] varchar  NOT NULL ,
    [License_ID] varchar(10)  NOT NULL ,
    [SSN] varchar  NOT NULL ,
    [DOB] date  NOT NULL ,
    [Role_ID] string  NOT NULL ,
    [Rights_ID] varchar  NOT NULL ,
    [Start_Date] date  NOT NULL ,
    [End_Date] date  NOT NULL ,
    CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED (
        [Employee_ID] ASC
    )
)

CREATE TABLE [Role] (
    [Role_ID] string  NOT NULL ,
    [Role_Name] sting  NOT NULL ,
    [Hour_Rate] money  NOT NULL ,
    [Full_Hours] decimal  NOT NULL ,
    [Role_Description] varchar  NOT NULL ,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED (
        [Role_ID] ASC
    )
)

-- Free plan table limit reached. SUBSCRIBE for more.



ALTER TABLE [Car_Purchase] WITH CHECK ADD CONSTRAINT [FK_Car_Purchase_Car_VIN] FOREIGN KEY([Car_VIN])
REFERENCES [Car] ([Car_VIN])

ALTER TABLE [Car_Purchase] CHECK CONSTRAINT [FK_Car_Purchase_Car_VIN]

ALTER TABLE [Car_Purchase] WITH CHECK ADD CONSTRAINT [FK_Car_Purchase_Auction_ID] FOREIGN KEY([Auction_ID])
REFERENCES [Auction] ([Auction_ID])

ALTER TABLE [Car_Purchase] CHECK CONSTRAINT [FK_Car_Purchase_Auction_ID]

ALTER TABLE [Car_Purchase] WITH CHECK ADD CONSTRAINT [FK_Car_Purchase_Reverse_Purchase_ID] FOREIGN KEY([Reverse_Purchase_ID])
REFERENCES [Reverse_Purchase] ([Reverse_Purchase_ID])

ALTER TABLE [Car_Purchase] CHECK CONSTRAINT [FK_Car_Purchase_Reverse_Purchase_ID]

ALTER TABLE [Car_Purchase] WITH CHECK ADD CONSTRAINT [FK_Car_Purchase_Flooring_ID] FOREIGN KEY([Flooring_ID])
REFERENCES [Flooring] ([Floring_ID])

ALTER TABLE [Car_Purchase] CHECK CONSTRAINT [FK_Car_Purchase_Flooring_ID]

ALTER TABLE [Car_Purchase] WITH CHECK ADD CONSTRAINT [FK_Car_Purchase_Employee_ID] FOREIGN KEY([Employee_ID])
REFERENCES [Employees] ([Employee_ID])

ALTER TABLE [Car_Purchase] CHECK CONSTRAINT [FK_Car_Purchase_Employee_ID]

ALTER TABLE [Car_Purchase] WITH CHECK ADD CONSTRAINT [FK_Car_Purchase_Invoice_ID] FOREIGN KEY([Invoice_ID])
REFERENCES [Purchase_Invoice] ([Invoice_ID])

ALTER TABLE [Car_Purchase] CHECK CONSTRAINT [FK_Car_Purchase_Invoice_ID]

ALTER TABLE [Car] WITH CHECK ADD CONSTRAINT [FK_Car_Parts_ID] FOREIGN KEY([Parts_ID])
REFERENCES [Table 14] ([...])

ALTER TABLE [Car] CHECK CONSTRAINT [FK_Car_Parts_ID]

ALTER TABLE [Sale] WITH CHECK ADD CONSTRAINT [FK_Sale_Bos_ID] FOREIGN KEY([Bos_ID])
REFERENCES [Bill_Of_Sale] ([Bos_ID])

ALTER TABLE [Sale] CHECK CONSTRAINT [FK_Sale_Bos_ID]

ALTER TABLE [Sale] WITH CHECK ADD CONSTRAINT [FK_Sale_Car_VIN] FOREIGN KEY([Car_VIN])
REFERENCES [Car] ([Car_VIN])

ALTER TABLE [Sale] CHECK CONSTRAINT [FK_Sale_Car_VIN]

ALTER TABLE [Sale] WITH CHECK ADD CONSTRAINT [FK_Sale_Auction_ID] FOREIGN KEY([Auction_ID])
REFERENCES [Auction] ([Auction_ID])

ALTER TABLE [Sale] CHECK CONSTRAINT [FK_Sale_Auction_ID]

ALTER TABLE [Sale] WITH CHECK ADD CONSTRAINT [FK_Sale_Employee_ID] FOREIGN KEY([Employee_ID])
REFERENCES [Employees] ([Employee_ID])

ALTER TABLE [Sale] CHECK CONSTRAINT [FK_Sale_Employee_ID]

ALTER TABLE [Reverse_Purchase] WITH CHECK ADD CONSTRAINT [FK_Reverse_Purchase_Car_Purchase_ID] FOREIGN KEY([Car_Purchase_ID])
REFERENCES [Car_Purchase] ([Car_Purchase_ID])

ALTER TABLE [Reverse_Purchase] CHECK CONSTRAINT [FK_Reverse_Purchase_Car_Purchase_ID]

ALTER TABLE [Reverse_Purchase] WITH CHECK ADD CONSTRAINT [FK_Reverse_Purchase_Invoice_ID] FOREIGN KEY([Invoice_ID])
REFERENCES [Purchase_Invoice] ([Invoice_ID])

ALTER TABLE [Reverse_Purchase] CHECK CONSTRAINT [FK_Reverse_Purchase_Invoice_ID]

ALTER TABLE [Employees] WITH CHECK ADD CONSTRAINT [FK_Employees_Role_ID] FOREIGN KEY([Role_ID])
REFERENCES [Role] ([Role_ID])

ALTER TABLE [Employees] CHECK CONSTRAINT [FK_Employees_Role_ID]

ALTER TABLE [Employees] WITH CHECK ADD CONSTRAINT [FK_Employees_Rights_ID] FOREIGN KEY([Rights_ID])
REFERENCES [Table 12] ([...])

ALTER TABLE [Employees] CHECK CONSTRAINT [FK_Employees_Rights_ID]

-- Free plan table limit reached. SUBSCRIBE for more.



-- Free plan table limit reached. SUBSCRIBE for more.



COMMIT TRANSACTION QUICKDBD