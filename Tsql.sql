USE prueba1;

--Función #1 -------------------------------------------------------------------------------------

CREATE FUNCTION productoMasVendido(@fecha1 date,@fecha2 date)
RETURNS table
RETURN(
    SELECT TOP 1 tiendaTEC.item.idProducto,count(tiendaTEC.item.idProducto) AS cantidad
    FROM tiendaTEC.ordenCompra JOIN tiendaTEC.item 
    ON ordenCompra.idOrden=item.idOrden
    WHERE ordenCompra.fecha BETWEEN @fecha1 and @fecha2
    GROUP BY item.idProducto
    ORDER BY cantidad DESC 
    )

select * from productoMasVendido('2019-10-10','2019-09-09')

--Función #2 -------------------------------------------------------------------------------------

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

Exec descuentoAplicado @cuponDescuento='20'

--Función #3 -------------------------------------------------------------------------------------

CREATE FUNCTION promedialCompras (@cedulaCliente int, @fecha date) 
RETURNS int
AS
BEGIN
DECLARE @mes int;
DECLARE @year int;
DECLARE @promedioCompras as int;
SET @mes = CAST(MONTH(@fecha) as int);
SET @year = CAST(YEAR(@fecha) as int);

SET @promedioCompras =(SELECT AVG(comprasPromedio.montoTotal) FROM ordenDeCompra AS montoPromedio WHERE @mes = CAST(MONTH(montoPromedio.fecha) as int) 
AND @year = CAST(YEAR(montoPromedio.fecha) as int) AND @cedulaCliente= montoPromedio.cedulaCliente);

RETURN @promedioCompras

END;

--Procedimiento Almacenado #4 -------------------------------------------------------------------------------------

(FALTA)

--Procedimiento almacenado #5
CREATE PROCEDURE cuponesVigentes @fecha1 date, @fecha2 date
AS 
SELECT * FROM tiendaTEC.cuponDescuento
WHERE cuponDescuento.fechaInicioVigencia BETWEEN @fecha1 AND @fecha2 
AND cuponDescuento.fechaFinVigencia BETWEEN @fecha1 AND @fecha2
GO

--Procedimiento almacenado #6 -------------------------------------------------------------------------------------

(FALTA)

--Procedimiento almacenado #7 -------------------------------------------------------------------------------------
CREATE PROCEDURE nuevoProducto
@idProducto as int,
@nombre as varchar (100),
@idProveedor as int,
@precioUnitario as int,
@estado as int,

@cantDisponible as int,
@cantMinPermitida as int,
@fechaIngreso as date

AS
BEGIN
INSERT INTO tiendaTEC.producto (idProducto,nombre,idProveedor,precioUnitario,estaDescontinuado) VALUES (@idProducto,@nombre,
@idProveedor,@precioUnitario,@estado);
INSERT INTO tiendaTEC.inventarioProductos (idProducto,cantidadDisponible,cantidadMinimaPermitida,fechaIngreso) VALUES (@idProducto,@cantDisponible,
@cantMinPermitida,@fechaIngreso);

END;

--Trigger #8 -------------------------------------------------------------------------------------

CREATE TRIGGER cantidadMinimaPermitida
ON tiendaTEC.inventario
AFTER UPDATE
AS
IF EXISTS(select * from tiendaTEC.inventario where cantidadDisponible < cantidadMinimaPermitida)
	BEGIN
		declare @producto varchar(50)
		declare @correoDepartamental varchar(50)
		set @producto = (select top 1 nombre+' necesita reabastecer' from tiendaTEC.producto P inner join tiendaTEC.inventario I on I.idProducto = P.idProducto)
		set @correoDepartamental = (select tiendaTEC.departamento.detalle from tiendaTEC.departamento cd inner join Departamento d on d.idDepartamento = 
		cd.idDepartamento where cd.idDepartamento = 1)
		EXEC msdb.dbo.sp_send_dbmail
		  @profile_name ='Tienda TEC Administracion',
		  @recipients = @correoDepartamental, 
		  @subject = 'Notificacion de cantidad minima permitida', 
		  @body = @producto;
		set nocount on;
	END

--Trigger #9 -------------------------------------------------------------------------------------

CREATE TRIGGER auditoriaOrdenes ON tiendaTEC.ordenCompraCancelada
AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO tiendaTEC.ordenCancelada (
			idOrden, 
			fechaCancelacion
	)
SELECT
	i.idOrden,
	GETDATE()
FROM
	inserted i
END

--Trigger #10 -------------------------------------------------------------------------------------

CREATE TRIGGER auditoriaProveedor ON tiendaTEC.proveedores
AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO tiendaTEC.bitacoraRegistroAuditoria(
		fechaHora,  
		idTipoRegistroAuditoria, 
		idEmpleado
	)
SELECT
	GETDATE(),
	ii.idTipoRegistroAuditoria,
	ii.idEmpleado
FROM
	inserted2 ii
END

--View #11 -------------------------------------------------------------------------------------

CREATE VIEW informaciónClienteCompras  AS   
SELECT tiendaTEC.cliente.idPais, tiendaTEC.cliente.idProvinciaEstado, tiendaTEC.cliente.tipoCliente,tiendaTEC.cliente.categoria,tiendaTEC.cliente.senas,tiendaTEC.ordenCompra.fecha,tiendaTEC.ordenCompra.montoDescuento,tiendaTEC.ordenCompra.montoTotal,tiendaTEC.ordenCompra.fechaAplicacionDescuento
FROM tiendaTEC.cliente, tiendaTEC.ordenCompra
WHERE tiendaTEC.ordenCompra.idCuponDescuento IS NULL
GO 

--View #12 -------------------------------------------------------------------------------------

CREATE VIEW ordenesCanceladas 
AS  
SELECT idOrden, cedulaCliente, fechaCancelacion, explicacionCliente
FROM tiendaTEC.ordenCompraCancelada
WHERE CAST(MONTH(getdate()) as int) = CAST(MONTH(fechaCancelacion) as int) 
GROUP BY cedulaCliente, idOrden, fechaCancelacion, explicacionCliente;  
GO

--Vista #13 -------------------------------------------------------------------------------------

CREATE VIEW productosNoVendidos AS
SELECT nombre
FROM tiendaTEC.producto a, tiendaTEC.item b
WHERE a.idProducto <> b.idProducto;

--Indice #14 ------------------------------------------------------------------------------------

CREATE NONCLUSTERED INDEX IDX_cliente
ON tiendaTEC.cliente (categoria, tipoCliente);

CREATE NONCLUSTERED INDEX IDX_producto
ON tiendaTEC.producto (precioUnitario,estaDescontinuado);

CREATE NONCLUSTERED INDEX IDX_item
ON tiendaTEC.item (monto,cantidad,idOrden,idProducto);

CREATE INDEX IDX_ordenCompra
ON tiendaTEC.ordenCompra (fecha,idOrden,montoTotal,idEstado,montoDescuento,idCuponDescuento,fechaAplicacionDescuento);

CREATE NONCLUSTERED INDEX IDX_ordenCompraCancelada
ON tiendaTEC.ordenCompraCancelada (fechaCancelacion,explicacionCliente,cedulaCliente)

CREATE NONCLUSTERED INDEX IDX_clienteFisico
ON tiendaTEC.clienteFisico (primerNombre,segundoNombre, primerApellido, segundoApellido, idGenero)

CREATE NONCLUSTERED INDEX IDX_clienteJuridico
ON tiendaTEC.clienteFisico (razonSocial)

CREATE NONCLUSTERED INDEX IDX_inventario
ON tiendaTEC.inventario (cantidadDisponible,fechaIngreso,cantidadMinimaPermitida)

CREATE NONCLUSTERED INDEX IDX_bitacoraRegistroAuditoria
ON tiendaTEC.bitacoraRegistroAuditoria (idTipoRegistroAuditoria,fechaHora,idEmpleado,detalle)

