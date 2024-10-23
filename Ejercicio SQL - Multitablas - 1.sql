CREATE DATABASE if NOT EXISTS almacen_unlam;

USE almacen_unlam;

CREATE TABLE almacen(
			nro INT(5) PRIMARY KEY,
			responsable VARCHAR(50) NOT null
);

CREATE TABLE articulo(
			cod_art INT(5) PRIMARY KEY,
			descripcion VARCHAR(50) NOT NULL,
			precio double
);

CREATE TABLE material(
			cod_mat INT(6) PRIMARY KEY,
			descripcion VARCHAR(100) NOT null
);

CREATE TABLE ciudad(
			cod_ciudad INT(2) PRIMARY KEY,
			nombre VARCHAR(100) NOT null
);

CREATE TABLE proveedor(
			cod_prov INT(5) PRIMARY KEY,
			nombre VARCHAR(20) NOT NULL,
			domicilio VARCHAR(100),
			cod_ciudad INT(2) NOT NULL,
			FOREIGN KEY (cod_ciudad) REFERENCES ciudad(cod_ciudad)
);

CREATE TABLE contiene(
			cod_contiene INT(3) PRIMARY KEY AUTO_INCREMENT,
			nro INT(5) NOT NULL,
			cod_art INT(5) NOT NULL,
			FOREIGN KEY (nro) REFERENCES almacen(nro),
			FOREIGN KEY (cod_art) REFERENCES articulo(cod_art)
);

CREATE TABLE compuesto_por(
			cod_composicion INT(3) PRIMARY KEY AUTO_INCREMENT,
			cod_art INT(5) NOT NULL,
			cod_mat INT(6) NOT NULL,
			FOREIGN KEY (cod_art) REFERENCES articulo (cod_art),
			FOREIGN KEY (cod_mat) REFERENCES material (cod_mat)
);

CREATE TABLE provisto_por(
			cod_provisto INT(3) PRIMARY KEY AUTO_INCREMENT,
			cod_mat INT(6) NOT NULL,
			cod_prov INT(5) NOT NULL,
			FOREIGN KEY (cod_mat) REFERENCES material (cod_mat),
			FOREIGN KEY (cod_prov) REFERENCES proveedor (cod_prov)
);

INSERT INTO almacen (nro,responsable) VALUES (001,"Alfredo"),(002,"Esteban"),(003,"Juan"),(004,"Roberto")

INSERT INTO articulo (cod_art,descripcion,precio) VALUES (001,"Pan", 130.70),(002,"Facturas", 300.00),(003,"Cheese Cake", 450.87),(004,"Pasta Frola", 278.90)

INSERT INTO material (cod_mat,descripcion) VALUES (001,"Aceite"),(002,"Harina"),(003,"Levadura"),(004,"Huevo"),(005,"Azucar"),(006,"Sal"),(007,"Agua")

INSERT INTO ciudad (cod_ciudad,nombre) VALUES (1, "La Plata"),(2, "Capital Federal"),(3, "Ramos Mejia"),(4, "La Matanza")

INSERT INTO proveedor (cod_prov,nombre,domicilio,cod_ciudad) VALUES (1,"Arcor","Ayacucho 1234",1),(2,"Molinos","Yatay 456",4),(3,"Ledesma","Mario Bravo 987",1),
				(4,"Marolio","Potosi 098",2),(5,"Glaciar","Sarmiento 555",3)

INSERT INTO contiene (nro, cod_art) VALUES (001,001),(001,002),(001,003),(001,004),(002,003),(002,004),(003,001),(004,002)

INSERT INTO compuesto_por (cod_art,cod_mat) VALUES (001, 001), (001, 002), (001, 003), (002, 002), (002, 005), (002, 007), (003, 001), (003, 002), (003, 006), (004, 007);

INSERT INTO PROVISTO_POR(cod_mat, cod_prov) VALUES (001, 1), (002, 3), (003, 5), (004, 4), (005, 2), (006, 2), (007, 5); 

-- Consultas --

-- #1
SELECT p.nombre, c.nombre
FROM proveedor p,ciudad c
WHERE p.cod_ciudad = c.cod_ciudad

-- #2
SELECT nombre
FROM proveedor 
WHERE cod_ciudad = 1

-- #3
SELECT distinct a.nro
FROM almacen a JOIN contiene co ON a.nro = co.nro JOIN articulo ar ON ar.cod_art = co.cod_art
WHERE ar.descripcion LIKE "P%"

-- #4
SELECT distinct a.nro, a.responsable
FROM almacen a JOIN contiene co ON a.nro = co.nro JOIN articulo ar ON ar.cod_art = co.cod_art
WHERE ar.descripcion LIKE "P%"

-- #5
SELECT m.*
FROM material m JOIN provisto_por pro ON m.cod_mat = pro.cod_mat JOIN proveedor prov ON prov.cod_prov = pro.cod_prov
WHERE prov.cod_ciudad = 4

-- #6
SELECT prov.nombre
FROM proveedor prov JOIN provisto_por pro ON prov.cod_prov = pro.cod_prov JOIN material mat ON pro.cod_mat = mat.cod_mat JOIN compuesto_por com ON com.cod_mat = mat.cod_mat 
							JOIN articulo ar ON ar.cod_art = com.cod_art JOIN contiene co ON co.cod_art = ar.cod_art JOIN almacen alm ON alm.nro = co.nro
WHERE alm.responsable LIKE "Roberto"