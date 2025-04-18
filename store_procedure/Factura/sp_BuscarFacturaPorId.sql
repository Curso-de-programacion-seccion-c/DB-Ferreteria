CREATE OR ALTER PROCEDURE sp_BuscarFacturaPorId
    @IdFactura INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 50010, 'No se encontro la factura con el ID proporcionado', 1;
    END

    SELECT
        F.IdFactura,
        F.Fecha,
        F.Total_pago,

        -- Empleado
        E.IdEmpleado,
        E.Nombre AS NombreEmpleado,

        -- Cliente
        C.IdCliente,
        C.Nombre AS NombreCliente,

        -- Forma de Pago
        FP.IdFormaPago,
        FP.NombreFormaPago AS NombreFormaPago

    FROM Factura F
    INNER JOIN Empleados E ON F.IdEmpleado = E.IdEmpleado
    INNER JOIN Clientes C ON F.IdCliente = C.IdCliente
    INNER JOIN FormaPago FP ON F.IdFormaPago = FP.IdFormaPago
    WHERE F.IdFactura = @IdFactura;
END;