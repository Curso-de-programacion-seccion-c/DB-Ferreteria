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
        CL.NIT,
        CL.Dpi,

        -- Empleado
        EMP.IdEmpleado,
        CONCAT(EMP.Nombre, ' ', EMP.Apellido) AS NombreEmpleado,
        EMP.Dpi,
        EMP.Puesto,
        EMP.CorreoElectronico,
        RolEmpleado.Nombre AS RolDelEmpleado,

        -- Forma de Pago
        FP.NombreFormaPago AS FormaPago,

        -- Artículos vendidos
        DV.IdDetalleVenta,
        ART.Nombre AS NombreArticulo,
        DV.Cantidad

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
