If Exists(Select 1 from Sysobjects Where name ='GetListPrice')
Drop Function dbo.[GetListPrice]
go
CREATE FUNCTION [dbo].[GetListPrice]
(
	@ProductId int
)
RETURNS TABLE AS RETURN
(
SELECT Color as ProductColor From Product Where ProductId = @ProductId
)
