USE prueba1;

/*Función #1 */
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

Exec descuentoAplicado @cuponDescuento='20'

/*Procedimiento almacenado #5*/
CREATE PROCEDURE cuponesVigentes @fecha1 date, @fecha2 date
AS 
SELECT * FROM tiendaTEC.cuponDescuento
WHERE cuponDescuento.fechaInicioVigencia BETWEEN @fecha1 AND @fecha2 
AND cuponDescuento.fechaFinVigencia BETWEEN @fecha1 AND @fecha2
GO

/*Procedimiento almacenado #6*/



/*Trigger #9*/
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

/*Trigger #10*/
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

/*Vista #13 */
CREATE VIEW productosNoVendidos AS
SELECT nombre
FROM tiendaTEC.producto a, tiendaTEC.item b
WHERE a.idProducto <> b.idProducto;