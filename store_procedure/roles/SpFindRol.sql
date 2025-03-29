CREATE PROCEDURE SpFindRol
    @IdRol TINYINT
AS
BEGIN
    SELECT IdRol, Nombre, Sueldo
    FROM Roles
    WHERE IdRol = @IdRol;
END