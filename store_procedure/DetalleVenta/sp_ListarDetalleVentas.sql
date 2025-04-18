CREATE OR ALTER PROCEDURE sp_ListarDetalleVentas
    @IdFactura INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        DV.IdDetalleVenta,
        DV.IdFactura,
        DV.IdArticulo,
        DV.Cantidad,
        A.Nombre AS NombreArticulo,
        A.PrecioUnitario,
        F.Fecha AS FechaFactura,
        C.Nombre AS NombreCliente
    FROM DetalleVenta DV
    INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
    INNER JOIN Factura F ON DV.IdFactura = F.IdFactura
    INNER JOIN Clientes C ON F.IdCliente = C.IdCliente
    WHERE DV.IdFactura = @IdFactura

    ORDER BY DV.IdDetalleVenta DESC;
END;
