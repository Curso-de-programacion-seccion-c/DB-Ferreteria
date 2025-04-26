CREATE PROCEDURE sp_ActualizarUsuario
    @IdUsuario SMALLINT,
    @IdEmpleado SMALLINT,
    @CodigoUsuario VARCHAR(8),
    @Username VARCHAR(16),
    @UserPassword VARCHAR(64),
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar existencia
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario)
    BEGIN
        RAISERROR('El usuario no existe.', 16, 1);
        RETURN;
    END

    -- Validar datos vacíos
    IF LTRIM(RTRIM(@CodigoUsuario)) = '' OR LTRIM(RTRIM(@Username)) = '' OR LTRIM(RTRIM(@UserPassword)) = ''
    BEGIN
        RAISERROR('Campos obligatorios vacíos.', 16, 1);
        RETURN;
    END

    -- Validar duplicados
    IF EXISTS (SELECT 1 FROM Usuario WHERE Username = @Username AND IdUsuario <> @IdUsuario)
    BEGIN
        RAISERROR('El nombre de usuario ya está en uso.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Usuario WHERE CodigoUsuario = @CodigoUsuario AND IdUsuario <> @IdUsuario)
    BEGIN
        RAISERROR('El código de usuario ya está en uso.', 16, 1);
        RETURN;
    END

    -- Validar empleado
    IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        RAISERROR('El empleado no existe.', 16, 1);
        RETURN;
    END

    -- Actualizar
    UPDATE Usuario
    SET 
        IdEmpleado = @IdEmpleado,
        CodigoUsuario = @CodigoUsuario,
        Username = @Username,
        UserPassword = @UserPassword,
        IsActive = @IsActive
    WHERE IdUsuario = @IdUsuario;

    PRINT 'Usuario actualizado exitosamente.';
END
