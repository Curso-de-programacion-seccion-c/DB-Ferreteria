CREATE OR ALTER PROCEDURE sp_ReporteFacturaPorId
    @IdFactura INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 70001, 'No se encontró la factura con el ID proporcionado', 1;
    END

    SELECT
        F.IdFactura,
        F.Fecha,
        F.Total_pago,
        -- Cliente
        CL.IdCliente,
        CONCAT(CL.Nombre, ' ', CL.Apellido) AS NombreCliente,
        CL.Telefono,
        CL.NIT AS NitCliente,
        CL.Dpi AS DpiCliente,
        -- Empleado
        EMP.IdEmpleado,
        CONCAT(EMP.Nombre, ' ', EMP.Apellido) AS NombreEmpleado,
        EMP.Dpi AS DpiEmpleado,
        EMP.Puesto,
        EMP.CorreoElectronico AS EmailEmpleado,
        RolEmpleado.Nombre AS RolDelEmpleado,
        -- Forma de Pago
        FP.NombreFormaPago, -- Cambiado alias para consistencia con el JSON
        -- Artículos vendidos
        DV.IdDetalleVenta,
        ART.IdArticulo,
        ART.Nombre AS NombreArticulo,
        ART.PrecioUnitario,
        DV.Cantidad,
        -- Cálculos adicionales
        (ART.PrecioUnitario * DV.Cantidad) AS Subtotal,
        -- Incluir información de impuestos (asumiendo tasa de IVA del 12%)
        CAST(ART.PrecioUnitario / 1.12 AS DECIMAL(10,2)) AS PrecioSinIVA,
        CAST((ART.PrecioUnitario / 1.12) * 0.12 AS DECIMAL(10,2)) AS IVA
    FROM Factura F
    INNER JOIN Clientes CL ON F.IdCliente = CL.IdCliente
    INNER JOIN Empleados EMP ON F.IdEmpleado = EMP.IdEmpleado
    INNER JOIN Roles RolEmpleado ON EMP.IdRol = RolEmpleado.IdRol
    INNER JOIN FormaPago FP ON F.IdFormaPago = FP.IdFormaPago
    INNER JOIN DetalleVenta DV ON F.IdFactura = DV.IdFactura
    INNER JOIN Articulos ART ON DV.IdArticulo = ART.IdArticulo
    WHERE F.IdFactura = @IdFactura
    ORDER BY DV.IdDetalleVenta;
END;
