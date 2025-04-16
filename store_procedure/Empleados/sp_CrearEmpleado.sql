CREATE PROCEDURE sp_CrearEmpleado
    @Dpi VARCHAR(20),
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Puesto VARCHAR(50),
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(15),
    @IdRol INT,
    @FechaContratacion DATE
AS
BEGIN
    -- Validar campos obligatorios
    IF @Dpi IS NULL OR @Nombre IS NULL OR @Apellido IS NULL OR @Puesto IS NULL
    BEGIN
        RAISERROR('DPI, Nombre, Apellido y Puesto son campos obligatorios', 16, 1)
        RETURN
    END
    
    -- Validar formato básico de email
    IF @CorreoElectronico NOT LIKE '%_@__%.__%'
    BEGIN
        RAISERROR('Formato de correo electrónico inválido', 16, 1)
        RETURN
    END
    
    -- Validar que el DPI no exista
    IF EXISTS (SELECT 1 FROM Empleados WHERE Dpi = @Dpi)
    BEGIN
        RAISERROR('El DPI ya está registrado', 16, 1)
        RETURN
    END
    
    INSERT INTO Empleados (
        Dpi, Nombre, Apellido, Puesto, 
        CorreoElectronico, Telefono, IdRol, FechaContratacion
    )
    VALUES (
        @Dpi, @Nombre, @Apellido, @Puesto,
        @CorreoElectronico, @Telefono, @IdRol, @FechaContratacion
    )
    
    SELECT SCOPE_IDENTITY() AS IdEmpleado
END
