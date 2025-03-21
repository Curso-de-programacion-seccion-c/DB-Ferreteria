--LLAVES FORANEAS ARTICULOS
USE FerreteriaDB

Alter Table Articulos
	Add Constraint FK_Articulos_IdProveedor_Proveedor_IdProveedor
	FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor)
--LLAVES FORANEAS ARTICULOS
Alter Table Articulos
	Add constraint FK_Articulos_IdCategoria_Categoria_IdCategoria
	FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria)

--LLAVES FORANEAS USUARIO
Alter Table  Usuario
     Add Constraint FK_Usuario_IdRol_Roles_IdRol
	 FOREIGN KEY (IdRol) REFERENCES Roles(IdRol)
--LLAVES FORANEAS FACTURA
Alter Table Factura
	Add constraint FK_Factura_IdFormaPago_FormaPago_IdFormaPago
	FOREIGN KEY (IdFormaPago) REFERENCES FormaPago(IdFormaPago)