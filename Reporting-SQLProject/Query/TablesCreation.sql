USE [AWProduct]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 3/17/2018 6:19:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
If Not Exists(Select 'X' From Sysobjects Where name = 'Product')
Begin
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[Color] [nvarchar](15) NULL,
	[Weight] [decimal](8, 2) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ProductSubcategoryID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[ListPrice] [money] NOT NULL
) ON [PRIMARY]
End
GO
/****** Object:  Table [dbo].[ProductCategory]    Script Date: 3/17/2018 6:19:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
If Not Exists(Select 'X' From Sysobjects Where name = 'ProductCategory')
Begin
CREATE TABLE [dbo].[ProductCategory](
	[ProductCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[rowguid] [uniqueidentifier] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
End
GO
/****** Object:  Table [dbo].[ProductSubcategory]    Script Date: 3/17/2018 6:19:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
If Not Exists(Select 'X' From Sysobjects Where name = 'ProductSubcategory')
Begin
CREATE TABLE [dbo].[ProductSubcategory](
	[ProductSubcategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategoryID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[rowguid] [uniqueidentifier] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
End
GO
