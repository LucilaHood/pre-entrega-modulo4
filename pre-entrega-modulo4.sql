-- 1) Rentabilidad por categoria 
-- Permite identificar cuales son las categorias que mas ingresos generan. Estableciendo un umbral de $100000 para identificar.

SELECT c.nombre AS categoria,
	SUM(v.cantidad) AS unidades_vendidas,
	SUM(v.cantidad * p.precio) AS ingreso_total
FROM ventas AS v
INNER JOIN productos AS p
ON v.id_producto = p.id_producto 
INNER JOIN categorias AS c
ON p.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING SUM(v.cantidad * p.precio) > 100000
ORDER BY ingreso_total DESC;

-- 2) clientes sin compras 
-- Permite identificar a aquellos clientes que aun no realizaron compras para poder incentivarlos con alguna promoción.

SELECT c.nombre AS cliente,
	COALESCE(v.cantidad, 0) AS unidades_compradas
FROM clientes AS c
LEFT JOIN ventas AS v
ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- 3) Top compras por cliente
--Permite identificar el producto mas comprado por cliente y asi realizar promociones personalizadas  
SELECT c.nombre AS cliente,
	MAX(v.fecha) AS ultima_compra,
	
	(SELECT p.nombre
	FROM ventas AS compras
	INNER JOIN productos AS p
	ON compras.id_producto = p.id_producto
	WHERE compras.id_cliente = c.id_cliente
    GROUP BY p.nombre
    ORDER BY COUNT(*) DESC
    LIMIT 1) AS producto_mas_comprado

FROM clientes AS c 
INNER JOIN ventas AS v
ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre;


