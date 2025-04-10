USE Ecommerce;

--Grupo: Walter Mijangos y Luis Reyes


/*
?? Reto 1 � Top compradores del a�o
    Mostrar los 5 clientes que m�s dinero han gastado en total durante el �ltimo a�o, ordenados del mayor al menor.
*/

SELECT TOP 5
    c.cliente_id,
    CONCAT(c.nombre,' ',c.apellido) as Cliente,
    SUM(V.total_venta) AS Total_De_Gastos
FROM cli.clientes c 
JOIN sell.ventas v on c.cliente_id = v.cliente_id
WHERE YEAR(V.fecha_venta) = YEAR(GETDATE()) - 4  --A�o 2021 // Inge, la BD de Ecommerce tiene registros del a�o 2021. De 2022 - 2025 no hay registros 
GROUP BY c.cliente_id, CONCAT(c.nombre,' ',c.apellido)
ORDER BY Total_De_Gastos DESC;

--Aqui verifiqu� que hay registros solo del a�o 2021.
SELECT fecha_venta FROM sell.ventas 
WHERE YEAR(fecha_venta) = '2021'

/*
?? Reto 2 � Categor�as sin productos vendidos
    Encontrar las categor�as que no han tenido ning�n producto vendido.
*/

SELECT 
    c.categoria_id,
    c.categoria
FROM sell.categoria as c 
LEFT JOIN sell.productos as p ON c.categoria_id = p.categoria_id
LEFT JOIN sell.detalle_ventas dv ON p.producto_id = dv.producto_id
WHERE dv.producto_id IS NULL;

/*
?? Reto 3 � D�as con mayor volumen de ventas
   Listar los 3 d�as con m�s cantidad de productos vendidos (sumando todas las ventas del d�a).
*/

SELECT 
	TOP 3
	v.fecha_venta,
	SUM(dv.cantidad) productos_vendidos
FROM sell.detalle_ventas AS dv
JOIN sell.ventas AS v ON dv.venta_id = v.venta_id
GROUP BY v.fecha_venta
ORDER BY productos_vendidos DESC


/*
?? Reto 4 � Productos con mejor desempe�o en stock
    Mostrar los productos que han vendido m�s del 50% de su stock actual.
*/

SELECT 
    p.producto_id,
    p.nombre_producto,
    p.stock,
    SUM(dv.cantidad) as Cantidad_Vendida
FROM sell.productos as p 
JOIN sell.detalle_ventas as dv ON p.producto_id = dv.producto_id
GROUP BY p.producto_id, p.nombre_producto, p.stock
HAVING SUM(dv.cantidad) > (p.stock * 0.5);


/*
?? Reto 5 � Clientes sin compras pero con carritos
    Encontrar los clientes que no han realizado ninguna compra, pero tienen al menos un carrito creado.
*/

SELECT 
	c.cliente_id,
	CONCAT(c.nombre,' ',c.apellido) as Cliente
FROM cli.clientes AS c
JOIN sell.carrito_compras AS ca ON c.cliente_id = ca.cliente_id
LEFT JOIN sell.ventas v ON c.cliente_id = v.cliente_id
WHERE v.venta_id IS NULL
GROUP BY c.cliente_id, CONCAT(c.nombre,' ',c.apellido)
Order BY c.cliente_id 
