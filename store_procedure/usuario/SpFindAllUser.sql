CREATE PROCEDURE SpFindAllUser
    @isFindAll AS CHAR(1) = '0', --1 FIND ACTIVE USER, 0 FIND ALL USER, 2 FIND INACTIVE USER
AS
BEGIN
    SET NOCOUNT ON;

    IF @isFindAll = '1'
    BEGIN
        SELECT IdUsuario, IdEmpleado, CodigoUsuario, Username, UserPassword, IsActive
        FROM Usuario
        WHERE IsActive = 1
    END
    ELSE IF @isFindAll = '0'
    BEGIN
        SELECT IdUsuario, IdEmpleado, CodigoUsuario, Username, UserPassword, IsActive
        FROM Usuario
    END
    ELSE IF @isFindAll = '2'
    BEGIN
        SELECT IdUsuario, IdEmpleado, CodigoUsuario, Username, UserPassword, IsActive
        FROM Usuario
        WHERE IsActive = 0
    END

    RETURN
END;