
CREATE OR ALTER PROCEDURE SpObtenerProveedor
    @IdProveedor TINYINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdProveedor,
        IdCategoria,
        NombreProveedor,
        Telefono,
        CorreoElectronico,
        Direccion,
        Estado
    FROM Proveedor
    WHERE IdProveedor = @IdProveedor;
END