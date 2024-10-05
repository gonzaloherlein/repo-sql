CREATE DATABASE modeloParcial

USE modeloparcial

CREATE TABLE cliente(
		codigoCliente INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		nombre VARCHAR(40),
		fecha_registro DATE,
		codigoCliente_FK INT NOT NULL,
		FOREIGN KEY (codigoCliente_FK) REFERENCES cliente(codigoCliente));
		
CREATE TABLE telefonoCliente(
		codigoTelefeno INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		telefono INT,
		codigoCliente_FK INT NOT NULL,
		FOREIGN KEY (codigoCliente_FK) REFERENCES cliente(codigoCliente));
		
CREATE TABLE computadora(
		numeroUnico INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		precio DECIMAL NOT NULL,
		modelo VARCHAR(40));
		
CREATE TABLE notebook(
		codigoNotebook INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		numeroUnicoComputadora INT NOT NULL,
		tamañoMonitor INT NOT NULL,
		wifi BOOLEAN,
		FOREIGN KEY (numeroUnicoComputadora) REFERENCES computadora(numeroUnico));
		
CREATE TABLE escritorio(
		codigoEscritorio INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		numeroUnicoComputadora INT NOT NULL,
		potenciaFuente INT NOT NULL,
		FOREIGN KEY (numeroUnicoComputadora) REFERENCES computadora(numeroUnico));
			
CREATE TABLE proveedor(
		cuit INT PRIMARY KEY NOT NULL,
		razon_social INT,
		tipo_iva VARCHAR(40));			
				
CREATE TABLE insumo(
		codigoInsumo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		nombre VARCHAR(40),
		marca VARCHAR(40),
		costo DECIMAL,
		tipo_consumo VARCHAR(40),
		cuit_prov INT NOT NULL,
		FOREIGN KEY (cuit_prov) REFERENCES proveedor (cuit));
		
CREATE TABLE telefonoProv(
		codigo_telefono_prov INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		telefono INT,
		cuit_proveedor INT NOT NULL,
		FOREIGN KEY (cuit_proveedor) REFERENCES proveedor(cuit));
		
CREATE TABLE compra(
		codigo_compra INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		codigo_cliente INT NOT NULL,
		codigo_computadora INT NOT NULL,
		fecha DATE,
		FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigoCliente),
		FOREIGN KEY (codigo_computadora) REFERENCES computadora(numeroUnico));
		
CREATE TABLE compuesto(
		codigo_compuesto INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		codigo_computadora INT NOT NULL,
		codigo_insumo INT NOT NULL,
		FOREIGN KEY (codigo_computadora) REFERENCES computadora(numeroUnico),
		FOREIGN KEY (codigo_insumo) REFERENCES insumo(codigoInsumo));