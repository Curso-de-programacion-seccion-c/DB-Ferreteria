CREATE OR ALTER PROCEDURE ObtenerProveedores
AS
BEGIN
    SELECT IdProveedor, NombreProveedor, Telefono, NombreContacto
    FROM Proveedor
END