CREATE OR ALTER PROCEDURE sp_ReporteVentasPorFechas
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @FechaInicio > @FechaFin
    BEGIN
        THROW 70002, 'La fecha de inicio no puede ser mayor que la fecha final', 1;
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

        -- Empleado
        EMP.IdEmpleado,
        CONCAT(EMP.Nombre, ' ', EMP.Apellido) AS NombreEmpleado,
        RolEmpleado.Nombre AS RolDelEmpleado,

        -- Forma de Pago
        FP.NombreFormaPago AS FormaPago

    FROM Factura F
    INNER JOIN Clientes CL ON F.IdCliente = CL.IdCliente
    INNER JOIN Empleados EMP ON F.IdEmpleado = EMP.IdEmpleado
    INNER JOIN Roles RolEmpleado ON EMP.IdRol = RolEmpleado.IdRol
    INNER JOIN FormaPago FP ON F.IdFormaPago = FP.IdFormaPago
    WHERE CAST(F.Fecha AS DATE) BETWEEN @FechaInicio AND @FechaFin
    ORDER BY F.Fecha DESC;
END;
