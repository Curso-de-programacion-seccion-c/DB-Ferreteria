CREATE PROCEDURE ObtenerArticulos
AS
BEGIN
    SELECT IdArticulo, Nombre, PrecioUnitario AS Precio, Stock, IdCategoria, IdProveedor
    FROM Articulos;
END
