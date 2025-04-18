CREATE OR ALTER PROCEDURE sp_BuscarDetalleVentaPorId
    @IdDetalleVenta INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdDetalleVenta = @IdDetalleVenta)
    BEGIN
        THROW 60007, 'No se encontro el detalle de venta con el ID proporcionado', 1;
    END

    SELECT 
        DV.IdDetalleVenta,
        DV.IdFactura,
        DV.IdArticulo,
        DV.Cantidad,
        A.Nombre AS NombreArticulo,
        F.Fecha AS FechaFactura
    FROM DetalleVenta DV
    INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
    INNER JOIN Factura F ON DV.IdFactura = F.IdFactura
    WHERE DV.IdDetalleVenta = @IdDetalleVenta;
END;
