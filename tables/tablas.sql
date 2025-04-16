
USE FerreteriaDB

CREATE TABLE Categoria (
	IdCategoria TINYINT IDENTITY(1,1) PRIMARY KEY ,
	NombreCategoria VARCHAR(32) NOT NULL
);

GO

CREATE TABLE Proveedor(
	IdProveedor TINYINT IDENTITY(1,1) PRIMARY KEY,
	NombreProveedor VARCHAR(128) NOT NULL,
	Telefono VARCHAR(16) NOT NULL,
	NombreContacto VARCHAR(128) NOT NULL,
	IsActive BIT DEFAULT 1
);

GO

CREATE TABLE Usuario(
	IdUsuario SMALLINT IDENTITY(1,1) PRIMARY KEY,
	IdEmpleado SMALLINT NOT NULL,
	CodigoUsuario VARCHAR(8) UNIQUE NOT NULL,
	Username varchar(16) UNIQUE NOT NULL,
	UserPassword VARCHAR(64) NOT NULL,
	IsActive BIT DEFAULT 1,
);

CREATE TABLE Articulos(
	IdArticulo SMALLINT IDENTITY(1,1) PRIMARY KEY,
	CodeArticulo SMALLINT NOT NULL UNIQUE,
	Nombre VARCHAR(35) NOT NULL,
	Stock SMALLINT DEFAULT 1,
	PrecioUnitario DECIMAL(10,2) NOT NULL,
	Descripcion VARCHAR(50),
	FechaRegistro DATE,
	IsActive BIT DEFAULT 1,
	IdProveedor TINYINT NOT NULL,
	IdCategoria TINYINT NOT NULL,
);

CREATE TABLE FormaPago(
	idFormaPago TINYINT IDENTITY(1,1) PRIMARY KEY,
	NombreFormaPago Varchar(25) NOT NULL,
	Descripcion varchar(50),
	Estado Bit default 1
);

CREATE TABLE Roles(
    IdRol TINYINT IDENTITY(1,1) PRIMARY KEY,
	Nombre VARCHAR(25) NOT NULL,
	Sueldo DECIMAL(10,2) NOT NULL
);

CREATE TABLE Factura (
	IdFactura SMALLINT IDENTITY (1,1) PRIMARY KEY,
	IdEmpleado SMALLINT NOT NULL,
	IdCliente SMALLINT NOT NULL,
	Fecha DATE, 
	Total_pago Decimal(10,2) NOT NULL,
	IdFormaPago TINYINT NOT NULL,
);

CREATE TABLE DetalleVenta(
	IdDetalleVenta INT identity (1,1) PRIMARY KEY,
	IdFactura SMALLINT NOT NULL,
	IdArticulo SMALLINT NOT NULL,
	Cantidad TINYINT NOT NULL,
	Descuento Decimal(10,2),
);

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

CREATE TABLE Empleados (
	IdEmpleado SMALLINT IDENTITY(1,1) PRIMARY KEY,
	Dpi CHAR(13) UNIQUE NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Apellido VARCHAR(50) NOT NULL,
	Puesto VARCHAR(25) NOT NULL,
	CorreoElectronico VARCHAR(50) NOT NULL,
	Telefono VARCHAR(16),
	IdRol TINYINT NOT NULL,
	FechaContratacion DATE DEFAULT GETDATE(),
	Estado BIT DEFAULT 1,
);

