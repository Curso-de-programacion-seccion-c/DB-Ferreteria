Create PROCEDURE sp_DesactivarUsuario

    @IdUsuario SMALLINT
AS
BEGIN
    --SET NOCOUNT ON;

    -- Validar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario)
    BEGIN
        RAISERROR('El usuario no existe.', 16, 1);
        RETURN;
    END

    -- Validar si el usuario ya está desactivado
    IF EXISTS (
        SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario AND IsActive = 0
    )
    BEGIN
        RAISERROR('El usuario ya está desactivado.', 16, 1);
        RETURN;
    END

    -- Desactivar el usuario
    UPDATE Usuario
    SET IsActive = 0
    WHERE IdUsuario = @IdUsuario;

    PRINT 'Usuario desactivado correctamente.';
END
