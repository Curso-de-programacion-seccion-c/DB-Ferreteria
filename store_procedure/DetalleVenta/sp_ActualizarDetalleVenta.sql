CREATE OR ALTER PROCEDURE sp_ActualizarDetalleVenta
    @IdDetalleVenta INT,
    @IdArticulo INT,
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdDetalleVenta = @IdDetalleVenta)
    BEGIN
        THROW 60004, 'No se puede actualizar: el detalle de venta no existe', 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Articulos WHERE IdArticulo = @IdArticulo)
    BEGIN
        THROW 60006, 'No se puede actualizar: el artículo no existe', 1;
    END

    DECLARE @CantidadAnterior INT;

    SELECT @CantidadAnterior = Cantidad
    FROM DetalleVenta
    WHERE IdDetalleVenta = @IdDetalleVenta;

    -- Validar stock solo si la nueva cantidad es mayor
    IF @Cantidad > @CantidadAnterior
    BEGIN
        DECLARE @StockActual INT;
        SELECT @StockActual = Stock FROM Articulos WHERE IdArticulo = @IdArticulo;

        IF (@Cantidad - @CantidadAnterior) > @StockActual
        BEGIN
            THROW 60007, 'No se puede actualizar: stock insuficiente para la nueva cantidad', 1;
        END
    END

    UPDATE DetalleVenta
    SET
        IdArticulo = @IdArticulo,
        Cantidad = @Cantidad
    WHERE IdDetalleVenta = @IdDetalleVenta;

    SELECT DV.IdDetalleVenta, DV.IdFactura, DV.IdArticulo, DV.Cantidad,
           A.Nombre AS NombreArticulo, A.Stock
    FROM DetalleVenta DV
    INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
    WHERE DV.IdDetalleVenta = @IdDetalleVenta;
END;
