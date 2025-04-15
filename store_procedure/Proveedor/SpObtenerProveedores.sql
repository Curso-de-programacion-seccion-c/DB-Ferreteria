CREATE OR ALTER PROCEDURE ObtenerProveedores
AS
BEGIN
    SELECT IdProveedor, NombreProveedor, Telefono, NombreContacto, IsActive
    FROM Proveedor
    WHERE IsActive = 1
END