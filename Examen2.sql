--TABLA DE CELULARES, NOMBRE DEL TELEFONO, MARCA, CANTIDAD
CREATE TABLE celulares (
    id INT PRIMARY KEY,
    nombre_telefono VARCHAR(100) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    cantidad INT NOT NULL
);
--INSERCCION DE 4 RGISTROS EN LA TABLA CELULARES
INSERT INTO celulares VALUES (1, 'iPhone 13', 'Apple', 50);
INSERT INTO celulares VALUES (2, 'Galaxy S21', 'Samsung', 30);
INSERT INTO celulares VALUES (3, 'Pixel 6', 'Google', 20);
INSERT INTO celulares VALUES (4, 'OnePlus 9', 'OnePlus', 15);

--MOSTRAR LOS NOMBRES DE LOS TELEFONOS Y SU CANTIDAD
SELECT nombre_telefono, cantidad FROM celulares;
--MOSTRAR LOS NOMBRES DE LOS TELEFONOS Y SU CANTIDAD ORDENADOS DE FORMA ASCENDENTE
select nombre_telefono, cantidad from celulares order by cantidad asc;
--MOSTRAR LA MARCA DE LOS TELEFONOS Y SU CANTIDAD MAYOR A 3
select marca, cantidad from celulares where cantidad > 3;
