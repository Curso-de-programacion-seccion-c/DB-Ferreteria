CREATE OR ALTER TRIGGER [dbo].[tr_ActualizarTotalFactura]
ON [dbo].[DetalleVenta]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lista de IdFactura afectadas
    DECLARE @FacturasAfectadas TABLE (IdFactura INT);

    -- INSERTED: Facturas afectadas por inserciones
    INSERT INTO @FacturasAfectadas (IdFactura)
    SELECT DISTINCT IdFactura FROM INSERTED
    WHERE IdFactura IS NOT NULL;

    -- DELETED: Facturas afectadas por eliminaciones
    INSERT INTO @FacturasAfectadas (IdFactura)
    SELECT DISTINCT IdFactura FROM DELETED
    WHERE IdFactura IS NOT NULL;

    -- Actualizar Total_pago por cada factura afectada
    UPDATE F
    SET F.Total_pago = (
        -- Sumar los precios de los artículos de los detalles de venta
        SELECT ISNULL(SUM(DV.Cantidad * A.PrecioUnitario), 0)  -- Si no hay detalles, asigna 0
        FROM DetalleVenta DV
        INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
        WHERE DV.IdFactura = F.IdFactura
    )
    FROM Factura F
    INNER JOIN @FacturasAfectadas FA ON F.IdFactura = FA.IdFactura;
END;
