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

--LLAVES FORANEAS DETALLE DE VENTA CON FACTURA
Alter Table DetalleVenta
	Add Constraint FK_DetalleVenta_IdFactura_Factura_IdFactura
	FOREIGN KEY (IdFactura) REFERENCES Factura(IdFactura)

--LLAVES FORANEAS DETALLE DE VENTA CON ARTICULO
Alter Table DetalleVenta
	Add Constraint FK_DetalleVenta_IdArticulo_Articulos_IdArticulo
	FOREIGN KEY (IdArticulo) REFERENCES Articulos(IdArticulo)