--LLAVES FORANEAS ARTICULOS
USE FerreteriaDB

Alter Table Articulos
	Add Constraint FK_Articulos_IdProveedor_Proveedor_IdProveedor
	FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor)

Alter Table Articulos
	Add constraint FK_Articulos_IdCategoria_Categoria_IdCategoria
	FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria)


--LLAVES FORANEAS USUARIO
Alter Table  Usuario
     Add Constraint FK_Usuario_IdRol_Roles_IdRol
	 FOREIGN KEY (IdRol) REFERENCES Roles(IdRol)

Alter Table Usuario
	Add Constraint FK_Usuario_IdEmpleado_Empleados_IdEmpleado
	FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado)


--LLAVES FORANEAS FACTURA
Alter Table Factura
	Add constraint FK_Factura_IdFormaPago_FormaPago_IdFormaPago
	FOREIGN KEY (IdFormaPago) REFERENCES FormaPago(IdFormaPago)

Alter Table Factura
	Add Constraint FK_Factura_IdEmpleado_Empleados_IdEmpleado
	FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado)

Alter Table Factura
	ADD Constraint FK_Clientes_IdCliente_Clientes_IdCliente
	FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente)



--LLAVES FORANEAS DETALLE DE VENTA CON FACTURA
Alter Table DetalleVenta
	Add Constraint FK_DetalleVenta_IdFactura_Factura_IdFactura
	FOREIGN KEY (IdFactura) REFERENCES Factura(IdFactura)

Alter Table DetalleVenta
	Add Constraint FK_DetalleVenta_IdArticulo_Articulos_IdArticulo
	FOREIGN KEY (IdArticulo) REFERENCES Articulos(IdArticulo)


--LLAVES FORANEAS EMPLEADOS
Alter Table Empleados
	Add Constraint FK_Empleados_IdRol_Roles_IdRol
	FOREIGN KEY (IdRol) REFERENCES Roles(IdRol)