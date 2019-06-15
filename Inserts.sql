USE prueba1

/*Tabla Proveedor*/
INSERT INTO tiendaTEC.proveedores(nombreCompania, telefono, idPais, estaActivo) VALUES ('Universal','22922727','1','A');
INSERT INTO tiendaTEC.proveedores(nombreCompania, telefono, idPais, estaActivo) VALUES ('Pozuelo','22294541','2','A');
INSERT INTO tiendaTEC.proveedores(nombreCompania, telefono, idPais, estaActivo) VALUES ('Bimbo','27980235','3','A');
INSERT INTO tiendaTEC.proveedores(nombreCompania, telefono, idPais, estaActivo) VALUES ('Florida','27985091','4','A');
INSERT INTO tiendaTEC.proveedores(nombreCompania, telefono, idPais, estaActivo) VALUES ('Great Value','22947679','5','A');

/*Tabla Vendedor*/
INSERT INTO tiendaTEC.vendedor(nombre, puesto, email, telefonoMovil, telefonoOficina, extOficina, idGenero, idProveedor) VALUES ('Jose','Agente','jose@gmail.com','63030047','22945656','1234','1','1');
INSERT INTO tiendaTEC.vendedor(nombre, puesto, email, telefonoMovil, telefonoOficina, extOficina, idGenero, idProveedor) VALUES ('Maria','Agente','maria@gmail.com','72083455','22945757','1234','2','2');
INSERT INTO tiendaTEC.vendedor(nombre, puesto, email, telefonoMovil, telefonoOficina, extOficina, idGenero, idProveedor) VALUES ('Alejandra','Agente','alejandra@gmail.com','88868249','22945858','1234','2','3');
INSERT INTO tiendaTEC.vendedor(nombre, puesto, email, telefonoMovil, telefonoOficina, extOficina, idGenero, idProveedor) VALUES ('Carlos','Agente','carlos@gmail.com','71026369','22945959','1234','1','4');
INSERT INTO tiendaTEC.vendedor(nombre, puesto, email, telefonoMovil, telefonoOficina, extOficina, idGenero, idProveedor) VALUES ('Andrea','Agente','andrea@gmail.com','60307581','22945555','1234','2','5');

/*Tabla Inventario*/
INSERT INTO tiendaTEC.inventario(idProducto, cantidadDisponible, cantidadMinimaPermitida, fechaIngreso) VALUES ('1','100','50','02-08-2019');
INSERT INTO tiendaTEC.inventario(idProducto, cantidadDisponible, cantidadMinimaPermitida, fechaIngreso) VALUES ('2','150','100','03-09-2019');
INSERT INTO tiendaTEC.inventario(idProducto, cantidadDisponible, cantidadMinimaPermitida, fechaIngreso) VALUES ('3','200','150','04-10-2019');
INSERT INTO tiendaTEC.inventario(idProducto, cantidadDisponible, cantidadMinimaPermitida, fechaIngreso) VALUES ('4','100','50','05-11-2019');
INSERT INTO tiendaTEC.inventario(idProducto, cantidadDisponible, cantidadMinimaPermitida, fechaIngreso) VALUES ('5','120','60','06-12-2019');

/*Tabla Producto*/
INSERT INTO tiendaTEC.producto(nombre, precioUnitario, estaDescontinuado, idProveedor) VALUES ('Botellas','1000','A','3');
INSERT INTO tiendaTEC.producto(nombre, precioUnitario, estaDescontinuado, idProveedor) VALUES ('Cajas','600','A','1');
INSERT INTO tiendaTEC.producto(nombre, precioUnitario, estaDescontinuado, idProveedor) VALUES ('Moldes','500','A','2');
INSERT INTO tiendaTEC.producto(nombre, precioUnitario, estaDescontinuado, idProveedor) VALUES ('Cucharas','300','A','5');
INSERT INTO tiendaTEC.producto(nombre, precioUnitario, estaDescontinuado, idProveedor) VALUES ('Cascos','10000','A','4');

/*Tabla ordenCompra*/


/*Tabla ordenDeCompraEstado*/
INSERT INTO tiendaTEC.ordenDeCompraEstado(detalle) VALUES ('En preparación');
INSERT INTO tiendaTEC.ordenDeCompraEstado(detalle) VALUES ('en tránsito');
INSERT INTO tiendaTEC.ordenDeCompraEstado(detalle) VALUES ('cancelada');
INSERT INTO tiendaTEC.ordenDeCompraEstado(detalle) VALUES ('entregada');
INSERT INTO tiendaTEC.ordenDeCompraEstado(detalle) VALUES ('con retraso');
INSERT INTO tiendaTEC.ordenDeCompraEstado(detalle) VALUES ('extraviado');

/*Tabla Item*/


/*Tabla tipoRegistroAuditoria*/
INSERT INTO tiendaTEC.tipoRegistroAuditoria(detalle) VALUES ('cuponCreado');
INSERT INTO tiendaTEC.tipoRegistroAuditoria(detalle) VALUES('cuponAplicado');
INSERT INTO tiendaTEC.tipoRegistroAuditoria(detalle) VALUES('ordenCreada');
INSERT INTO tiendaTEC.tipoRegistroAuditoria(detalle) VALUES('cantidadMinimaSuperada');
INSERT INTO tiendaTEC.tipoRegistroAuditoria(detalle) VALUES('proveedorCreado'); 
INSERT INTO tiendaTEC.tipoRegistroAuditoria(detalle) VALUES('proveedorDadoDeBaja');

/*Tabla cuponDescuento*/
INSERT INTO tiendaTEC.cuponDescuento(detalleCodigo, porcentajeDescuento, fechaInicioVigencia, fechaFinVigencia, montoMinimoCompraParaAplicarCupon, disponibilidadTipo, estaActivo) VALUES('','','','','','','');
INSERT INTO tiendaTEC.cuponDescuento(detalleCodigo, porcentajeDescuento, fechaInicioVigencia, fechaFinVigencia, montoMinimoCompraParaAplicarCupon, disponibilidadTipo, estaActivo) VALUES('','','','','','','');
INSERT INTO tiendaTEC.cuponDescuento(detalleCodigo, porcentajeDescuento, fechaInicioVigencia, fechaFinVigencia, montoMinimoCompraParaAplicarCupon, disponibilidadTipo, estaActivo) VALUES('','','','','','','');
INSERT INTO tiendaTEC.cuponDescuento(detalleCodigo, porcentajeDescuento, fechaInicioVigencia, fechaFinVigencia, montoMinimoCompraParaAplicarCupon, disponibilidadTipo, estaActivo) VALUES('','','','','','','');
INSERT INTO tiendaTEC.cuponDescuento(detalleCodigo, porcentajeDescuento, fechaInicioVigencia, fechaFinVigencia, montoMinimoCompraParaAplicarCupon, disponibilidadTipo, estaActivo) VALUES('','','','','','','');

/*Tabla ordenCompraCancelada*/