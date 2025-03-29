CREATE PROCEDURE SpDeleteRol
    @IdRol INT,
AS
BEGIN
    -- Verificar si el rol esta asocaido a un usuario
    IF EXISTS (SELECT 1 FROM UsuarioRol WHERE IdRol = @IdRol)
    BEGIN
        THROW 50000, 'El rol no se puede eliminar porque está asociado a un usuario.', 1;
        RETURN
    END

    DELETE FROM Rol WHERE IdRol = @IdRol

    SELECT @IdRol AS IdRol

    RETURN
END