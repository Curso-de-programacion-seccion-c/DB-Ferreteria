CREATE OR ALTER PROCEDURE sp_InsertarDetalleVenta
    @IdFactura INT,
    @IdArticulo INT,
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 60001, 'No se puede agregar el detalle: la factura no existe', 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Articulos WHERE IdArticulo = @IdArticulo)
    BEGIN
        THROW 60002, 'No se puede agregar el detalle: el artículo no existe', 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Articulos WHERE IdArticulo = @IdArticulo AND Stock >= @Cantidad)
    BEGIN
        THROW 60003, 'No se puede agregar el detalle: no hay suficiente stock', 1;
    END

    INSERT INTO DetalleVenta (IdFactura, IdArticulo, Cantidad)
    VALUES (@IdFactura, @IdArticulo, @Cantidad);

    SELECT TOP 1 DV.IdDetalleVenta, DV.IdFactura, DV.IdArticulo, DV.Cantidad,
           A.Nombre AS NombreArticulo, A.Stock
    FROM DetalleVenta DV
    INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
    WHERE DV.IdFactura = @IdFactura AND DV.IdArticulo = @IdArticulo
    ORDER BY DV.IdDetalleVenta DESC;
END;
