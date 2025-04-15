CREATE OR ALTER PROCEDURE ActualizarProveedor
    @IdProveedor SMALLINT,
    @NombreProveedor VARCHAR(128),
    @Telefono VARCHAR(16),
    @NombreContacto VARCHAR(128)
AS
BEGIN
    UPDATE Proveedor
    SET NombreProveedor = @NombreProveedor,
        Telefono = @Telefono,
        NombreContacto = @NombreContacto
    WHERE IdProveedor = @IdProveedor
END
GO