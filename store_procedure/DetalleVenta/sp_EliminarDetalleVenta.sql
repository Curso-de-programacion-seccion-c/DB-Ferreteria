CREATE OR ALTER PROCEDURE sp_EliminarDetalleVenta
    @IdDetalleVenta INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdDetalleVenta = @IdDetalleVenta)
    BEGIN
        THROW 60008, 'No se puede eliminar: el detalle de venta no existe', 1;
    END

    DELETE FROM DetalleVenta
    WHERE IdDetalleVenta = @IdDetalleVenta;
END;
