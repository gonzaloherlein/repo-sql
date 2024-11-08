CREATE DATABASE if NOT EXISTS agregacion;

USE agregacion;

CREATE TABLE ALMACEN(
		Nro INT(5) PRIMARY KEY,
		Nombre VARCHAR(20) NOT NULL,
		Responsable VARCHAR(50) NOT NULL);
CREATE TABLE ARTICULO(
		CodArt INT(5) PRIMARY KEY,
		Descripcion VARCHAR (50) NOT NULL,
		Precio DOUBLE);
CREATE TABLE MATERIAL(
		CodMat INT(6) PRIMARY KEY,
		Descripcion VARCHAR(100) NOT NULL);
CREATE TABLE CIUDAD(
		CodCiudad INT(2) PRIMARY KEY,
		Nombre VARCHAR(100) NOT NULL);
CREATE TABLE PROVEEDOR(
		CodProv INT(5) PRIMARY KEY,
		Nombre VARCHAR(20) NOT NULL,
		Domicilio VARCHAR(100),
		CodCiudad INT(2) NOT NULL,
		FOREIGN KEY (CodCiudad) REFERENCES Ciudad (CodCiudad));
CREATE TABLE CONTIENE(
		Cod_Contiene INT(3) PRIMARY KEY AUTO_INCREMENT,
		Nro INT(5) NOT NULL,
		CodArt INT(5) NOT NULL,
		FOREIGN KEY (Nro) REFERENCES ALMACEN (Nro),
		FOREIGN KEY (CodArt) REFERENCES ARTICULO (CodArt));
CREATE TABLE COMPUESTO_POR(
		Cod_Composicion INT(3) PRIMARY KEY AUTO_INCREMENT,
		CodArt INT(5) NOT NULL,
		CodMat INT(6) NOT NULL,
		FOREIGN KEY (CodArt) REFERENCES ARTICULO (CodArt),
		FOREIGN KEY (CodMat) REFERENCES MATERIAL (CodMat));
CREATE TABLE PROVISTO_POR(
		Cod_Provisto INT(3) PRIMARY KEY AUTO_INCREMENT,
		CodMat INT(6) NOT NULL,
		CodProv INT(5) NOT NULL,
		FOREIGN KEY (CodMat) REFERENCES MATERIAL (CodMat),
		FOREIGN KEY (CodProv) REFERENCES PROVEEDOR (CodProv));

INSERT INTO ALMACEN (Nro, Nombre, Responsable)
VALUES (001, 'La Original', 'Alfredo'),
(002, 'Galpon', 'Esteban'),
(003, 'Almacen de Don Juan', 'Juan'),
(004, 'La Tiendita', 'Roberto');
INSERT INTO ARTICULO (CodArt, Descripcion, Precio)
VALUES (001, 'Pan', 130.70),
(002, 'Facturas', 300.00),
(003, 'Cheese Cake', 450.87),
(004, 'Pasta Frola', 278.90);
INSERT INTO MATERIAL (CodMat, Descripcion)
VALUES (001, 'Aceite'),
(002, 'Harina'),
(003, 'Levadura'),
(004, 'Huevo'),
(005, 'Azucar'),
(006, 'Sal'),
(007, 'Agua');
INSERT INTO CIUDAD(CodCiudad, Nombre)
VALUES (1, 'La Plata'),
(2, 'Capital Federal'),
(3, 'Ramos Mejia'),
(4, 'La Matanza');
INSERT INTO PROVEEDOR (CodProv, Nombre, Domicilio,
CodCiudad)
VALUES(1, 'Arcor', 'Ayacucho 1234', 1),
(2, 'Molinos', 'Yatay 456', 4),
(3, 'Ledesma', 'Mario Bravo 987', 1),
(4, 'Marolio', 'Potosi 098', 2),
(5, 'Glaciar', 'Sarmiento 555', 3),
(6, 'Johnson', 'Potosi 123', 1);
INSERT INTO CONTIENE (Nro, CodArt)
VALUES (001, 001),
(001, 002),
(001, 003),
(001, 004),
(002, 003),
(002, 004),
(003, 001),
(004, 002);
INSERT INTO COMPUESTO_POR (CodArt, CodMat)
VALUES(001, 001),
(001, 002),
(001, 003),
(002, 002),
(002, 005),
(002, 007),
(003, 001),
(003, 002),
(003, 006),
(004, 007);
INSERT INTO PROVISTO_POR(CodMat, CodProv)
VALUES (001, 1),
(002, 3),
(003, 5),
(004, 4),
(005, 2),
(006, 2),
(007, 5);


-- #1 Indicar la cantidad de proveedores que comienzan con la letra L
SELECT COUNT(*)
FROM proveedor p
WHERE p.Nombre LIKE 'L%';

-- #2 Listar el promedio de precios de los artículos por cada almacén (nombre).
SELECT al.Nro, al.Nombre, round(AVG(ar.Precio),2) AS Promedio_Precios
FROM articulo ar JOIN contiene co ON ar.CodArt = co.CodArt
					  JOIN almacen al ON co.Nro = al.Nro
GROUP BY al.Nro, al.Nombre;

-- #3 Listar la descripción de artículos compuestos por al menos 2 materiales
SELECT A.CodArt, COUNT(*) Cant_mat_art
FROM ARTICULO A JOIN COMPUESTO_POR CP
ON A.CodArt = CP.CodArt
GROUP BY A.CodArt;


SELECT ar.CodArt, ar.Descripcion
FROM articulo ar JOIN compuesto_por cp ON ar.CodArt = cp.CodArt
GROUP BY ar.CodArt,ar.Descripcion
HAVING COUNT(*) >= 2;

-- #4  Listar cantidad de materiales que provee cada proveedor, el código,nombre y domicilio del proveedor.
SELECT pr.CodProv, pr.Nombre, pr.Domicilio, COUNT(pp.CodMat) AS Cantidad_Materiales
FROM proveedor pr JOIN provisto_por pp ON pr.CodProv = pp.CodProv
GROUP BY pr.CodProv, pr.Nombre, pr.Domicilio;

-- #5  Cuál es el precio máximo de los artículos que estan compuestos por materiales que proveen los proveedores de la ciudad de La Plata
SELECT ar.CodArt, ar.Descripcion, MAX(ar.Precio) AS Precio_Maximo
FROM articulo ar JOIN compuesto_por cp ON ar.CodArt = cp.CodArt
					  JOIN provisto_por pp ON cp.CodMat = pp.CodMat
					  JOIN proveedor pr ON pp.CodProv = pr.CodProv
					  JOIN ciudad ci ON pr.CodCiudad = ci.CodCiudad
where ci.Nombre = 'La Plata';

-- #6 Listar los nombres de aquellos proveedores que no proveen ningún material.
SELECT pr.CodProv, pr.Nombre
FROM proveedor pr LEFT JOIN provisto_por pp ON pr.CodProv = pp.CodProv
WHERE PP.CodMat IS NULL;


