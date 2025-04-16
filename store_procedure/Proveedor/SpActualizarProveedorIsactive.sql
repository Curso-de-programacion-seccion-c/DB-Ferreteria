CREATE OR ALTER PROCEDURE ActualizarProveedorIsActive
    @IdProveedor SMALLINT,
    @IsActive BIT
AS
BEGIN
    UPDATE Proveedor
    SET IsActive = @IsActive
    WHERE IdProveedor = @IdProveedor
END
GO