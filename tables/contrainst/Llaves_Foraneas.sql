--LLAVES FORANEAS ARTICULOS
USE FerreteriaDB

Alter Table Articulos
	Add Constraint FK_Articulos_IdProveedor_Proveedor_IdProveedor
	FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor)