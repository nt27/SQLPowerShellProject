If Exists(Select 1 from Sysobjects Where name ='sp_ListAllProductWithCategory')
Drop PROCEDURE dbo.sp_ListAllProductWithCategory
go
CREATE PROCEDURE [dbo].sp_ListAllProductWithCategory
AS
Begin
	
SELECT P.*, PC.Name as ProductCategory, PSC.Name as ProductSubCategory
 From Product P Inner Join ProductSubCategory PSC On P.ProductId = PSC.[ProductSubcategoryID]
Inner Join [dbo].[ProductCategory] PC On PSC.[ProductCategoryID] = PC.[ProductCategoryID]

End;

