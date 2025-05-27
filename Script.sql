--* CREATE DATABASE FerreteriaDB
CREATE DATABASE FerreteriaDB
GO

USE FerreteriaDB

--* Create the table for storing product information
CREATE TABLE Categoria (
	IdCategoria TINYINT IDENTITY(1,1) PRIMARY KEY ,
	NombreCategoria VARCHAR(32) NOT NULL
);

GO

CREATE TABLE Proveedor(
	IdProveedor TINYINT IDENTITY(1,1) PRIMARY KEY,
	NombreProveedor VARCHAR(128) NOT NULL,
	Telefono VARCHAR(16) NOT NULL,
	NombreContacto VARCHAR(128) NOT NULL
);

GO

CREATE TABLE Usuario(
	IdUsuario SMALLINT IDENTITY(1,1) PRIMARY KEY,
	IdEmpleado SMALLINT NOT NULL,
	CodigoUsuario VARCHAR(8) UNIQUE NOT NULL,
	Username varchar(16) UNIQUE NOT NULL,
	UserPassword VARCHAR(64) NOT NULL,
	IsActive BIT DEFAULT 1
);
GO

CREATE TABLE Articulos(
	IdArticulo SMALLINT IDENTITY(1,1) PRIMARY KEY,
	CodeArticulo SMALLINT NOT NULL UNIQUE,
	Nombre VARCHAR(35) NOT NULL,
	Stock SMALLINT DEFAULT 1,
	PrecioUnitario DECIMAL(10,2) NOT NULL,
	Descripcion VARCHAR(50),
	FechaRegistro DATE,
	IdProveedor TINYINT NOT NULL,
	IdCategoria TINYINT NOT NULL,
);
GO

CREATE TABLE FormaPago(
	idFormaPago TINYINT IDENTITY(1,1) PRIMARY KEY,
	NombreFormaPago Varchar(25) NOT NULL,
	Descripcion varchar(50)
);
GO

CREATE TABLE Roles(
    IdRol TINYINT IDENTITY(1,1) PRIMARY KEY,
	Nombre VARCHAR(25) NOT NULL,
	Sueldo DECIMAL(10,2) NOT NULL
);
GO

CREATE TABLE Factura (
	IdFactura SMALLINT IDENTITY (1,1) PRIMARY KEY,
	IdEmpleado SMALLINT NOT NULL,
	IdCliente SMALLINT NOT NULL,
	Fecha DATE, 
	Total_pago Decimal(10,2) NOT NULL,
	IdFormaPago TINYINT NOT NULL
);
GO

CREATE TABLE DetalleVenta(
	IdDetalleVenta INT identity (1,1) PRIMARY KEY,
	IdFactura SMALLINT NOT NULL,
	IdArticulo SMALLINT NOT NULL,
	Cantidad SMALLINT NOT NULL
);
GO

CREATE TABLE Clientes (
	IdCliente SMALLINT IDENTITY(1,1) PRIMARY KEY,
	Dpi VARCHAR(13) UNIQUE NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Apellido VARCHAR(50) NOT NULL,
	NIT VARCHAR(20) UNIQUE NOT NULL,
	CorreoElectronico VARCHAR(100),
	Telefono VARCHAR(16),
	FechaRegistro DATE DEFAULT GETDATE(),
	Estado BIT DEFAULT 1
);
GO

CREATE TABLE Empleados (
	IdEmpleado SMALLINT IDENTITY(1,1) PRIMARY KEY,
	Dpi CHAR(13) UNIQUE NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Apellido VARCHAR(50) NOT NULL,
	Puesto VARCHAR(25) NOT NULL,
	CorreoElectronico VARCHAR(50) NOT NULL,
	Telefono VARCHAR(16),
	IdRol TINYINT NOT NULL,
	FechaContratacion DATE DEFAULT GETDATE()
);
GO

--* Add foreign key constraints to ensure referential integrity
--LLAVES FORANEAS ARTICULOS
Alter Table Articulos
	Add Constraint FK_Articulos_IdProveedor_Proveedor_IdProveedor
	FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor)

Alter Table Articulos
	Add constraint FK_Articulos_IdCategoria_Categoria_IdCategoria
	FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria)


--LLAVES FORANEAS USUARIO

Alter Table Usuario
	Add Constraint FK_Usuario_IdEmpleado_Empleados_IdEmpleado
	FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado)


--LLAVES FORANEAS FACTURA
Alter Table Factura
	Add constraint FK_Factura_IdFormaPago_FormaPago_IdFormaPago
	FOREIGN KEY (IdFormaPago) REFERENCES FormaPago(IdFormaPago)

Alter Table Factura
	Add Constraint FK_Factura_IdEmpleado_Empleados_IdEmpleado
	FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado)

Alter Table Factura
	ADD Constraint FK_Clientes_IdCliente_Clientes_IdCliente
	FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente)



--LLAVES FORANEAS DETALLE DE VENTA CON FACTURA
Alter Table DetalleVenta
	Add Constraint FK_DetalleVenta_IdFactura_Factura_IdFactura
	FOREIGN KEY (IdFactura) REFERENCES Factura(IdFactura)

Alter Table DetalleVenta
	Add Constraint FK_DetalleVenta_IdArticulo_Articulos_IdArticulo
	FOREIGN KEY (IdArticulo) REFERENCES Articulos(IdArticulo)


--LLAVES FORANEAS EMPLEADOS
Alter Table Empleados
	Add Constraint FK_Empleados_IdRol_Roles_IdRol
	FOREIGN KEY (IdRol) REFERENCES Roles(IdRol)
GO

--*TRIGGERS FACTURA
CREATE OR ALTER TRIGGER trg_ActualizarStock_Articulos
ON DetalleVenta
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT: restar stock
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE A
        SET A.Stock = A.Stock - I.Cantidad
        FROM Articulos A
        INNER JOIN inserted I ON A.IdArticulo = I.IdArticulo;
    END

    -- DELETE: sumar stock
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE A
        SET A.Stock = A.Stock + D.Cantidad
        FROM Articulos A
        INNER JOIN deleted D ON A.IdArticulo = D.IdArticulo;
    END

    -- UPDATE: ajustar stock según diferencia
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE A
        SET A.Stock = A.Stock + (D.Cantidad - I.Cantidad)
        FROM Articulos A
        INNER JOIN deleted D ON A.IdArticulo = D.IdArticulo
        INNER JOIN inserted I ON A.IdArticulo = I.IdArticulo AND D.IdDetalleVenta = I.IdDetalleVenta;
    END
END;

GO

CREATE OR ALTER TRIGGER [dbo].[tr_ActualizarTotalFactura]
ON [dbo].[DetalleVenta]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lista de IdFactura afectadas
    DECLARE @FacturasAfectadas TABLE (IdFactura INT);

    -- INSERTED: Facturas afectadas por inserciones
    INSERT INTO @FacturasAfectadas (IdFactura)
    SELECT DISTINCT IdFactura FROM INSERTED
    WHERE IdFactura IS NOT NULL;

    -- DELETED: Facturas afectadas por eliminaciones
    INSERT INTO @FacturasAfectadas (IdFactura)
    SELECT DISTINCT IdFactura FROM DELETED
    WHERE IdFactura IS NOT NULL;

    -- Actualizar Total_pago por cada factura afectada
    UPDATE F
    SET F.Total_pago = (
        -- Sumar los precios de los artículos de los detalles de venta
        SELECT ISNULL(SUM(DV.Cantidad * A.PrecioUnitario), 0)  -- Si no hay detalles, asigna 0
        FROM DetalleVenta DV
        INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
        WHERE DV.IdFactura = F.IdFactura
    )
    FROM Factura F
    INNER JOIN @FacturasAfectadas FA ON F.IdFactura = FA.IdFactura;
END;

--* STORE PROCEDURES
--* Articulos
--* Actualizar un artículo
GO
CREATE OR ALTER PROCEDURE [dbo].[ActualizarArticulo]
    @IdArticulo SMALLINT,
    @CodeArticulo SMALLINT,
    @NombreArticulo VARCHAR(35),
    @Precio DECIMAL(10,2),
    @Stock SMALLINT,
    @Descripcion VARCHAR(50),
    @IdCategoria TINYINT,
    @IdProveedor TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM dbo.Articulos WHERE IdArticulo = @IdArticulo) AND
           EXISTS (SELECT 1 FROM dbo.Proveedor WHERE IdProveedor = @IdProveedor) AND
           EXISTS (SELECT 1 FROM dbo.Categoria WHERE IdCategoria = @IdCategoria)
        BEGIN
            UPDATE dbo.Articulos
            SET Nombre = @NombreArticulo,
                CodeArticulo = @CodeArticulo,
                PrecioUnitario = @Precio,
                Stock = @Stock,
                Descripcion = @Descripcion,
                IdProveedor = @IdProveedor,
                IdCategoria = @IdCategoria
            WHERE IdArticulo = @IdArticulo;

            SELECT 1 AS Resultado, 'Artículo actualizado correctamente.' AS Mensaje;
        END
        ELSE
            SELECT 0 AS Resultado, 'IdArticulo, IdProveedor o IdCategoria no existen.' AS Mensaje;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END

GO
--* Eliminar un artículo
CREATE OR ALTER PROCEDURE [dbo].[EliminarArticulo]
    @IdArticulo SMALLINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM dbo.Articulos WHERE IdArticulo = @IdArticulo)
        BEGIN
            DELETE FROM dbo.Articulos WHERE IdArticulo = @IdArticulo;
        END
        ELSE
            RAISERROR('IdArticulo no existe.', 16, 1);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
--* Insertar un artículo
CREATE OR ALTER PROCEDURE [dbo].[InsertarArticulo]
	@CodeArticulo SMALLINT,
    @NombreArticulo VARCHAR(35),
    @Precio DECIMAL(10,2),
    @Stock SMALLINT,
    @Descripcion VARCHAR(50),
    @IdCategoria TINYINT,
    @IdProveedor TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM dbo.Proveedor WHERE IdProveedor = @IdProveedor) AND
           EXISTS (SELECT 1 FROM dbo.Categoria WHERE IdCategoria = @IdCategoria)
        BEGIN
            INSERT INTO dbo.Articulos (
			    CodeArticulo,
                Nombre,
                Stock,
                PrecioUnitario,
                Descripcion,
                FechaRegistro,
                IdProveedor,
                IdCategoria
            )
            VALUES (
				@CodeArticulo,
                @NombreArticulo,
                @Stock,
                @Precio,
                @Descripcion,
                GETDATE(),
                @IdProveedor,
                @IdCategoria
            );

            SELECT SCOPE_IDENTITY() AS IdArticulo;
        END
        ELSE
            RAISERROR('IdProveedor o IdCategoria no existen.', 16, 1);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

--* Modificar articulo
CREATE OR ALTER PROCEDURE ModificarArticulo
    @CodeArticulo SMALLINT,
    @Nombre VARCHAR(35),
    @Stock SMALLINT,
    @PrecioUnitario DECIMAL(10,2),
    @Descripcion VARCHAR(50),
    @FechaRegistro DATE,
    @IdProveedor TINYINT,
    @IdCategoria TINYINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Articulos WHERE CodeArticulo = @CodeArticulo)
        BEGIN
            UPDATE Articulos
            SET Nombre = @Nombre,
                Stock = @Stock,
                PrecioUnitario = @PrecioUnitario,
                Descripcion = @Descripcion,
                FechaRegistro = @FechaRegistro,
                IdProveedor = @IdProveedor,
                IdCategoria = @IdCategoria
            WHERE CodeArticulo = @CodeArticulo
        END
        ELSE
        BEGIN
            RAISERROR('No se encontr� el art�culo a modificar.', 16, 1)
        END
    END TRY
    BEGIN CATCH
        PRINT 'Error al modificar el art�culo: ' + ERROR_MESSAGE()
    END CATCH
END
GO

--* Obtener Articulo por Id
CREATE OR ALTER PROCEDURE [dbo].[ObtenerArticuloPorId]
    @IdArticulo SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT 
            IdArticulo,
            CodeArticulo,
            Nombre,
            Stock,
			PrecioUnitario,
            Descripcion
        FROM dbo.Articulos
        WHERE IdArticulo = @IdArticulo;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END

GO
--* Obtener Articulos
CREATE PROCEDURE ObtenerArticulos
AS
BEGIN
    SELECT 
        IdArticulo, 
        CodeArticulo,
        Nombre AS NombreArticulo,
        PrecioUnitario AS Precio, 
        Stock, 
        Descripcion,
        IdCategoria, 
        IdProveedor
    FROM Articulos;
END
GO

--* Categoria
--* Actualizar Categoria
CREATE PROCEDURE SpActualizarCategoria
	@idCategoria tinyint,
	@nombre VARCHAR(32)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM Categoria WHERE IdCategoria = @idCategoria)
	BEGIN
		THROW 50000, 'No se puede actualizar la categoria por que no existe', 1;
        RETURN
	END

	IF EXISTS(SELECT 1 FROM Categoria WHERE NombreCategoria = @nombre
		AND IdCategoria <> @idCategoria)
	BEGIN
		THROW 50000, 'No se puede agregar la categoria ya existe', 1;
        RETURN
	END

	UPDATE Categoria
		SET NombreCategoria = @nombre
	WHERE IdCategoria = @idCategoria
END
GO

--* Buscar categoria
CREATE PROCEDURE SpBuscarCategoria
	@idCategoria tinyint = 0,
	@nombre VARCHAR(32) = ''
AS
BEGIN
	IF @idCategoria = 0 AND @nombre = ''
	BEGIN
		THROW 50000, 'No se puede buscar categorias vacias', 1;
		RETURN
	END

	SELECT *
	FROM Categoria
	WHERE (@idCategoria = 0 OR IdCategoria = @idCategoria)
	AND (@nombre = '' OR NombreCategoria = @nombre)
END
GO

--* Crear Categoria
CREATE PROCEDURE SpCrearCategoria
	@NombreCategoria VARCHAR(32)
AS
BEGIN
	IF(RTRIM(LTRIM(@NombreCategoria)) = '')
	BEGIN
		THROW 50000, 'No se puede agregar categorias vacias', 1;
        RETURN
	END

	IF EXISTS(SELECT 1 FROM Categoria WHERE NombreCategoria LIKE '%' + @NombreCategoria + '%')
	BEGIN
		THROW 50000, 'No se puede agregar la categoria ya existe', 1;
        RETURN
	END

	INSERT INTO Categoria(NombreCategoria)
		VALUES(@NombreCategoria);
END
GO

--* Eliminar Categoria
CREATE PROCEDURE SpEliminarCategoria
	@idCategoria tinyint
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Articulos WHERE IdCategoria = @idCategoria)
	BEGIN
		THROW 50000, 'No se puede eliminar la categoria por que esta relacionado a uno o varios productos', 1;
        RETURN
	END

	DELETE FROM Categoria WHERE IdCategoria = @idCategoria;
END
GO

--* Obtener Categorias
CREATE PROCEDURE SpListarCategorias
AS
BEGIN
	SELECT * FROM Categoria
END
GO

--* CLIENTES
--* Crear Cliente
CREATE OR ALTER PROCEDURE CreateCliente
    @Dpi NVARCHAR(13),
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @NIT NVARCHAR(20),
    @CorreoElectronico NVARCHAR(100),
    @Telefono NVARCHAR(16),
    @FechaRegistro DATE = NULL
AS
BEGIN

    INSERT INTO Clientes (Dpi, Nombre, Apellido, NIT, CorreoElectronico, Telefono, FechaRegistro)
    VALUES (@Dpi, @Nombre, @Apellido, @NIT, @CorreoElectronico, @Telefono, ISNULL(@FechaRegistro, GETDATE()));

    SELECT SCOPE_IDENTITY() AS IdCliente; 
END;
GO

--* Eliminar Cliente
CREATE PROCEDURE DeleteCliente
    @IdCliente SMALLINT
AS
BEGIN

    DELETE FROM Clientes
    WHERE IdCliente = @IdCliente;

END;
GO

--* Read Cliente por Id
CREATE PROCEDURE ReadClienteById
    @IdCliente SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdCliente, Dpi, Nombre, Apellido, NIT, CorreoElectronico, Telefono, FechaRegistro
    FROM Clientes
    WHERE IdCliente = @IdCliente;
END;
GO

--* Read Clientes
CREATE PROCEDURE ReadClientes
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdCliente, Dpi, Nombre, Apellido, NIT, CorreoElectronico, Telefono, FechaRegistro
    FROM Clientes;
END;
GO

--* Update Cliente
CREATE PROCEDURE UpdateCliente
    @IdCliente SMALLINT,
    @Dpi NVARCHAR(13),
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @NIT NVARCHAR(20),
    @CorreoElectronico NVARCHAR(100),
    @Telefono NVARCHAR(16),
    @FechaRegistro DATE
AS
BEGIN

    UPDATE Clientes
    SET 
        Dpi = @Dpi,
        Nombre = @Nombre,
        Apellido = @Apellido,
        NIT = @NIT,
        CorreoElectronico = @CorreoElectronico,
        Telefono = @Telefono,
        FechaRegistro = @FechaRegistro
    WHERE IdCliente = @IdCliente;
END;
GO

--* Detalle Venta
--* Actualizar Detalle Venta
CREATE OR ALTER PROCEDURE sp_ActualizarDetalleVenta
    @IdDetalleVenta INT,
    @IdArticulo INT,
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdDetalleVenta = @IdDetalleVenta)
    BEGIN
        THROW 60004, 'No se puede actualizar: el detalle de venta no existe', 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Articulos WHERE IdArticulo = @IdArticulo)
    BEGIN
        THROW 60006, 'No se puede actualizar: el artículo no existe', 1;
    END

    DECLARE @CantidadAnterior INT;

    SELECT @CantidadAnterior = Cantidad
    FROM DetalleVenta
    WHERE IdDetalleVenta = @IdDetalleVenta;

    -- Validar stock solo si la nueva cantidad es mayor
    IF @Cantidad > @CantidadAnterior
    BEGIN
        DECLARE @StockActual INT;
        SELECT @StockActual = Stock FROM Articulos WHERE IdArticulo = @IdArticulo;

        IF (@Cantidad - @CantidadAnterior) > @StockActual
        BEGIN
            THROW 60007, 'No se puede actualizar: stock insuficiente para la nueva cantidad', 1;
        END
    END

    UPDATE DetalleVenta
    SET
        IdArticulo = @IdArticulo,
        Cantidad = @Cantidad
    WHERE IdDetalleVenta = @IdDetalleVenta;

    SELECT DV.IdDetalleVenta, DV.IdFactura, DV.IdArticulo, DV.Cantidad,
           A.Nombre AS NombreArticulo, A.Stock
    FROM DetalleVenta DV
    INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
    WHERE DV.IdDetalleVenta = @IdDetalleVenta;
END;
GO

--* Buscar Detalle Venta por Id
CREATE OR ALTER PROCEDURE sp_BuscarDetalleVentaPorId
    @IdDetalleVenta INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdDetalleVenta = @IdDetalleVenta)
    BEGIN
        THROW 60007, 'No se encontro el detalle de venta con el ID proporcionado', 1;
    END

    SELECT 
        DV.IdDetalleVenta,
        DV.IdFactura,
        DV.IdArticulo,
        DV.Cantidad,
        A.Nombre AS NombreArticulo,
        A.PrecioUnitario,
        F.Fecha AS FechaFactura,
        C.Nombre AS NombreCliente
    FROM DetalleVenta DV
    INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
    INNER JOIN Factura F ON DV.IdFactura = F.IdFactura
    INNER JOIN Clientes C ON F.IdCliente = C.IdCliente
    WHERE DV.IdDetalleVenta = @IdDetalleVenta;
END
GO

--* Eliminar Detalle Venta
CREATE OR ALTER PROCEDURE sp_EliminarDetalleVenta
    @IdDetalleVenta INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdDetalleVenta = @IdDetalleVenta)
    BEGIN
        THROW 60008, 'No se puede eliminar: el detalle de venta no existe', 1;
    END

    DELETE FROM DetalleVenta
    WHERE IdDetalleVenta = @IdDetalleVenta;
END
GO

--* Insertar Detalle Venta
CREATE OR ALTER PROCEDURE sp_InsertarDetalleVenta
    @IdFactura INT,
    @IdArticulo INT,
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 60001, 'No se puede agregar el detalle: la factura no existe', 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Articulos WHERE IdArticulo = @IdArticulo)
    BEGIN
        THROW 60002, 'No se puede agregar el detalle: el artículo no existe', 1;
    END

    IF NOT EXISTS (SELECT 1 FROM Articulos WHERE IdArticulo = @IdArticulo AND Stock >= @Cantidad)
    BEGIN
        THROW 60003, 'No se puede agregar el detalle: no hay suficiente stock', 1;
    END

    INSERT INTO DetalleVenta (IdFactura, IdArticulo, Cantidad)
    VALUES (@IdFactura, @IdArticulo, @Cantidad);

    SELECT TOP 1 DV.IdDetalleVenta, DV.IdFactura, DV.IdArticulo, DV.Cantidad,
           A.Nombre AS NombreArticulo, A.Stock
    FROM DetalleVenta DV
    INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
    WHERE DV.IdFactura = @IdFactura AND DV.IdArticulo = @IdArticulo
    ORDER BY DV.IdDetalleVenta DESC;
END
GO

--* Listar Detalle ventas por Factura
CREATE OR ALTER PROCEDURE sp_ListarDetalleVentas
    @IdFactura INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        DV.IdDetalleVenta,
        DV.IdFactura,
        DV.IdArticulo,
        DV.Cantidad,
        A.Nombre AS NombreArticulo,
        A.PrecioUnitario,
        F.Fecha AS FechaFactura,
        C.Nombre AS NombreCliente
    FROM DetalleVenta DV
    INNER JOIN Articulos A ON DV.IdArticulo = A.IdArticulo
    INNER JOIN Factura F ON DV.IdFactura = F.IdFactura
    INNER JOIN Clientes C ON F.IdCliente = C.IdCliente
    WHERE DV.IdFactura = @IdFactura
END;
GO

--* Empleados
--* Actualizar Empleado
CREATE PROCEDURE sp_ActualizarEmpleado
    @IdEmpleado INT,
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
    UPDATE Empleados SET
        Dpi = @Dpi,
        Nombre = @Nombre,
        Apellido = @Apellido,
        Puesto = @Puesto,
        CorreoElectronico = @CorreoElectronico,
        Telefono = @Telefono,
        IdRol = @IdRol,
        FechaContratacion = @FechaContratacion
     
    WHERE IdEmpleado = @IdEmpleado
END
GO

--* Buscar Empleados
CREATE OR ALTER PROCEDURE sp_BuscarEmpleados
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener todos los empleados (sin importar si hay b�squeda o no)
    SELECT 
        IdEmpleado, 
        Dpi, 
        Empleados.Nombre AS NombreEmpleado,
        Apellido, 
        Puesto,
        CorreoElectronico, 
        Telefono, 
        FechaContratacion,
        Roles.IdRol,
        Roles.Nombre AS NombreRol,
        Roles.Sueldo AS SueldoRol
    FROM Empleados
    INNER JOIN Roles ON Empleados.IdRol = Roles.IdRol

    -- Mostrar mensaje si no hay empleados
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 'Empleados no encontrados' AS Mensaje;
    END
END
GO

--* Crear Empleado
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

    -- Validar formato b�sico de email
    IF @CorreoElectronico NOT LIKE '%_@__%.__%'
    BEGIN
        RAISERROR('Formato de correo electr�nico inv�lido', 16, 1)
        RETURN
    END

    -- Validar que el DPI no exista
    IF EXISTS (SELECT 1 FROM Empleados WHERE Dpi = @Dpi)
    BEGIN
        RAISERROR('El DPI ya est� registrado', 16, 1)
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
GO

--* Eliminar Empleado
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
GO

--* Obtener Empleado por Id
CREATE OR ALTER PROCEDURE sp_ObtenerEmpleado
    @IdEmpleado INT
AS
BEGIN
    SELECT
        IdEmpleado,
        Dpi,
        Empleados.Nombre AS NombreEmpleado,
        Apellido,
        Puesto,
        CorreoElectronico,
        Telefono,
        FechaContratacion,
        Roles.IdRol,
        Roles.Nombre AS NombreRol,
        Roles.Sueldo AS SueldoRol
    FROM Empleados
    INNER JOIN Roles ON Empleados.IdRol = Roles.IdRol
    WHERE IdEmpleado = @IdEmpleado
END
GO

--* FACTURAS
--* Actualizar Factura
CREATE PROCEDURE sp_ActualizarFactura
    @IdFactura INT,
    @IdEmpleado INT,
    @IdCliente INT,
    @Fecha DATETIME,
    @IdFormaPago INT
AS
BEGIN

    -- Validar que la factura exista
    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 50005, 'No se puede actualizar: la factura no existe', 1;
    END

    -- Validar existencia de empleado
    IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        THROW 50006, 'No se puede actualizar: el empleado no existe', 1;
    END

    -- Validar existencia de cliente
    IF NOT EXISTS (SELECT 1 FROM Clientes WHERE IdCliente = @IdCliente)
    BEGIN
        THROW 50007, 'No se puede actualizar: el cliente no existe', 1;
    END

    -- Validar existencia de forma de pago
    IF NOT EXISTS (SELECT 1 FROM FormaPago WHERE IdFormaPago = @IdFormaPago)
    BEGIN
        THROW 50008, 'No se puede actualizar: la forma de pago no existe', 1;
    END

    -- Actualizar la factura
    UPDATE Factura
    SET 
        IdEmpleado = @IdEmpleado,
        IdCliente = @IdCliente,
        Fecha = @Fecha,
        IdFormaPago = @IdFormaPago
    WHERE IdFactura = @IdFactura;

    -- Retornar la factura actualizada
    SELECT * FROM Factura WHERE IdFactura = @IdFactura;
END;
GO

--* Buscar Factura por Id
CREATE OR ALTER PROCEDURE sp_BuscarFacturaPorId
    @IdFactura INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 50010, 'No se encontro la factura con el ID proporcionado', 1;
    END

    SELECT
        F.IdFactura,
        F.Fecha,
        F.Total_pago,

        -- Empleado
        E.IdEmpleado,
        E.Nombre AS NombreEmpleado,

        -- Cliente
        C.IdCliente,
        C.Nombre AS NombreCliente,

        -- Forma de Pago
        FP.IdFormaPago,
        FP.NombreFormaPago AS NombreFormaPago

    FROM Factura F
    INNER JOIN Empleados E ON F.IdEmpleado = E.IdEmpleado
    INNER JOIN Clientes C ON F.IdCliente = C.IdCliente
    INNER JOIN FormaPago FP ON F.IdFormaPago = FP.IdFormaPago
    WHERE F.IdFactura = @IdFactura;
END;
GO

--* Eliminar Factura
CREATE PROCEDURE sp_EliminarFactura
    @IdFactura INT
AS
BEGIN
    -- Validar existencia
    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 50009, 'No se puede eliminar: la factura no existe', 1;
    END

    IF EXISTS (SELECT 1 FROM DetalleVenta WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 50010, 'No se puede eliminar: la factura tiene detalles asociados', 1;
    END

    DELETE FROM Factura WHERE IdFactura = @IdFactura;
END;
GO

--* Insertar Factura
CREATE OR ALTER PROCEDURE sp_InsertarFactura
    @IdEmpleado INT,
    @IdCliente INT,
    @Fecha DATETIME,
    @IdFormaPago INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar existencia del empleado
    IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        THROW 50001, 'No se puede agregar la factura: el empleado no existe', 1;
    END

    -- Validar existencia del cliente
    IF NOT EXISTS (SELECT 1 FROM Clientes WHERE IdCliente = @IdCliente)
    BEGIN
        THROW 50002, 'No se puede agregar la factura: el cliente no existe', 1;
    END

    -- Validar existencia de la forma de pago
    IF NOT EXISTS (SELECT 1 FROM FormaPago WHERE IdFormaPago = @IdFormaPago)
    BEGIN
        THROW 50003, 'No se puede agregar la factura: la forma de pago no existe', 1;
    END

    -- Insertar la factura (Total_pago se inicia en 0 y se actualizará automáticamente por el trigger)
    INSERT INTO Factura (IdEmpleado, IdCliente, Fecha, Total_pago, IdFormaPago)
    VALUES (@IdEmpleado, @IdCliente, @Fecha, 0.00, @IdFormaPago);

    -- Devolver el registro recién insertado
    SELECT TOP 1 *
    FROM Factura
    WHERE IdCliente = @IdCliente
      AND Fecha = @Fecha
      AND IdEmpleado = @IdEmpleado
    ORDER BY IdFactura DESC;
END;
GO

--* Listar Facturas
CREATE OR ALTER PROCEDURE sp_ListarFacturas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        F.IdFactura,
        F.Fecha,
        F.Total_pago,

        -- Empleado
        E.IdEmpleado,
        E.Nombre AS NombreEmpleado,

        -- Cliente
        C.IdCliente,
        C.Nombre AS NombreCliente,

        -- Forma de Pago
        FP.IdFormaPago,
        FP.NombreFormaPago AS NombreFormaPago

    FROM Factura F
    INNER JOIN Empleados E ON F.IdEmpleado = E.IdEmpleado
    INNER JOIN Clientes C ON F.IdCliente = C.IdCliente
    INNER JOIN FormaPago FP ON F.IdFormaPago = FP.IdFormaPago
    ORDER BY F.Fecha DESC;
END;
GO

--* FORMA DE PAGO
--* Actualizar Forma de Pago
CREATE PROCEDURE Sp_FormaPago_Actualizar
    @IdFormaPago TINYINT,
    @NombreFormaPago VARCHAR(25) = NULL,
    @Descripcion VARCHAR(50) = NULL
AS
BEGIN
    
    BEGIN TRY
        -- Validar existencia
        IF NOT EXISTS (SELECT 1 FROM FormaPago WHERE idFormaPago = @IdFormaPago)
        BEGIN
            RAISERROR('La forma de pago especificada no existe', 16, 1);
            RETURN;
        END

        -- Validar nombre �nico si se proporciona
        IF @NombreFormaPago IS NOT NULL AND 
           EXISTS (SELECT 1 FROM FormaPago WHERE NombreFormaPago = @NombreFormaPago AND idFormaPago <> @IdFormaPago)
        BEGIN
            RAISERROR('Ya existe otra forma de pago con este nombre', 16, 1);
            RETURN;
        END

        -- Actualizar registro
        UPDATE FormaPago SET
            NombreFormaPago = ISNULL(@NombreFormaPago, NombreFormaPago),
            Descripcion = ISNULL(@Descripcion, Descripcion)
        WHERE idFormaPago = @IdFormaPago;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al actualizar forma de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;
GO

--* Crear Forma de Pago
CREATE PROCEDURE Sp_FormaPago_Crear
    @NombreFormaPago VARCHAR(25),
    @Descripcion VARCHAR(50) = NULL
AS
BEGIN
    
    BEGIN TRY
        -- Validar nombre no vac�o
        IF NULLIF(RTRIM(LTRIM(@NombreFormaPago)), '') IS NULL
        BEGIN
            RAISERROR('El nombre de la forma de pago no puede estar vac�o', 16, 1);
            RETURN;
        END

        -- Validar nombre �nico
        IF EXISTS (SELECT 1 FROM FormaPago WHERE NombreFormaPago = @NombreFormaPago)
        BEGIN
            RAISERROR('Ya existe una forma de pago con este nombre', 16, 1);
            RETURN;
        END

        -- Insertar nuevo registro
        INSERT INTO FormaPago (NombreFormaPago, Descripcion)
        VALUES (@NombreFormaPago, @Descripcion);
        
        -- Retornar ID generado
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al crear forma de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;
GO

--* Eliminar Forma de Pago
CREATE PROCEDURE Sp_FormaPago_Eliminar
    @IdFormaPago TINYINT
AS
BEGIN
    BEGIN TRY
        -- Validar existencia
        IF NOT EXISTS (SELECT 1 FROM FormaPago WHERE idFormaPago = @IdFormaPago)
        BEGIN
            RAISERROR('La forma de pago especificada no existe', 16, 1);
            RETURN;
        END

        -- Eliminar registro
        DELETE FROM FormaPago WHERE idFormaPago = @IdFormaPago;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al eliminar forma de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;
GO

--* Listar Forma de Pago por Id
CREATE OR ALTER PROCEDURE Sp_FormaPago_ObtenerPorId
    @IdFormaPago TINYINT,
	@nombre VARCHAR(100)
AS
BEGIN
    BEGIN TRY
		IF @IdFormaPago = 0 AND @nombre = ''
		BEGIN

			 RAISERROR('No se encontr� la forma de pago especificada', 16, 1);

		END

		SELECT *
		FROM FormaPago
		WHERE (@IdFormaPago = 0 OR IdFormaPago = @IdFormaPago)
		AND (@nombre = '' OR NombreFormaPago=@nombre)

        IF @@ROWCOUNT = 0
            RAISERROR('No se encontr� la forma de pago especificada', 16, 1);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al obtener forma de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;
GO

--* Listar Todas las Formas de Pago
CREATE PROCEDURE Sp_FormaPago_ObtenerTodas
AS
BEGIN
    BEGIN TRY
        SELECT
            idFormaPago,
            NombreFormaPago,
            Descripcion
        FROM
            FormaPago
        ORDER BY
            NombreFormaPago;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR('Error al obtener formas de pago: %s', 16, 1, @ErrorMsg);
    END CATCH
END;
GO

--* PROVEEDORES
--* Insertar Proveedor
CREATE OR ALTER PROCEDURE InsertarProveedor
    @NombreProveedor VARCHAR(128),
    @Telefono VARCHAR(16),
    @NombreContacto VARCHAR(128)
AS
BEGIN
    INSERT INTO Proveedor (NombreProveedor, Telefono, NombreContacto)
    VALUES (@NombreProveedor, @Telefono, @NombreContacto)
END
GO
--* Actualizar Proveedor
CREATE OR ALTER PROCEDURE ActualizarProveedor
    @IdProveedor SMALLINT,
    @NombreProveedor VARCHAR(128),
    @Telefono VARCHAR(16),
    @NombreContacto VARCHAR(128)
AS
BEGIN
    UPDATE Proveedor
    SET NombreProveedor = @NombreProveedor,
        Telefono = @Telefono,
        NombreContacto = @NombreContacto
    WHERE IdProveedor = @IdProveedor
END
GO
--* Eliminar Proveedor
CREATE OR ALTER PROCEDURE EliminarProveedor
    @IdProveedor SMALLINT
AS
BEGIN
    DELETE FROM Proveedor WHERE IdProveedor = @IdProveedor
END
GO
--* Obtener Proveedor por Id
CREATE OR ALTER PROCEDURE SpObtenerProveedor
    @IdProveedor TINYINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdProveedor,
        NombreProveedor,
        Telefono,
        NombreContacto
    FROM Proveedor
    WHERE IdProveedor = @IdProveedor;
END
GO
--* Listar Proveedores
CREATE OR ALTER PROCEDURE ObtenerProveedores
AS
BEGIN
    SELECT IdProveedor, NombreProveedor, Telefono, NombreContacto
    FROM Proveedor
END
GO

--* REPORTES
--* Reporte de Factura por Id
CREATE OR ALTER PROCEDURE sp_ReporteFacturaPorId
    @IdFactura INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Factura WHERE IdFactura = @IdFactura)
    BEGIN
        THROW 70001, 'No se encontró la factura con el ID proporcionado', 1;
    END

    SELECT
        F.IdFactura,
        F.Fecha,
        F.Total_pago,
        -- Cliente
        CL.IdCliente,
        CONCAT(CL.Nombre, ' ', CL.Apellido) AS NombreCliente,
        CL.Telefono,
        CL.NIT AS NitCliente,
        CL.Dpi AS DpiCliente,
        -- Empleado
        EMP.IdEmpleado,
        CONCAT(EMP.Nombre, ' ', EMP.Apellido) AS NombreEmpleado,
        EMP.Dpi AS DpiEmpleado,
        EMP.Puesto,
        EMP.CorreoElectronico AS EmailEmpleado,
        RolEmpleado.Nombre AS RolDelEmpleado,
        -- Forma de Pago
        FP.NombreFormaPago, -- Cambiado alias para consistencia con el JSON
        -- Artículos vendidos
        DV.IdDetalleVenta,
        ART.IdArticulo,
        ART.Nombre AS NombreArticulo,
        ART.PrecioUnitario,
        DV.Cantidad,
        -- Cálculos adicionales
        (ART.PrecioUnitario * DV.Cantidad) AS Subtotal,
        -- Incluir información de impuestos (asumiendo tasa de IVA del 12%)
        CAST(ART.PrecioUnitario / 1.12 AS DECIMAL(10,2)) AS PrecioSinIVA,
        CAST((ART.PrecioUnitario / 1.12) * 0.12 AS DECIMAL(10,2)) AS IVA
    FROM Factura F
    INNER JOIN Clientes CL ON F.IdCliente = CL.IdCliente
    INNER JOIN Empleados EMP ON F.IdEmpleado = EMP.IdEmpleado
    INNER JOIN Roles RolEmpleado ON EMP.IdRol = RolEmpleado.IdRol
    INNER JOIN FormaPago FP ON F.IdFormaPago = FP.IdFormaPago
    INNER JOIN DetalleVenta DV ON F.IdFactura = DV.IdFactura
    INNER JOIN Articulos ART ON DV.IdArticulo = ART.IdArticulo
    WHERE F.IdFactura = @IdFactura
    ORDER BY DV.IdDetalleVenta;
END
GO

--* Reporte de Ventas por Fecha
CREATE OR ALTER PROCEDURE sp_ReporteVentasPorFechas
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @FechaInicio > @FechaFin
    BEGIN
        THROW 70002, 'La fecha de inicio no puede ser mayor que la fecha final', 1;
    END

    SELECT 
        F.IdFactura,
        F.Fecha,
        F.Total_pago,

        -- Cliente
        CL.IdCliente,
        CONCAT(CL.Nombre, ' ', CL.Apellido) AS NombreCliente,
        CL.Telefono,
        CL.NIT,

        -- Empleado
        EMP.IdEmpleado,
        CONCAT(EMP.Nombre, ' ', EMP.Apellido) AS NombreEmpleado,
        RolEmpleado.Nombre AS RolDelEmpleado,

        -- Forma de Pago
        FP.NombreFormaPago AS FormaPago

    FROM Factura F
    INNER JOIN Clientes CL ON F.IdCliente = CL.IdCliente
    INNER JOIN Empleados EMP ON F.IdEmpleado = EMP.IdEmpleado
    INNER JOIN Roles RolEmpleado ON EMP.IdRol = RolEmpleado.IdRol
    INNER JOIN FormaPago FP ON F.IdFormaPago = FP.IdFormaPago
    WHERE CAST(F.Fecha AS DATE) BETWEEN @FechaInicio AND @FechaFin
    ORDER BY F.Fecha DESC;
END
GO

--* ROLES
--* Crear Rol
CREATE OR ALTER PROCEDURE InsertarRol
    @Nombre VARCHAR(25),
    @Sueldo DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Roles (Nombre, Sueldo)
    VALUES (@Nombre, @Sueldo)
END
GO
--* Eliminar Rol
CREATE OR ALTER PROCEDURE EliminarRol
    @IdRol TINYINT
AS
BEGIN
    DELETE FROM Roles WHERE IdRol = @IdRol
END
GO
--* Encontrar Todos los Roles
CREATE OR ALTER PROCEDURE ObtenerRoles
AS
BEGIN
    SELECT * FROM Roles
END
GO
--* Encontrar Rol por Id
CREATE OR ALTER PROCEDURE ObtenerRolPorId
    @IdRol TINYINT
AS
BEGIN
    SELECT * FROM Roles WHERE IdRol = @IdRol
END
GO
--* Actualizar Rol
CREATE OR ALTER PROCEDURE ActualizarRol
    @IdRol TINYINT,
    @Nombre VARCHAR(25),
    @Sueldo DECIMAL(10,2)
AS
BEGIN
    UPDATE Roles
    SET Nombre = @Nombre, Sueldo = @Sueldo
    WHERE IdRol = @IdRol
END
GO

--* Usuarios
--* Actualizar Usuario
CREATE PROCEDURE sp_ActualizarUsuario
    @IdUsuario SMALLINT,
    @IdEmpleado SMALLINT,
    @CodigoUsuario VARCHAR(8),
    @Username VARCHAR(16),
    @UserPassword VARCHAR(64),
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar existencia
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario)
    BEGIN
        RAISERROR('El usuario no existe.', 16, 1);
        RETURN;
    END

    -- Validar datos vac�os
    IF LTRIM(RTRIM(@CodigoUsuario)) = '' OR LTRIM(RTRIM(@Username)) = '' OR LTRIM(RTRIM(@UserPassword)) = ''
    BEGIN
        RAISERROR('Campos obligatorios vac�os.', 16, 1);
        RETURN;
    END

    -- Validar duplicados
    IF EXISTS (SELECT 1 FROM Usuario WHERE Username = @Username AND IdUsuario <> @IdUsuario)
    BEGIN
        RAISERROR('El nombre de usuario ya est� en uso.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Usuario WHERE CodigoUsuario = @CodigoUsuario AND IdUsuario <> @IdUsuario)
    BEGIN
        RAISERROR('El c�digo de usuario ya est� en uso.', 16, 1);
        RETURN;
    END

    -- Validar empleado
    IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        RAISERROR('El empleado no existe.', 16, 1);
        RETURN;
    END

    -- Actualizar
    UPDATE Usuario
    SET 
        IdEmpleado = @IdEmpleado,
        CodigoUsuario = @CodigoUsuario,
        Username = @Username,
        UserPassword = @UserPassword,
        IsActive = @IsActive
    WHERE IdUsuario = @IdUsuario;

    PRINT 'Usuario actualizado exitosamente.';
END
GO

--* Crear Usuario
CREATE PROCEDURE sp_CrearUsuario
    @IdEmpleado SMALLINT,
    @CodigoUsuario VARCHAR(8),
    @Username VARCHAR(16),
    @UserPassword VARCHAR(64),
    @IsActive BIT
AS
BEGIN
    --SET NOCOUNT ON;

    -- Validar que los campos no est�n vac�os
    IF LTRIM(RTRIM(@CodigoUsuario)) = '' OR LTRIM(RTRIM(@Username)) = '' OR LTRIM(RTRIM(@UserPassword)) = ''
    BEGIN
        RAISERROR('CodigoUsuario, Username y UserPassword no pueden estar vac�os.', 16, 1);
        RETURN;
    END

    -- Validar que Username no exista
    IF EXISTS (SELECT 1 FROM Usuario WHERE Username = @Username)
    BEGIN
        RAISERROR('El nombre de usuario ya existe.', 16, 1);
        RETURN;
    END

    -- Validar que CodigoUsuario no exista
    IF EXISTS (SELECT 1 FROM Usuario WHERE CodigoUsuario = @CodigoUsuario)
    BEGIN
        RAISERROR('El c�digo de usuario ya est� en uso.', 16, 1);
        RETURN;
    END

    -- Validar que el empleado exista
    IF NOT EXISTS (SELECT 1 FROM Empleados WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        RAISERROR('El empleado no existe.', 16, 1);
        RETURN;
    END

    -- Insertar usuario
    INSERT INTO Usuario (IdEmpleado, CodigoUsuario, Username, UserPassword, IsActive)
    VALUES (@IdEmpleado, @CodigoUsuario, @Username, @UserPassword, @IsActive);

    PRINT 'Usuario creado correctamente.';
END
GO

--* Desactivar Usuario
Create PROCEDURE sp_DesactivarUsuario

    @IdUsuario SMALLINT
AS
BEGIN
    --SET NOCOUNT ON;

    -- Validar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario)
    BEGIN
        RAISERROR('El usuario no existe.', 16, 1);
        RETURN;
    END

    -- Validar si el usuario ya está desactivado
    IF EXISTS (
        SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario AND IsActive = 0
    )
    BEGIN
        RAISERROR('El usuario ya está desactivado.', 16, 1);
        RETURN;
    END

    -- Desactivar el usuario
    UPDATE Usuario
    SET IsActive = 0
    WHERE IdUsuario = @IdUsuario;

    PRINT 'Usuario desactivado correctamente.';
END
GO

--* Eliminar Usuario
CREATE PROCEDURE sp_EliminarUsuario
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario)
    BEGIN
        RAISERROR('El usuario no existe.', 16, 1);
        RETURN;
    END

    -- Eliminar el usuario
    DELETE FROM Usuario
    WHERE IdUsuario = @IdUsuario;

    PRINT 'Usuario eliminado exitosamente.';
END
GO
--* Login de Usuario
CREATE PROCEDURE sp_LoginUsuario
    @Username NVARCHAR(50),
    @UserPassword NVARCHAR(50),
    @CodigoUsuario NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar campos vac�os
    IF LTRIM(RTRIM(@Username)) = '' OR 
       LTRIM(RTRIM(@UserPassword)) = '' OR 
       LTRIM(RTRIM(@CodigoUsuario)) = ''
    BEGIN
        RAISERROR('No se permiten campos vac�os.', 16, 1);
        RETURN;
    END

    -- Verificar existencia del usuario con las credenciales
    IF NOT EXISTS (
        SELECT 1 FROM Usuario
        WHERE Username = @Username 
          AND UserPassword = @UserPassword
          AND CodigoUsuario = @CodigoUsuario
          AND IsActive = 1
    )
    BEGIN
        RAISERROR('Credenciales incorrectas o usuario inactivo.', 16, 1);
        RETURN;
    END

    -- Devolver la informaci�n del usuario, empleado y rol
    SELECT 
        u.IdUsuario,
        u.Username,
        u.CodigoUsuario,
        e.IdEmpleado,
        e.Nombre,
        e.Apellido,
        e.Puesto,
        e.CorreoElectronico,
        e.Telefono,
        r.IdRol,
        r.Nombre AS NombreRol,
        r.Sueldo
    FROM Usuario u
    INNER JOIN Empleados e ON u.IdEmpleado = e.IdEmpleado
    INNER JOIN Roles r ON e.IdRol = r.IdRol
    WHERE 
        u.Username = @Username AND 
        u.UserPassword = @UserPassword AND 
        u.CodigoUsuario = @CodigoUsuario AND 
        u.IsActive = 1;
END
GO

--* Obtener Usuario por Id
Create  procedure sp_ObtenerUsuarioPorId
    @IdUsuario SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM Usuario WHERE IdUsuario = @IdUsuario
    )
    BEGIN
        SELECT 
            U.IdUsuario,
            U.IdEmpleado,
            E.Nombre + ' ' + E.Apellido AS NombreEmpleado,
            U.CodigoUsuario,
            U.Username,
            U.IsActive
        FROM Usuario U
        INNER JOIN Empleados E ON U.IdEmpleado = E.IdEmpleado
        WHERE U.IdUsuario = @IdUsuario;
    END
    ELSE
    BEGIN
        -- Devuelve un mensaje de error personalizado
        RAISERROR('No existe un usuario con el Id proporcionado.', 16, 1);
        RETURN;
    END
END
GO
--* Listar Usuarios
CREATE PROCEDURE sp_ObtenerUsuarios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        U.IdUsuario,
        U.IdEmpleado,
        E.Nombre + ' ' + E.Apellido AS NombreEmpleado,
        U.CodigoUsuario,
        U.Username,
        U.IsActive
    FROM Usuario U
    INNER JOIN Empleados E ON U.IdEmpleado = E.IdEmpleado;
END
go

-- Insertar Roles (incluyendo administrador)
INSERT INTO Roles (Nombre, Sueldo) VALUES
('Administrador', 9500.00),
('Cajero', 4500.00),
('Bodeguero', 4300.00),
('Vendedor', 4000.00);
GO

INSERT INTO Empleados (Dpi, Nombre, Apellido, Puesto, CorreoElectronico, Telefono, IdRol) VALUES
('1234567890123', 'Luis', 'Martínez', 'Gerente General', 'lmartinez@ferreteria.com', '55550001', 1), -- Administrador
('2345678901234', 'Ana', 'González', 'Cajera', 'agonzalez@ferreteria.com', '55550002', 2),
('3456789012345', 'Carlos', 'Pérez', 'Encargado de Bodega', 'cperez@ferreteria.com', '55550003', 3),
('4567890123456', 'Marta', 'Díaz', 'Vendedora', 'mdiaz@ferreteria.com', '55550004', 4);
GO

-- Insertar Usuario administrador (ligado a empleado administrador)
INSERT INTO Usuario (IdEmpleado, CodigoUsuario, Username, UserPassword) VALUES
(1, 'ADM00001', 'admin', 'admin12345'); -- En producción se debe encriptar
GO
