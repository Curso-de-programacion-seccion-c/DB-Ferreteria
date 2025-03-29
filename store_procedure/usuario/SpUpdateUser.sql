CREATE PROCEDURE SpUpdateUser
    @IdUsuario INT,
    @Username VARCHAR(16),
    @UserPassword VARCHAR(16),
    @isActive BIT = 1
AS
BEGIN
    DECLARE @isFind AS BIT = 0;
    exec SpFindUser(NULL, @Username, @isActive, @isFind OUTPUT)

    IF @isFind = 0
    BEGIN
        THROW 50000, 'El usuario no existe.', 1;
        RETURN
    END

    UPDATE Usuario
    SET Username = @Username,
        UserPassword = @UserPassword,
    WHERE IdUsuario = @IdUsuario
    AND IsActive = 1

    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50000, 'El usuario no se actualizó.', 1;
        RETURN
    END

    SELECT @IdUsuario AS IdUsuario
    RETURN

END