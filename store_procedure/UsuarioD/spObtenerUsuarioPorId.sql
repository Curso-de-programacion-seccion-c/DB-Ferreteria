Create  procedure sp_ObtenerUsuarioPorId
    @IdUsuario SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario
    )
    BEGIN
        SELECT 
            U.IdUsuario,
            U.IdEmpleado,
            E.Nombre + ' ' + E.Apellido AS NombreEmpleado,
            U.CodigoUsuario,
            U.Username,
            U.IsActive
        FROM Usuario U
        INNER JOIN Empleados E ON U.IdEmpleado = E.IdEmpleado
        WHERE U.IdUsuario = @IdUsuario;
    END
    ELSE
    BEGIN
        -- Devuelve un mensaje de error personalizado
        RAISERROR('No existe un usuario con el Id proporcionado.', 16, 1);
        RETURN;
    END
END
