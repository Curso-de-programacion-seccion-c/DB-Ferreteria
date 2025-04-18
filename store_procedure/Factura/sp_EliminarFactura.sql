CREATE PROCEDURE sp_EliminarFactura
    @IdFactura INT
AS
BEGIN
    -- Validar existencia
    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 50009, 'No se puede eliminar: la factura no existe', 1;
    END

    IF EXISTS (SELECT 1 FROM DetalleVenta WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 50010, 'No se puede eliminar: la factura tiene detalles asociados', 1;
    END

    DELETE FROM Factura WHERE IdFactura = @IdFactura;
END;
