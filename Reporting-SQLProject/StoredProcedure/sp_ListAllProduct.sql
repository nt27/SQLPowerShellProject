If Exists(Select 1 from Sysobjects Where name ='sp_ListAllProduct')
Drop View dbo.sp_ListAllProduct
go
CREATE PROCEDURE [dbo].[sp_ListAllProduct]
AS
Begin
	SELECT * From Product 
End
