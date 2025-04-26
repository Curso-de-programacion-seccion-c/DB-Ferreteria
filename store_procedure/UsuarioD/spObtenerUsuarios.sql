CREATE PROCEDURE sp_ObtenerUsuarios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        U.IdUsuario,
        U.IdEmpleado,
        E.Nombre + ' ' + E.Apellido AS NombreEmpleado,
        U.CodigoUsuario,
        U.Username,
        U.IsActive
    FROM Usuario U
    INNER JOIN Empleados E ON U.IdEmpleado = E.IdEmpleado;
END
