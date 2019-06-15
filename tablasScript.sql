CREATE DATABASE prueba1;
USE DATABASE prueba1;
CREATE SCHEMA tiendaTEC;

create table tiendaTEC.empleado(
idEmpleado int IDENTITY(1,1) PRIMARY KEY,
cedula int NOT NULL UNIQUE,
fechaNacimiento date NOT NULL,
idGenero int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.genero(idGenero),
primerNombre varchar(30) NOT NULL,
segundoNombre varchar(30) NOT NULL,
primerApellido varchar(30) NOT NULL,
segundoApellido varchar(30) NOT NULL,
nombreEmpleadoLogin varchar(30) NOT NULL,
email varchar(30) NOT NULL UNIQUE,
idDepartamento int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.departamento(idDepartamento),
fechaContratacion date NOT NULL,
);

create table tiendaTEC.genero(
idGenero int IDENTITY(1,1) PRIMARY KEY,
detalle varchar(30) NOT NULL,
);

create table tiendaTEC.departamento(
idDepartamento int IDENTITY(1,1) PRIMARY KEY,
abreviaturaDepartamento varchar(30) NOT NULL,
cuentaCorreoDepartamental varchar(30) NOT NULL UNIQUE,
detalle varchar(30) NOT NULL,
);

create table tiendaTEC.contactoEmergencia(
idContantoEmergencia int IDENTITY(1,1) PRIMARY KEY,
idEmpleado int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.empleado(idEmpleado),
idGenero int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.genero(idGenero),
idParentesco int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.parentesco(idParentesco),
primerNombre varchar(30) NOT NULL,
primerApellido varchar(30) NOT NULL,
telefono int NOT NULL UNIQUE,
);

create table tiendaTEC.parentesco(
idParentesco int IDENTITY(1,1) PRIMARY KEY,
detalle varchar(30) NOT NULL,
);

create table tiendaTEC.pais(
idPais int NOT NULL PRIMARY KEY,
abreviaturaPais varchar(30) NOT NULL,
detalle varchar(30) NOT NULL,
);

create table tiendaTEC.provinciaEstado(
idProvinciaEstado int IDENTITY(1,1) PRIMARY KEY,
idPais int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.pais(idPais),
nombre varchar(30) NOT NULL,
);

create table tiendaTEC.cliente(
cedulaCliente int NOT NULL PRIMARY KEY,
idPais int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.pais(idPais),
idProvinciaEstado int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.provinciaEstado(idProvinciaEstado),
tipoCliente int NOT NULL,
categoria varchar(30) NOT NULL,
senas varchar(30) NOT NULL,
email varchar(30) NOT NULL UNIQUE,
CONSTRAINT CHK_categoriaCliente CHECK (categoria ='A' OR categoria ='B' OR categoria ='C' OR categoria ='D'),
);

create table tiendaTEC.clienteFisico(
cedulaCliente int NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES tiendaTEC.cliente(cedulaCliente),
idGenero int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.genero(idGenero),
primerNombre varchar(30) NOT NULL,
segundoNombre varchar(30) NOT NULL,
primerApellido varchar(30) NOT NULL,
segundoApellido varchar(30) NOT NULL,
);

create table tiendaTEC.clienteJuridico(
cedulaCliente int NOT NULL PRIMARY KEY,
razonSocial varchar(30) NOT NULL,
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
  cantidadDisponible int NOT NULL,
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
  montoTotal int NOT NULL,
  fechaAplicacionDescuento date,
  montoDescuento int DEFAULT '0',
  idCuponDescuento int FOREIGN KEY REFERENCES tiendaTEC.cuponDescuento(idCuponDescuento),
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

create table tiendaTEC.ordenDeCompraEstado(
  idEstado int IDENTITY(1,1) PRIMARY KEY,
  detalle varchar(30) NOT NULL,
  CONSTRAINT compraEstado_CHK CHECK (detalle='En preparación' OR detalle='en tránsito' OR detalle='cancelada' OR detalle='entregada' OR detalle='con retraso' OR detalle='extraviado')
);

create table tiendaTEC.item(
  idItem int IDENTITY(1,1) PRIMARY KEY,
  monto money NOT NULL,
  cantidad int NOT NULL,
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

create table tiendaTEC.ordenCompraCancelada(
  idOrden int PRIMARY KEY,
  cedulaCliente int NOT NULL FOREIGN KEY REFERENCES tiendaTEC.cliente(cedulaCliente),
  fechaCancelacion date NOT NULL,
  explicacionCliente varchar(40) NOT NULL,
);

create table tiendaTEC.ordenCancelada(
  idOrdenCancelada int IDENTITY(1,1) PRIMARY KEY,
  idOrden INT NOT NULL FOREIGN KEY REFERENCES tiendaTEC.ordenCompraCancelada(idOrden),
  fechaCancelacion date NOT NULL,
);

