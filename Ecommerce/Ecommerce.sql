USE [master]
GO
/********* Create DB ************/
CREATE DATABASE [Ecommerce] ON PRIMARY
( NAME = N'Ecommerce', FILENAME = N'E:\programming\Backend\Database\DB Projects\Ecommerce\Ecommerce.mdf', 
SIZE = 12288KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024kb )
LOG ON
(NAME = N'Ecommerce_log', FILENAME = N'E:\programming\Backend\Database\DB Projects\Ecommerce\Ecommerce_log.ldf', 
SIZE = 1792KB, MAXSIZE = 2048GB, FILEGROWTH = 10% )
COLLATE Arabic_CI_AS
GO
USE [Ecommerce]
/******** Create Tables **********/
--[1] Customer Table
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers] (
	[customer_id] [int]    NOT NULL,
	[Fname] [nvarchar](20) COLLATE Arabic_CI_AS NOT NULL,
	[Lname] [nvarchar](20) COLLATE Arabic_CI_AS NOT NULL,
	[phone] [varchar](30)  UNIQUE,
	[email] [varchar](50)  UNIQUE NOT NULL,
	[city]  [nvarchar](20) NOT NULL,
	[state] [nvarchar](20),
	CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED
	(
		[customer_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(1, 'Ahmed', 'Khalil', '1234567890', 'ahmed@example.com', 'Cairo', 'Cairo')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(2, 'Mohamed', 'Ahmed', '0987654321', 'mohamed@example.com', 'Alexandria', 'Alexandria')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(3, 'Fatima', 'Ali', '0123456789', 'fatima@example.com', 'Giza', 'Giza')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(4, 'John', 'Doe', '5551234567', 'john.doe@example.com', 'New York', 'NY')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(5, 'Jane', 'Smith', '5559876543', 'jane.smith@example.com', 'Los Angeles', 'CA')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(6, 'Michael', 'Johnson', '5552345678', 'michael.johnson@example.com', 'Chicago', 'IL')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(7, 'Emily', 'Brown', '5558765432', 'emily.brown@example.com', 'Houston', 'TX')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(8, 'William', 'Taylor', '5557654321', 'william.taylor@example.com', 'Phoenix', 'AZ')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(9, 'Sophia', 'Anderson', '5556543210', 'sophia.anderson@example.com', 'Philadelphia', 'PA')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(10, 'Daniel', 'Martinez', '5555432109', 'daniel.martinez@example.com', 'San Antonio', 'TX')
INSERT INTO [dbo].[Customers] ([customer_id], [Fname], [Lname], [phone], [email], [city], [state]) VALUES(11, 'Olivia', 'Garcia', '5554321098', 'olivia.garcia@example.com', 'San Diego', 'CA')

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders] (
	[order_id] [int] NOT NULL,
	[order_status] [nvarchar](20) COLLATE Arabic_CI_AS NOT NULL,
	[order_date] [date] NOT NULL,
	[required_date] [date],
	[shipped_date] [date],
	[customer_id] [int],
	[store_id] [int],
	[staff_id] [int],
	CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED
	(
		[order_id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(1, N'Pending', '2024-03-22', '2024-03-25', NULL, 1, 1, 1)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(2, N'Completed', '2024-03-23', '2024-03-27', '2024-03-25', 2, 2, 2)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(3, N'Processing', '2024-03-24', '2024-03-28', NULL, 3, 3, 3)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(4, N'Shipped', '2024-03-25', '2024-03-29', '2024-03-27', 4, 1, 4)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(5, N'Pending', '2024-03-26', '2024-03-30', NULL, 5, 1, 5)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(6, N'Completed', '2024-03-27', '2024-04-01', '2024-03-31', 6, 1, 6)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(7, N'Processing', '2024-03-28', '2024-04-02', NULL, 7, 3, 7)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(8, N'Shipped', '2024-03-29', '2024-04-03', '2024-04-01', 8, 3, 8)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(9, N'Pending', '2024-03-30', '2024-04-04', NULL, 9, 2, 9)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(10, N'Completed', '2024-03-31', '2024-04-05', '2024-04-03', 10, 1, 10)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(11, N'Processing', '2024-04-01', '2024-04-06', NULL, 11, 3, 11)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(12, N'Shipped', '2024-04-02', '2024-04-07', '2024-04-05', 1, 1, 1)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(13, N'Pending', '2024-04-03', '2024-04-08', NULL, 2, 2, 2)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(14, N'Completed', '2024-04-04', '2024-04-09', '2024-04-07', 3, 2, 3)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(15, N'Processing', '2024-04-05', '2024-04-10', NULL, 4, 1, 4)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(16, N'Shipped', '2024-04-06', '2024-04-11', '2024-04-09', 5, 2, 5)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(17, N'Pending', '2024-04-07', '2024-04-12', NULL, 6, 1, 6)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(18, N'Completed', '2024-04-08', '2024-04-13', '2024-04-11', 7, 3, 7)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(19, N'Processing', '2024-04-09', '2024-04-14', NULL, 8, 3, 8)
INSERT INTO [dbo].[Orders] ([order_id], [order_status], [order_date], [required_date], [shipped_date], [customer_id], [store_id], [staff_id]) VALUES(20, N'Shipped', '2024-04-10', '2024-04-15', '2024-04-13', 9, 2, 9)

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staffs] (
	[staff_id] [int] NOT NULL,
	[Fname] [nvarchar](20) COLLATE Arabic_CI_AS NOT NULL,
	[Lname] [nvarchar](20) COLLATE Arabic_CI_AS NOT NULL,
	[email] [varchar](60) UNIQUE,
	[phone] [varchar](40) UNIQUE NOT NULL,
	[store_id] [int],
	[manager_id] [int] NOT NULL,
	CONSTRAINT [PK_Staffs] PRIMARY KEY CLUSTERED
	(
		[staff_id] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(1, 'John', 'Doe', 'johndoe@example.com', '123-456-7890', 1, 1)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(2, 'Jane', 'Smith', 'janesmith@example.com', '234-567-8901', 2, 2)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(3, 'Michael', 'Johnson', 'michaeljohnson@example.com', '345-678-9012', 3, 3)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(4, 'Emily', 'Brown', 'emily.brown@example.com', '456-789-0123', 3, 1)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(5, 'David', 'Wilson', 'david.wilson@example.com', '567-890-1234', 1, 2)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(6, 'Sarah', 'Jones', 'sarah.jones@example.com', '678-901-2345', 2, 3)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(7, 'James', 'Taylor', 'james.taylor@example.com', '789-012-3456', 3, 1)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(8, 'Emma', 'Martinez', 'emma.martinez@example.com', '890-123-4567', 1, 2)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(9, 'Christopher', 'Anderson', 'christopher.anderson@example.com', '901-234-5678', 1, 3)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(10, 'Olivia', 'Lopez', 'olivia.lopez@example.com', '012-345-6789', 3, 1)
INSERT INTO [dbo].[Staffs] ([staff_id], [Fname], [Lname], [email], [phone], [store_id], [manager_id]) VALUES(11, 'Daniel', 'Hernandez', 'daniel.hernandez@example.com', '098-765-4321', 2, 2)

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stores] (
	[store_id] [int] NOT NULL,
	[store_name] [varchar](20) NOT NULL,
	[phone] [varchar](50) UNIQUE,
	[email] [varchar](50) UNIQUE NOT NULL,
	[street] [nvarchar](50) COLLATE Arabic_CI_AS NOT NULL,
	[city] [nvarchar](30) COLLATE Arabic_CI_AS NOT NULL,
	[state] [nvarchar](20) COLLATE Arabic_CI_AS NOT NULL,
	CONSTRAINT [PK_Stores] PRIMARY KEY CLUSTERED 
	(
		[store_id] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO 
INSERT INTO Stores ([store_id], [store_name], [phone], [email], [street], [city], [state]) VALUES(1, 'First Store', '123-456-7890', 'firststore@example.com', N'First Street', N'First City', N'First State')
INSERT INTO Stores ([store_id], [store_name], [phone], [email], [street], [city], [state]) VALUES(2, 'Second Store', '234-567-8901', 'secondstore@example.com', N'Second Street', N'Second City', N'Second State')
INSERT INTO Stores ([store_id], [store_name], [phone], [email], [street], [city], [state]) VALUES(3, 'Third Store', '345-678-9012', 'thirdstore@example.com', N'Third Street', N'Third City', N'Third State')

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_items] (
	[item_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal] NOT NULL,
	[discount] [decimal](2,2) NOT NULL,
	[order_id] [int] NOT NULL,
	[product_id] [int],
	CONSTRAINT [PK_Order_items] PRIMARY KEY CLUSTERED 
	(
		[item_id] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO 
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(1, 1, 10.50, 0.10, 1, 1)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(2, 2, 20.25, 0.05, 2, 2)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(3, 3, 30.75, 0.15, 3, 3)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(4, 4, 40.80, 0.20, 4, 4)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(5, 5, 50.90, 0.25, 5, 5)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(6, 6, 60.60, 0.30, 6, 6)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(7, 7, 70.35, 0.35, 7, 7)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(8, 8, 80.40, 0.40, 8, 8)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(9, 9, 90.45, 0.45, 9, 9)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(10, 10, 100.20, 0.50, 10, 10)
INSERT INTO Order_items ([item_id], [quantity], [price], [discount], [order_id], [product_id]) VALUES(11, 11, 110.55, 0.55, 11, 11)

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories] (
	[category_id] [int] NOT NULL,
	[category_name] [varchar](20) NOT NULL,
	CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
	(
		[category_id] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO 
INSERT INTO Categories ([category_id], [category_name]) VALUES(1, 'Category 1')
INSERT INTO Categories ([category_id], [category_name]) VALUES(2, 'Category 2')
INSERT INTO Categories ([category_id], [category_name]) VALUES(3, 'Category 3')
INSERT INTO Categories ([category_id], [category_name]) VALUES(4, 'Category 4')
INSERT INTO Categories ([category_id], [category_name]) VALUES(5, 'Category 5')

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products] (
	[product_id] [int] NOT NULL,
	[product_name] [varchar](20) NOT NULL,
	[model_year] [int] NOT NULL,
	[price] [decimal] NOT NULL,
	[category_id] [int] NOT NULL,
	[brand_id] [int] NOT NULL
	CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
	(
		[product_id] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO 
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(1, 'Product 1', 2022, 100.00, 1, 1)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(2, 'Product 2', 2021, 150.00, 2, 2)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(3, 'Product 3', 2023, 200.00, 3, 3)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(4, 'Product 4', 2022, 120.00, 4, 3)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(5, 'Product 5', 2020, 80.00, 5, 1)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(6, 'Product 6', 2021, 130.00, 1, 1)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(7, 'Product 7', 2022, 180.00, 2, 2)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(8, 'Product 8', 2020, 220.00, 3, 3)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(9, 'Product 9', 2023, 140.00, 4, 2)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(10, 'Product 10', 2021, 90.00, 5, 2)
INSERT INTO Products ([product_id], [product_name], [model_year], [price], [category_id], [brand_id]) VALUES(11, 'Product 11', 2022, 160.00, 1, 1)

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brands] (
	[brand_id] [int] IDENTITY(1,1) NOT NULL,
	[brand_name] [varchar](20) NOT NULL,
	CONSTRAINT [PK_Brands] PRIMARY KEY CLUSTERED 
	(
		[brand_id] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO 
INSERT INTO Brands ([brand_name]) VALUES('Brand 1')
INSERT INTO Brands ([brand_name]) VALUES('Brand 2')
INSERT INTO Brands ([brand_name]) VALUES('Brand 3')

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stocks] (
	[store_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	CONSTRAINT [PK_Stocks] PRIMARY KEY CLUSTERED 
	(
		[store_id] ASC,
		[product_id] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO 
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(1, 1, 10)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(2, 2, 20)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(3, 3, 30)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(1, 4, 40)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(2, 5, 50)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(3, 6, 60)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(1, 7, 70)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(2, 8, 80)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(3, 9, 90)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(1, 10, 100)
INSERT INTO Stocks ([store_id], [product_id], [quantity]) VALUES(2, 11, 110)


ALTER TABLE [dbo].[Orders] 
ADD CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([customer_id])
REFERENCES [dbo].[Customers]([customer_id]);
GO
ALTER TABLE [dbo].[Orders]
ADD CONSTRAINT [FK_Orders_Stores] FOREIGN KEY([store_id])
REFERENCES [dbo].[Stores]([store_id]);
GO
ALTER TABLE [dbo].[Orders] 
ADD CONSTRAINT [FK_Orders_Staffs] FOREIGN KEY([staff_id])
REFERENCES [dbo].[Staffs]([staff_id]);
GO


ALTER TABLE [dbo].[Order_items]
ADD CONSTRAINT [FK_Order_items_Orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders]([order_id]);
GO
ALTER TABLE [dbo].[Order_items] 
ADD CONSTRAINT [FK_Order_items_Products] FOREIGN KEY([product_id])
REFERENCES [dbo].[Products]([product_id]);
GO

ALTER TABLE [dbo].[Staffs]
ADD CONSTRAINT [FK_Staffs_Stores] FOREIGN KEY([store_id])
REFERENCES [dbo].[Stores]([store_id]);
GO
ALTER TABLE [dbo].[Staffs]
ADD CONSTRAINT [FK_Staffs_Manager] FOREIGN KEY([manager_id])
REFERENCES [dbo].[Staffs]([staff_id]);
GO

ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [FK_Products_Categories] FOREIGN KEY([category_id])
REFERENCES [dbo].[Categories]([category_id]);
GO
ALTER TABLE [dbo].[Products] 
ADD CONSTRAINT [FK_Products_Brands] FOREIGN KEY([brand_id])
REFERENCES [dbo].[Brands]([brand_id]);
GO

ALTER TABLE [dbo].[Stocks] 
ADD CONSTRAINT [FK_Stocks_Products] FOREIGN KEY([product_id])
REFERENCES [dbo].[Products]([product_id]);
GO
ALTER TABLE [dbo].[Stocks]
ADD CONSTRAINT [FK_Stocks_Stores] FOREIGN KEY([store_id])
REFERENCES [dbo].[Stores]([store_id]);
GO