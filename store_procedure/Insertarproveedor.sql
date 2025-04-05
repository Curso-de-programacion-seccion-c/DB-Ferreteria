CREATE OR ALTER PROCEDURE InsertarProveedor
    @NombreProveedor VARCHAR(128),
    @Telefono VARCHAR(16),
    @NombreContacto VARCHAR(128)
AS
BEGIN
    INSERT INTO Proveedor (NombreProveedor, Telefono, NombreContacto, IsActive)
    VALUES (@NombreProveedor, @Telefono, @NombreContacto, 1)
END
GO
