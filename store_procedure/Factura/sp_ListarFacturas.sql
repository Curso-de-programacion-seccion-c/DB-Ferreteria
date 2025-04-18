CREATE OR ALTER PROCEDURE sp_ListarFacturas
AS
BEGIN
    SET NOCOUNT ON;

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
    ORDER BY F.Fecha DESC;
END;
