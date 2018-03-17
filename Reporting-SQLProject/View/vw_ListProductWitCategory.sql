If Exists(Select 1 from Sysobjects Where name ='vw_ListProductWitCategory')
Drop View vw_ListProductWitCategory
go
CREATE VIEW [dbo].[vw_ListProductWitCategory]
	AS 
	SELECT P.*, PC.Name as ProductCategory, PSC.Name as ProductSubCategory
 From 
	Product P Inner Join ProductSubCategory PSC On P.ProductId = PSC.[ProductSubcategoryID]
	Inner Join [dbo].[ProductCategory] PC On  PC.[ProductCategoryID] = PSC.[ProductCategoryID] 

