CREATE PROCEDURE sp_CrearUsuario
    @IdEmpleado SMALLINT,
    @CodigoUsuario VARCHAR(8),
    @Username VARCHAR(16),
    @UserPassword VARCHAR(64),
    @IsActive BIT
AS
BEGIN
    --SET NOCOUNT ON;

    -- Validar que los campos no estén vacíos
    IF LTRIM(RTRIM(@CodigoUsuario)) = '' OR LTRIM(RTRIM(@Username)) = '' OR LTRIM(RTRIM(@UserPassword)) = ''
    BEGIN
        RAISERROR('CodigoUsuario, Username y UserPassword no pueden estar vacíos.', 16, 1);
        RETURN;
    END

    -- Validar que Username no exista
    IF EXISTS (SELECT 1 FROM Usuario WHERE Username = @Username)
    BEGIN
        RAISERROR('El nombre de usuario ya existe.', 16, 1);
        RETURN;
    END

    -- Validar que CodigoUsuario no exista
    IF EXISTS (SELECT 1 FROM Usuario WHERE CodigoUsuario = @CodigoUsuario)
    BEGIN
        RAISERROR('El código de usuario ya está en uso.', 16, 1);
        RETURN;
    END

    -- Validar que el empleado exista
    IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        RAISERROR('El empleado no existe.', 16, 1);
        RETURN;
    END

    -- Insertar usuario
    INSERT INTO Usuario (IdEmpleado, CodigoUsuario, Username, UserPassword, IsActive)
    VALUES (@IdEmpleado, @CodigoUsuario, @Username, @UserPassword, @IsActive);

    PRINT 'Usuario creado correctamente.';
END
