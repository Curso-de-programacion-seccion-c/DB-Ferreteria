CREATE PROCEDURE SpFindUser
    @IdUsuario INT,
    @CodigoUsuario VARCHAR(8)
AS
BEGIN
    SELECT IdUsuario, IdEmpleado, CodigoUsuario, Username, UserPassword, IsActive
    FROM Usuario
    WHERE IdUsuario = @IdUsuario OR CodigoUsuario = @CodigoUsuario
END

