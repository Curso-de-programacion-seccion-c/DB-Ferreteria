USE FerreteriaDB
GO

-- Insertar Roles (incluyendo administrador)
INSERT INTO Roles (Nombre, Sueldo) VALUES
('Administrador', 9500.00),
('Cajero', 4500.00),
('Bodeguero', 4300.00),
('Vendedor', 4000.00);
GO

-- Insertar Categorías
INSERT INTO Categoria (NombreCategoria) VALUES
('Herramientas'),
('Materiales de Construcción'),
('Pinturas'),
('Electricidad');
GO

-- Insertar Proveedores
INSERT INTO Proveedor (NombreProveedor, Telefono, NombreContacto) VALUES
('Suministros Globales', '50123456', 'Laura Méndez'),
('ConstruMarket', '44112233', 'Pedro López'),
('Pinturas del Sur', '77889900', 'Carla Ruiz'),
('TecnoTools', '66334455', 'Mario García');
GO

-- Insertar Empleados (incluyendo administrador)
INSERT INTO Empleados (Dpi, Nombre, Apellido, Puesto, CorreoElectronico, Telefono, IdRol) VALUES
('1234567890123', 'Luis', 'Martínez', 'Gerente General', 'lmartinez@ferreteria.com', '55550001', 1), -- Administrador
('2345678901234', 'Ana', 'González', 'Cajera', 'agonzalez@ferreteria.com', '55550002', 2),
('3456789012345', 'Carlos', 'Pérez', 'Encargado de Bodega', 'cperez@ferreteria.com', '55550003', 3),
('4567890123456', 'Marta', 'Díaz', 'Vendedora', 'mdiaz@ferreteria.com', '55550004', 4);
GO

-- Insertar Usuario administrador (ligado a empleado administrador)
INSERT INTO Usuario (IdEmpleado, CodigoUsuario, Username, UserPassword) VALUES
(1, 'ADM00001', 'admin', 'admin12345'); -- En producción se debe encriptar
GO

-- Insertar Artículos
INSERT INTO Articulos (CodeArticulo, Nombre, Stock, PrecioUnitario, Descripcion, FechaRegistro, IdProveedor, IdCategoria) VALUES
(1001, 'Martillo Stanley', 20, 75.50, 'Martillo de acero', '2024-12-01', 1, 1),
(1002, 'Clavos 2 pulgadas', 200, 0.10, 'Caja de 100 unidades', '2025-01-15', 2, 2),
(1003, 'Pintura blanca galón', 50, 125.00, 'Pintura vinílica', '2025-02-01', 3, 3),
(1004, 'Destornillador Phillips', 35, 30.75, 'Mango ergonómico', '2025-03-10', 4, 1),
(1005, 'Taladro Black & Decker', 15, 450.00, 'Taladro de 550W', '2025-03-20', 1, 1),
(1006, 'Cemento gris 42.5kg', 100, 98.75, 'Saco de cemento', '2025-03-25', 2, 2),
(1007, 'Brocha 2 pulgadas', 80, 10.50, 'Brocha para pintura', '2025-04-01', 3, 3),
(1008, 'Interruptor doble', 60, 5.25, 'Interruptor blanco', '2025-04-05', 4, 4),
(1009, 'Tornillos 1 pulgada', 250, 0.15, 'Bolsa con 50', '2025-04-10', 1, 2),
(1010, 'Cinta aislante 10m', 90, 7.80, 'Cinta color negro', '2025-04-12', 4, 4);
GO

-- Insertar Formas de Pago
INSERT INTO FormaPago (NombreFormaPago, Descripcion) VALUES
('Efectivo', 'Pago en efectivo'),
('Tarjeta Débito', 'Pago con tarjeta de débito'),
('Tarjeta Crédito', 'Pago con tarjeta de crédito'),
('Transferencia', 'Pago vía transferencia bancaria');
GO

-- Insertar Clientes
INSERT INTO Clientes (Dpi, Nombre, Apellido, NIT, CorreoElectronico, Telefono) VALUES
('7890123456789', 'Juan', 'Ramírez', '1234567-8', 'juan.ramirez@gmail.com', '50110011'),
('8901234567890', 'Sofía', 'Morales', '9876543-2', 'sofia.morales@hotmail.com', '50220022'),
('9012345678901', 'Carlos', 'Hernández', '4567890-1', 'carlos.hernandez@yahoo.com', '50330033'),
('0123456789012', 'María', 'Lopez', '6543210-9', 'maria.lopez@gmail.com', '50440044');
GO

-- Insertar Factura
INSERT INTO Factura (IdEmpleado, IdCliente, Fecha, Total_pago, IdFormaPago) VALUES
(2, 1, '2025-04-15', 150.60, 1),
(4, 2, '2025-04-16', 45.10, 3);
(2, 1, '2025-04-17', 578.25, 2),
(4, 2, '2025-04-17', 114.40, 1),
(3, 1, '2025-04-16', 35.25, 4),
(2, 2, '2025-04-15', 872.10, 3),
(4, 1, '2025-04-14', 310.00, 2);
GO

-- Insertar Detalles de Venta
INSERT INTO DetalleVenta (IdFactura, IdArticulo, Cantidad) VALUES
(1, 1, 1),
(1, 2, 100),
(2, 4, 1);
(3, 5, 1),   -- Taladro
(3, 6, 5),   -- Cemento
(3, 9, 100), -- Tornillos

(4, 7, 3),   -- Brochas
(4, 10, 4),  -- Cintas
(4, 8, 5),   -- Interruptores

(5, 6, 3),   -- Cemento
(5, 9, 200), -- Tornillos

(6, 1, 2),   -- Martillo
(6, 4, 3),   -- Destornillador

(7, 5, 1),   -- Taladro
(7, 2, 50);  -- Clavos
GO
