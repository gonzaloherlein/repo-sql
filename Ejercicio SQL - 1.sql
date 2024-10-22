CREATE SCHEMA IF NOT EXISTS almacen;

USE almacen;

CREATE TABLE fabricante(
			codigo INT(10) PRIMARY KEY,
			nombre VARCHAR(100)
);

CREATE TABLE producto(
			codigo INT(10) PRIMARY KEY,
			nombre VARCHAR(100) NOT null,
			precio DOUBLE NOT NULL,
			codigo_fab INT(10),
			FOREIGN KEY (codigo_fab) REFERENCES fabricante(codigo)
);

INSERT INTO fabricante (codigo,nombre) VALUES (001,"Arcor"),
				(002, 'Marolio'), 
				(003, 'Molinos'), 
				(004, 'Johnson'), 
				(005, 'Ledesma'), 
				(006, NULL);
				
INSERT INTO PRODUCTO (CODIGO, NOMBRE, PRECIO, CODIGO_FAB) 
VALUES (0001, 'Azucar', 100.80, 005), 
		(0002, 'Mayonesa', 70.65, 003), 
		(0003, 'Jabon Liquido', 400.00, 004), 
		(0004, 'Spaghetti', 81.90, 001), 
		(0005, 'Tomate en lata', 95.00, 001), 
		(0006, 'Desodorante Dove', 321.20, 004), 
		(0007, 'Yerba', 324.80, 005), 
		(0008, 'Ketchup', 56.78, 003), 
		(0009, 'Sal', 65.00, 001), 
		(0010, 'Aceite', 230.50, 002); 

ALTER TABLE producto CHANGE codigo codigo_prod INT(10);


-- Consultas

-- #1
SELECT nombre,precio
FROM producto

-- #2
SELECT * FROM producto

-- #3 
SELECT nombre, precio AS precioARS,(precio / 122) AS precioEURO, (precio / 117) AS precioUSD FROM producto

-- #4
SELECT nombre,precio FROM producto WHERE nombre LIKE "%ESA"

-- #5
SELECT nombre,precio FROM producto WHERE nombre LIKE "A%"

-- #6
SELECT nombre, UPPER(SUBSTRING(nombre,1,2)) AS Iniciales FROM fabricante

-- #7
SELECT nombre, precio AS "Precio Original", ROUND(precio,0) AS "Precio Redondeado" FROM producto

-- #8
SELECT nombre, precio AS "Precio Origianl", TRUNCATE(precio,0) AS "Precio Truncado" FROM producto

-- #9
SELECT distinct codigo AS "Codigo Fabricante" FROM fabricante f,producto p WHERE f.codigo = p.codigo_fab

-- #10
SELECT nombre FROM fabricante ORDER BY nombre ASC

-- #11
SELECT nombre FROM fabricante ORDER BY nombre DESC

-- #12
SELECT nombre, precio FROM producto ORDER BY nombre ASC, precio DESC

-- #13
SELECT * FROM fabricante LIMIT 5

-- #14
SELECT nombre,precio FROM producto ORDER BY precio ASC LIMIT 1

-- #15
SELECT nombre,precio FROM producto ORDER BY precio DESC LIMIT 1

-- #16
SELECT nombre FROM producto WHERE codigo_fab = 002

-- #17
SELECT nombre FROM producto WHERE ( precio / 122 ) <= 1

-- #18
SELECT nombre FROM producto WHERE ( precio / 122 ) >= 1 AND ( precio / 122 ) <= 3

-- #19
SELECT nombre FROM producto WHERE ( precio / 122 ) BETWEEN 1 AND 3

-- #20
SELECT * FROM producto WHERE ( precio / 122 ) > 2 AND codigo_fab = 004

-- #21
SELECT * FROM producto WHERE codigo_fab = 001 OR codigo_fab = 002 OR codigo_fab = 005

-- #22
SELECT * FROM producto WHERE codigo_fab IN (001,002,005)

-- #23
SELECT nombre,precio, (precio * 100) AS centavos FROM producto

-- #24
SELECT nombre FROM fabricante WHERE nombre LIKE "L%"

-- #25
SELECT nombre FROM fabricante WHERE nombre LIKE "%O"

-- #26
SELECT nombre FROM fabricante WHERE nombre LIKE "%H%"

-- #27
SELECT codigo FROM fabricante WHERE nombre IS NULL

-- #28
SELECT nombre FROM producto WHERE nombre LIKE "%Mayo%"

-- #29
SELECT nombre FROM producto WHERE nombre LIKE "%Ket%" AND precio < 200

-- #30
SELECT nombre, precio FROM producto WHERE precio >= 180 ORDER BY precio DESC, nombre ASC
