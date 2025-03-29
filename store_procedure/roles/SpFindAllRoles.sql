CREATE PROCEDURE SpFindAllRoles
AS
BEGIN
    SELECT IdRol, Nombre, Sueldo
    FROM Roles
END