CREATE PROCEDURE SpDeleteUser
    @CodigoUsuario INT,
AS
BEGIN
    DECLARE @isFind AS BIT = 0;
    exec SpExistsUser(@CodigoUsuario, NULL, 1, @isFind OUTPUT)

    IF @isFind = 0
    BEGIN
        THROW 50000, 'El usuario no existe.', 1;
        RETURN
    END

    UPDATE Usuario
    SET IsActive = 0
    WHERE CodigoUsuario = @CodigoUsuario

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50000, 'El usuario no se eliminó.', 1;
        RETURN
    END

    SELECT @CodigoUsuario AS CodigoUsuario

    RETURN
END