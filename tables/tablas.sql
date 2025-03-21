
USE FerreteriaDB

CREATE TABLE Categoria (
	IdCategoria INT IDENTITY(1,1) PRIMARY KEY ,
	NombreCategoria VARCHAR(32) NOT NULL,
	IsActive BIT DEFAULT 1
);

GO

CREATE TABLE Proveedor(
	IdProveedor INT IDENTITY(1,1) PRIMARY KEY,
	NombreProveedor VARCHAR(128) NOT NULL,
	Telefono VARCHAR(16) NOT NULL,
	NombreContacto VARCHAR(128) NOT NULL,
	IsActive BIT DEFAULT 1
);

GO

CREATE TABLE Usuario(
	IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
	IdEmpleado SMALLINT,
	CodigoUsuario VARCHAR(8) UNIQUE NOT NULL,
	Username varchar(16) UNIQUE NOT NULL,
	UserPassword VARCHAR(64) NOT NULL,
	IdRol INT,
	IsActive BIT DEFAULT 1,
	FOREIGN KEY (IdRol) REFERENCES Roles(IdRol)
);

CREATE TABLE Articulos(
	IdArticulo INT IDENTITY(1,1) PRIMARY KEY,
	CodeArticulo SMALLINT NOT NULL UNIQUE,
	Nombre VARCHAR(35) NOT NULL,
	Stock INT DEFAULT 1,
	PrecioUnitario DECIMAL(10,2) NOT NULL,
	Descripcion VARCHAR(50),
	FechaRegistro DATE,
	IsActive BIT DEFAULT 1,
	IdProveedor INT,
	IdCategoria INT,
	FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor),
	FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria)
);

CREATE TABLE FormaPago(
	idFormaPago INT IDENTITY(1,1) PRIMARY KEY,
	NombreFormaPago Varchar(25) NOT NULL,
	Descripcion varchar(25),
	Estado Bit default 1,
);

CREATE TABLE Roles(
    	IdRol INT INDENTITY(1,1) PRIMARY KEY,
	Nombre VARCHAR(25) NOT NULL,
	Sueldo DECIMAL(10,2) NOT NULL
);

CREATE TABLE Factura (
	IdFactura INT identity (1,1) primary key,
	Id_empleado INT,
	Id_cliente INT,
	Fecha DATE, 
	Total_pago Decimal(10,2),
	IdFormaPago INT,
);

CREATE TABLE DetalleVenta(
	IdDetalleVenta INT identity (1,1) Primary key,
	IdFactura int,
	IdArticulo int,
	Cantidad int,
	Descuento Decimal(10,2)
);

CREATE TABLE Clientes (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    Dpi VARCHAR(20), 
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    NIT VARCHAR(20),
    CorreoElectronico VARCHAR(100),
    Telefono VARCHAR(16),
    FechaRegistro DATE DEFAULT GETDATE(),
    Estado BIT DEFAULT 1


