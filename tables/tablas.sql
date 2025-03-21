
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
	IdEmpleado INT,
	CodigoUsuario VARCHAR(8),
	Username varchar(16),
	UserPassword VARCHAR(16),
	IdRol INT,
	IsActive BIT DEFAULT 1,
);

CREATE TABLE Articulos(
	IdArticulo INT IDENTITY(1,1) PRIMARY KEY,
	CodeArticulo INT NOT NULL,
	Nombre VARCHAR(25),
	Stock INT DEFAULT 1,
	PrecioUnitario DECIMAL(10,2),
	Descripcion VARCHAR(25),
	FechaRegistro DATE,
	IsActive BIT DEFAULT 1,
	IdProveedor INT,
	IdCategoria INT
);

CREATE TABLE FormaPago(
	idFormaPago INT IDENTITY(1,1) PRIMARY KEY,
	NombreFormaPago Varchar(25),
	Descripcion varchar(25),
	Estado Bit default 1,
);

CREATE TABLE Roles(
    IdRol int identity(1,1) primary key,
	Nombre varchar(25),
	Sueldo decimal(10,2)
);





