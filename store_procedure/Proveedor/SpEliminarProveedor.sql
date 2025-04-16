CREATE OR ALTER PROCEDURE EliminarProveedor
    @IdProveedor SMALLINT
AS
BEGIN
    DELETE FROM Proveedor WHERE IdProveedor = @IdProveedor
END
GO