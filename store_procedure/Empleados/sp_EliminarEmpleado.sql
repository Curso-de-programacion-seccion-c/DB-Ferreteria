CREATE OR ALTER PROCEDURE sp_EliminarEmpleado
    @IdEmpleado INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el empleado existe
    IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        RAISERROR('El empleado no existe', 16, 1);
        RETURN;
    END

    -- Eliminaci�n f�sica
    DELETE FROM Empleados
    WHERE IdEmpleado = @IdEmpleado;

    SELECT 'Empleado eliminado correctamente' AS Mensaje;
END