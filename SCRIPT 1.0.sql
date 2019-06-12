create database PP3;
use PP3;

create schema tiendaTEC; 

-- Creacion de las tablas 
-----------------------------------1
create table tiendaTEC.empleado(
idEmpleado int IDENTITY(1,1),
cedula int NOT NULL,
fechaNacimiento date NOT NULL,
idGenero int NOT NULL,
primerNombre varchar(30) NOT NULL,
segundoNombre varchar(30) NOT NULL,
primerApellido varchar(30) NOT NULL,
segundoApellido varchar(30) NOT NULL,
nombreEmpleadoLogin varchar(30) NOT NULL,
email varchar(30) NOT NULL,
idDepartamento int NOT NULL,
fechaContratacion date NOT NULL,

--Declaración de atributos unicos
CONSTRAINT cedulaEmpleado UNIQUE(cedula),
CONSTRAINT emailEmpleado UNIQUE(email),

--Declaración PK
PRIMARY KEY (idEmpleado),

--Declaración FK
FOREIGN KEY (idGenero) REFERENCES tiendaTEC.genero(idGenero),
FOREIGN KEY (idDepartamento) REFERENCES tiendaTEC.departamento(idDepartamento)
);

-----------------------------------2
create table tiendaTEC.genero(
idGenero int IDENTITY(1,1),
detalle varchar(30) NOT NULL,

--Declaración PK
PRIMARY KEY (idGenero)
);

-----------------------------------3
create table tiendaTEC.departamento(
idDepartamento int IDENTITY(1,1),
abreviaturaDepartamento varchar(30) NOT NULL,
cuentaCorreoDepartamental varchar(30) NOT NULL,
detalle varchar(30) NOT NULL,

--Declaración de atributos unicos
CONSTRAINT emailDepartamental UNIQUE(cuentaCorreoDepartamental),

--Declaración PK
PRIMARY KEY (idDepartamento)
);

-----------------------------------4
create table tiendaTEC.contactoEmergencia(
idContantoEmergencia int IDENTITY(1,1),
idEmpleado int NOT NULL,
idGenero int NOT NULL,
idParentesco int NOT NULL,
primerNombre varchar(30) NOT NULL,
primerApellido varchar(30) NOT NULL,
telefono int NOT NULL,

--Declaración de atributos unicos
CONSTRAINT telefonoContactoEmergencia UNIQUE(telefono),

--Declaración PK
PRIMARY KEY (idContantoEmergencia),

--Declaración FK
FOREIGN KEY (idEmpleado) REFERENCES tiendaTEC.empleado(idEmpleado),
FOREIGN KEY (idGenero) REFERENCES tiendaTEC.genero(idGenero),
FOREIGN KEY (idParentesco) REFERENCES tiendaTEC.parentesco(idParentesco)
);

-----------------------------------5
create table tiendaTEC.parentesco(
idParentesco int IDENTITY(1,1),
detalle varchar(30) NOT NULL,

--Declaración PK
PRIMARY KEY (idParentesco)
);

-----------------------------------6
create table tiendaTEC.pais(
idPais int IDENTITY(1,1),
abreviaturaPais varchar(30) NOT NULL,
detalle varchar(30) NOT NULL,

--Declaración PK
PRIMARY KEY (idPais)
);

-----------------------------------7
create table tiendaTEC.provinciaEstado(
idProvinciaEstado int IDENTITY(1,1),
idPais int NOT NULL,
nombre varchar(30) NOT NULL,

--Declaración PK
PRIMARY KEY (idProvinciaEstado),

--Declaración FK
FOREIGN KEY (idPais) REFERENCES tiendaTEC.pais(idPais)
);

-----------------------------------8
create table tiendaTEC.cliente(
cedulaCliente int NOT NULL,
idPais int NOT NULL,
idProvinciaEstado int NOT NULL,
tipoCliente int NOT NULL,
categoria varchar(30) NOT NULL,
senas varchar(30) NOT NULL,
email varchar(30) NOT NULL,

--Declaración de atributos unicos
CONSTRAINT cedulaUnicaCliente UNIQUE(cedulaCliente),
CONSTRAINT emailCliente UNIQUE(email),

--Declaracion de restricciones check
CONSTRAINT CHK_categoriaCliente CHECK (categoria ='A' OR categoria ='B' OR categoria ='C' OR categoria ='D'),

--Declaración PK
PRIMARY KEY (cedulaCliente),

--Declaración FK
FOREIGN KEY (idPais) REFERENCES tiendaTEC.pais(idPais),
FOREIGN KEY (idProvinciaEstado) REFERENCES tiendaTEC.provinciaEstado(idProvinciaEstado)
);

-----------------------------------9
create table tiendaTEC.clienteFisico(
cedulaCliente int NOT NULL,
idGenero int NOT NULL,
primerNombre varchar(30) NOT NULL,
segundoNombre varchar(30) NOT NULL,
primerApellido varchar(30) NOT NULL,
segundoApellido varchar(30) NOT NULL,

--Declaración de atributos unicos
CONSTRAINT cedulaUnicaClienteFisico UNIQUE(cedulaCliente),

--Declaración PK
PRIMARY KEY (cedulaCliente),

--Declaración FK
FOREIGN KEY (idGenero) REFERENCES tiendaTEC.genero(idGenero),
FOREIGN KEY (cedulaCliente) REFERENCES tiendaTEC.cliente(cedulaCliente)
);

-----------------------------------10
create table tiendaTEC.clienteJuridico(
cedulaCliente int NOT NULL,
razonSocial varchar(30) NOT NULL,

--Declaración de atributos unicos
CONSTRAINT cedulaUnicaClienteJuridico UNIQUE(cedulaCliente),

--Declaración PK
PRIMARY KEY (cedulaCliente),

--Declaracion FK
FOREIGN KEY (cedulaCliente) REFERENCES tiendaTEC.cliente(cedulaCliente)
);

create table tiendaTEC.proveedores(
  idProveedor int IDENTITY(1,1) PRIMARY KEY,
  telefono int NOT NULL UNIQUE,
  nombreCompania varchar(25) NOT NULL,
  estaActivo varchar(5) NOT NULL,
  idPais int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.pais(idPais),
  CONSTRAINT activo_CHK CHECK (estaActivo='A' OR estaActivo='I')
);

create table tiendaTEC.vendedor(
  idVendedor int IDENTITY(1,1) PRIMARY KEY,
  nombre varchar(25) NOT NULL,
  puesto varchar(25) NOT NULL,
  email varchar(50) NOT NULL UNIQUE,
  telefonoMovil int NOT NULL UNIQUE,
  telefonoOficina int NOT NULL UNIQUE,
  extOficina int NOT NULL UNIQUE,
  idGenero int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.genero(idGenero),
  idProveedor int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.proveedores(idProveedor),
);

create table tiendaTEC.inventario(
  idProducto int PRIMARY KEY,
  cantidadMinimaPermitida int NOT NULL,
  fechaIngreso date NOT NULL,
);

create table tiendaTEC.producto(
  idProducto int IDENTITY(1,1) PRIMARY KEY,
  nombre varchar(30) NOT NULL,
  precioUnitario money NOT NULL,
  estaDescontinuado varchar(5) NOT NULL,
  idProveedor int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.proveedores(idProveedor),
  CONSTRAINT descontinuado_CHK CHECK (estaDescontinuado='A' OR estaDescontinuado='D')
);

create table tiendaTEC.ordenCompra(
  idOrden int IDENTITY(1,1) PRIMARY KEY,
  cedulaCliente int NOT NULL,
  fecha date NOT NULL,
  montoTotal money NOT NULL,
  fechaAplicacionDescuento date,
  montoDescuento int DEFAULT '0' FOREIGN KEY REFERENCES tiendaTEC.cuponDescuento(idCuponDescuento),
  idCuponDescuento int FOREIGN KEY REFERENCES tiendaTEC.cliente(cedulaCliente),
);

CREATE TRIGGER actualizarDescuento 
AFTER INSERT ON tiendaTEC.ordenCompra
AS BEGIN 
INSERT ON ordenCompra.montoDescuento
SELECT porcentajeDescuento FROM tiendaTEC.cuponDescuento
UPDATE montoDescuento;


create table tiendaTEC.ordenDeCompraEstado(
  idEstado int IDENTITY(1,1) PRIMARY KEY,
  detalle varchar(30) NOT NULL,
  CONSTRAINT compraEstado_CHK CHECK (detalle='En preparación' OR detalle='en tránsito' OR detalle='cancelada' OR detalle='entregada' OR detalle='con retraso' OR detalle='extraviado')
);

create table tiendaTEC.item(
  idItem int IDENTITY(1,1) PRIMARY KEY,
  monto money NOT NULL,
  idOrden int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.ordenCompra(idOrden),
  idProducto int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.producto(idProducto),
);

create table tiendaTEC.bitacoraRegistroAuditoria(
  idRegistroAuditoria int IDENTITY(1,1) PRIMARY KEY,
  fechaHora datetime NOT NULL,
  detalle varchar(40) NOT NULL,
  idTipoRegistroAuditoria int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.tipoRegistroAuditoria(idTipoRegistroAuditoria),
  idEmpleado int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.cliente(cedulaCliente),
);

create table tiendaTEC.tipoRegistroAuditoria(
  idTipoRegistroAuditoria int IDENTITY(1,1) PRIMARY KEY,
  detalle varchar(30) NOT NULL,
  CONSTRAINT detalleRegistro_CHK CHECK (detalle='cuponCreado' OR detalle='cuponAplicado' OR detalle='ordenCreada' OR detalle='cantidadMinimaSuperada' OR detalle='proveedorCreado' OR detalle='proveedorDadoDeBaja' )
);

create table tiendaTEC.cuponDescuento(
  idCuponDescuento int IDENTITY(1,1) PRIMARY KEY,
  detalleCodigo varchar(40) NOT NULL,
  porcentajeDescuento int NOT NULL,
  fechaInicioVigencia date NOT NULL,
  fechaFinVigencia date NOT NULL,
  montoMinimoCompraParaAplicarCupon int NOT NULL,
  disponibilidadTipo varchar(5) NOT NULL,
  estaActivo varchar(5) NOT NULL,
  CONSTRAINT activado_CHK CHECK (estaActivo='A' OR estaActivo='I'),
  CONSTRAINT disponibilidad_CHK CHECK (disponibilidadTipo='A' OR disponibilidadTipo='B' OR disponibilidadTipo='C' OR disponibilidadTipo='D'),
);

create table tiendaTEC.ordenCompraCancelada(
  idOrden int PRIMARY KEY,
  cedulaCliente int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.cliente(cedulaCliente),
  fechaCancelacion date NOT NULL,
  explicacionCliente varchar(40) NOT NULL,
);

create table tiendaTEC.ordenCancelada(
  idOrdenCancelada int IDENTITY(1,1) PRIMARY KEY,
  idOrden INT NULL FOREIGN KEY REFERENCES tiendaTEC.ordenCompraCancelada(idOrden),
  fechaCancelacion date NULL,
);

/*Función #1 */
CREATE FUNCTION productoMasVendido(@fecha1 varchar(50),@fecha2 varchar(50))
RETURNS table
AS
RETURN(
    SELECT TOP 1 tiendaTEC.item.idProducto,count(tiendaTEC.item.idProducto) AS cantidad
    FROM ordenCompra JOIN item 
    ON tiendaTEC.ordenCompra.idOrden=item.idOrden
    WHERE ordenCompra.fecha BETWEEN @fecha1 and @fecha2
    GROUP BY item.idProducto
    ORDER BY cantidad DESC 
    )
END
GO

/*Función #2 */
CREATE FUNCTION descuentoAplicado(@cuponDescuento int)
RETURNS int
AS
BEGIN
RETURN(
    SELECT montoDescuento FROM tiendaTEC.ordenCompra 
    WHERE tiendaTEC.ordenCompra.idCuponDescuento = @cuponDescuento
    )
END
GO

/*Procedimiento almacenado #5*/
CREATE PROCEDURE cuponesVigentes @fecha1 date, @fecha2 date
AS 
SELECT * FROM tiendaTEC.cuponDescuento
WHERE cuponDescuento.fechaInicioVigencia BETWEEN @fecha1 AND @fecha2 
AND cuponDescuento.fechaFinVigencia BETWEEN @fecha1 AND @fecha2
GO

/*Procedimiento almacenado #6*/


/*Trigger #9*/
CREATE TRIGGER auditoriaOrdenes
AFTER INSERT ON tiendaTEC.ordenCompraCancelada
AS BEGIN
FOR EACH ROW
INSERT INSERT INTO tiendaTEC.ordenCancelada (idOrden, fechaCancelacion)
VALUES (new.idOrden, new.fechaCancelacion)
END
GO

/*Trigger #10*/
CREATE TRIGGER auditoriaProveedores
AFTER UPDATE, INSERT ON tiendaTEC.proveedores
AS BEGIN
FOR EACH ROW
INSERT tiendaTEC.bitacoraRegistroAuditoria (fechaHora, detalle, idTipoRegistroAuditoria, idEmpleado)
VALUES (now(), new.detalle, new.idTipoRegistroAuditoria, new.idEmpleado)
END
GO

/*Vista #13 */
CREATE VIEW productosNoVendidos AS
SELECT nombre
FROM tiendaTEC.producto a, tiendaTEC.item b
WHERE a.idProducto <> b.idProducto;