--Database Creation
If Not Exists (Select * from sysdatabases where name ='AWProduct')
Begin
	Create Database AWProduct
End;
