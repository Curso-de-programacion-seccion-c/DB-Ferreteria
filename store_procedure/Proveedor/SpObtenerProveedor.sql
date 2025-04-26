
CREATE OR ALTER PROCEDURE SpObtenerProveedor
    @IdProveedor TINYINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdProveedor,
        NombreProveedor,
        Telefono,
        NombreContacto
    FROM Proveedor
    WHERE IdProveedor = @IdProveedor;
END