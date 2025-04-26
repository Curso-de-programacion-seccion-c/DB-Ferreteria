CREATE PROCEDURE ObtenerArticulos
AS
BEGIN
    SELECT 
        IdArticulo, 
        CodeArticulo,
        Nombre AS NombreArticulo,
        PrecioUnitario AS Precio, 
        Stock, 
        Descripcion,
        IdCategoria, 
        IdProveedor
    FROM Articulos;
END
