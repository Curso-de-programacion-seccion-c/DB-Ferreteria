CREATE PROCEDURE sp_LoginUsuario
    @Username NVARCHAR(50),
    @UserPassword NVARCHAR(50),
    @CodigoUsuario NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar campos vacíos
    IF LTRIM(RTRIM(@Username)) = '' OR 
       LTRIM(RTRIM(@UserPassword)) = '' OR 
       LTRIM(RTRIM(@CodigoUsuario)) = ''
    BEGIN
        RAISERROR('No se permiten campos vacíos.', 16, 1);
        RETURN;
    END

    -- Verificar existencia del usuario con las credenciales
    IF NOT EXISTS (
        SELECT 1 FROM Usuario
        WHERE Username = @Username 
          AND UserPassword = @UserPassword
          AND CodigoUsuario = @CodigoUsuario
          AND IsActive = 1
    )
    BEGIN
        RAISERROR('Credenciales incorrectas o usuario inactivo.', 16, 1);
        RETURN;
    END

    -- Devolver la información del usuario, empleado y rol
    SELECT 
        u.IdUsuario,
        u.Username,
        u.CodigoUsuario,
        e.IdEmpleado,
        e.Nombre,
        e.Apellido,
        e.Puesto,
        e.CorreoElectronico,
        e.Telefono,
        r.IdRol,
        r.Nombre AS NombreRol,
        r.Sueldo
    FROM Usuario u
    INNER JOIN Empleados e ON u.IdEmpleado = e.IdEmpleado
    INNER JOIN Roles r ON e.IdRol = r.IdRol
    WHERE 
        u.Username = @Username AND 
        u.UserPassword = @UserPassword AND 
        u.CodigoUsuario = @CodigoUsuario AND 
        u.IsActive = 1;
END
