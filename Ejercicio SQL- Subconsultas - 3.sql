CREATE DATABASE if NOT EXISTS almacen_subconsultas;

USE almacen_subconsultas;

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
		(007, 5), 
		(005, 5); 

INSERT INTO compuesto_por(CodArt,CodMat) 
VALUES(001, 004),
		(001, 005),
		(001, 006),
		(001, 007);

-- #1 Listar los nombres de aquellos proveedores que no proveen ningún material.--
SELECT p.Nombre
FROM proveedor p
WHERE p.CodProv NOT IN (
				SELECT pr.codProv FROM provisto_por pr WHERE p.CodProv = pr.codProv)
				
-- #2 Listar los códigos y descripción de los materiales que provea el proveedor 2 y no los provea el proveedor 5
SELECT m.CodMat, m.Descripcion
FROM material m 
WHERE EXISTS (SELECT 1
					FROM provisto_por pr
					WHERE pr.CodProv = 2 AND m.CodMat = pr.CodMat)
AND NOT EXISTS (SELECT 1
					FROM provisto_por pr
					WHERE pr.CodProv = 5 AND m.CodMat = pr.CodMat)
					
-- #3 Listar número y nombre de almacenes que contienen los artículos de descripción ‘Pan’ y los de descripción ‘Facturas’ (ambos).
SELECT A.Nro, A.Nombre
FROM ALMACEN A
JOIN CONTIENE C1 ON A.Nro = C1.Nro
JOIN CONTIENE C2 ON A.Nro = C2.Nro
WHERE EXISTS (SELECT 1
					FROM ARTICULO Art1 
					JOIN ARTICULO Art2 ON C2.CodArt = Art2.CodArt
					WHERE Art1.Descripcion = 'Pan'
  					AND Art2.Descripcion = 'Facturas' AND C1.CodArt = Art1.CodArt);

-- #4 Listar la descripción de artículos compuestos por todos los materiales
SELECT A.Descripcion
FROM ARTICULO A
JOIN COMPUESTO_POR CP ON A.CodArt = CP.CodArt
GROUP BY A.CodArt, A.Descripcion
HAVING COUNT(DISTINCT CP.CodMat) = (SELECT COUNT(*) FROM material);

-- #5 Hallar los códigos y nombres de los proveedores que proveen al menos un material que se usa en algún artículo cuyo precio es mayor a $300
SELECT p.CodProv,p.Nombre
FROM proveedor p JOIN provisto_por pr ON p.CodProv = pr.CodProv 
					  JOIN material m ON pr.CodMat = m.CodMat
					  JOIN compuesto_por cp ON cp.CodMat = m.CodMat
WHERE EXISTS (SELECT 1
					FROM articulo a 
					WHERE a.Precio > 300 AND a.CodArt = cp.CodArt)
					
-- #6 Listar la descripción de los artículos de mayor precio 
SELECT a.Descripcion
FROM articulo a
WHERE a.Precio = (SELECT MAX(a2.Precio) FROM articulo a2)