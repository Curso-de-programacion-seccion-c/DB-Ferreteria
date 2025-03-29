CREATE PROCEDURE SpCreateUser
    @IdEmpleado INT,
    @CodigoUsuario NVARCHAR(50),
    @Username NVARCHAR(50),
    @UserPassword NVARCHAR(50),
AS
BEGIN
    DECLARE @isFind AS BIT = 0;
    exec SpFindUser(@CodigoUsuario, @Username, 1, @isFind OUTPUT)

    IF @isFind = 1
    BEGIN
        THROW 50000, 'El usuario ya existe.', 1;
        RETURN
    END

    INSERT INTO Usuario (IdEmpleado, CodigoUsuario, Username, UserPassword, IsActive)
    VALUES (@IdEmpleado, @CodigoUsuario, @Username, @UserPassword, 1)

    SET @IdUsuario = SCOPE_IDENTITY()

    SELECT @IdUsuario AS IdUsuario

    RETURN
END

