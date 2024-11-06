CREATE DATABASE if NOT EXISTS alquilerdeautos;

USE alquilerdeautos;

CREATE TABLE Marca( 
		IdMarca INT(5) PRIMARY KEY AUTO_INCREMENT, 
		Descripcion VARCHAR(20) NOT NULL); 
CREATE TABLE Vehiculo( 
		Patente VARCHAR(10) PRIMARY KEY, 
		Color VARCHAR(20) NOT NULL, 
		Anio INT (5) NOT NULL, 
		Capacidad INT(5), 
		Puertas INT (5), 
		IdMarca INT(5), 
		FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca)); 
CREATE TABLE Localidad (
		idLocalidad INT(5) PRIMARY KEY AUTO_INCREMENT, 
		Descripcion VARCHAR(50) NOT NULL); 
CREATE TABLE Cliente( 
		Legajo INT(5) PRIMARY KEY, 
		Nombre VARCHAR (50) NOT NULL, 
		Apellido VARCHAR (50) NOT NULL, 
		Telefono VARCHAR(50), 
		idLocalidad INT(5), 
		FOREIGN KEY (idLocalidad) references Localidad (idLocalidad)); 
CREATE TABLE Alquiler (
		Id INT(5) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
		Patente VARCHAR(10) NOT NULL, 
		legCliente INT(5) NOT NULL, 
		FechaAlquiler DATE NOT NULL, 
		Importe DOUBLE NOT NULL, 
		CantDias INT(5), 
		FOREIGN KEY (Patente) references Vehiculo (Patente), 
		FOREIGN KEY (legCliente) references Cliente (Legajo)); 
		
INSERT INTO LOCALIDAD (Descripcion) 
VALUES ('Ramos Mejia'), ('Laferrere'), ('San Justo'), ('Haedo'); 

INSERT INTO Cliente (Legajo, Nombre, Apellido, Telefono, idLocalidad) 
VALUES (1, 'Juan', 'Pepe', '1530111222339', 1), 
(2, 'Santiago', 'Molinos', '1530222333448', 1), 
(3, 'Ricardo', 'Marolio', '1530333444557', 2), 
(4, 'Roberto', 'Ledesma', '1530444555666', 3), 
(5, 'Alberto', 'Johnson', '1530555666775', 4); 

INSERT INTO Marca (Descripcion) 
VALUES ('Nissan'), 
('Renault'), 
('Ford'), 
('Volkswagen'), 
('Fiat'); 

INSERT INTO Vehiculo(Patente, Color, Anio, Capacidad, Puertas, IdMarca) 
VALUES ('AAA111', 'Azul', 2021, 2, 3, 1), 
('AAA112', 'Rojo', 2010, 10, 5, 2), 
('AAA113', 'Violeta', 2022, 11, 3, 3), 
('AAA114', 'Naranja', 1990, 5, 5, 1), 
('AAA115', 'Verde', 1994, 6, 3, 4), 
('AAA116', 'Azul', 2020, 11, 2, 2), 
('AAA117', 'Blanco', 1998, 9, 3, 5), 
('FFF555', 'Negro' , 2019, 4, 5, 1); 

INSERT INTO Alquiler(Patente, legCliente, FechaAlquiler, Importe, CantDias) 
VALUES ('AAA111', 1, '2020-01-01', 300.00, 5), 
('AAA111', 2, '2020-02-01', 700.00, 6), 
('AAA112', 1, '2020-03-01', 100.00, 1), 
('AAA111', 3, '2020-03-01', 3000.00, 15), 
('AAA112', 3, '2020-03-01', 200.00, 2), 
('AAA113', 3, '2021-10-01', 1000.00, 6), 
('AAA115', 1, '2021-07-01', 15000.00, 31), 
('FFF555', 3, '2022-01-31', 500.00, 9), 
('AAA114', 5, '2020-02-20', 4000.00, 8);
		
-- Consulta #2 --
-- Obtener los datos de todos los vehículos, ordenados por marca (descripción) y patente --
SELECT *
FROM vehiculo
ORDER BY (SELECT descripcion 
				FROM marca 
				WHERE marca.IdMarca = vehiculo.IdMarca), patente
				
-- Consulta #3 --
-- Para cada marca, informar la cantidad de vehículos total y máxima capacidad, 
-- únicamente para aquellos vehículos con más de 4 puertas --

SELECT 
    m.Descripcion AS Marca,
    COUNT(v.Patente) AS Cantidad_Vehiculos,
    MAX(v.Capacidad) AS Maxima_Capacidad
FROM 
    Marca m
JOIN 
    (SELECT 
        Patente, 
        IdMarca, 
        Capacidad 
     FROM 
        Vehiculo 
     WHERE 
        Puertas > 4) v 
ON 
    m.IdMarca = v.IdMarca
GROUP BY 
    m.Descripcion;

-- #4 --
SELECT c.Legajo,
       c.Nombre,
       c.Apellido,
       a.Patente,
       v.Color,
       a.FechaAlquiler,
       a.Importe,
       (a.Importe * 0.15) AS Impuestos
FROM Cliente c
JOIN Alquiler a ON c.Legajo = a.legCliente
JOIN Vehiculo v ON a.Patente = v.Patente
WHERE a.FechaAlquiler IN (
       SELECT FechaAlquiler
       FROM Alquiler
       WHERE MONTH(FechaAlquiler) = 2 AND YEAR(FechaAlquiler) = 2020
);

-- #5 --
INSERT INTO Vehiculo(Patente, Color, Anio, Capacidad, Puertas, IdMarca) 
VALUES ('ABC234', 'Rojo', 2021,5,4,5)

-- #6 --
UPDATE vehiculo SET Color = 'Gris' WHERE Patente = 'FFF555';

-- 7 --
SELECT v.patente
FROM vehiculo v
WHERE v.Capacidad = (SELECT MAX(capacidad) FROM vehiculo)

-- 8 --
SELECT c.*
FROM cliente c
WHERE EXISTS (SELECT 1 FROM alquiler a JOIN vehiculo v ON a.Patente = v.Patente 
					JOIN marca m ON v.IdMarca = m.IdMarca
					WHERE m.descripcion = 'Nissan' AND a.legCliente = c.legajo)
AND NOT EXISTS(SELECT 1 FROM alquiler a JOIN vehiculo v ON a.Patente = v.Patente 
					JOIN marca m ON v.IdMarca = m.IdMarca
					WHERE m.descripcion = 'Ford' AND a.legCliente = c.legajo);
					
-- 9 -- 
SELECT a.Patente,
       (SELECT SUM(a2.Importe) 
        FROM Alquiler a2
        WHERE a2.Patente = a.Patente) AS Importe_Total_Alquiler,
       (SELECT COUNT(a2.Patente) 
        FROM Alquiler a2
        WHERE a2.Patente = a.Patente) AS Cantidad_Alquileres
FROM Alquiler a
GROUP BY a.Patente
HAVING (SELECT COUNT(a2.Patente) 
        FROM Alquiler a2
        WHERE a2.Patente = a.Patente) > 1;
        
-- 10 --
SELECT distinct c.*
FROM cliente c
WHERE EXISTS (
			SELECT 1 
			FROM alquiler a
			WHERE a.legCliente = c.Legajo AND a.FechaAlquiler BETWEEN '2020-01-01' AND '2020-03-31'
			GROUP BY a.legCliente
			HAVING COUNT(a.Id) > 1);