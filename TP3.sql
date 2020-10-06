-- noinspection SqlNoDataSourceInspectionForFile

-- Ejercicio 1

DROP TABLE empleado;

CREATE TABLE empleado (
    tipo_e char(1) NOT NULL,
    nro_E integer NOT NULL,
    nombre varchar(30) NOT NULL,
    cargo varchar(20) NOT NULL,
    CONSTRAINT pk_empleado PRIMARY KEY (tipo_e, nro_e)
);

select * from empleado;

DROP TABLE trabaja_en;

CREATE TABLE trabaja_en (
    tipo_e char(1) NOT NULL,
    nro_e integer NOT NULL,
    id_proy integer NOT NULL,
    anio integer NOT NULL,
    mes integer NOT NULL,
    cant_horas integer NOT NULL ,
    tarea varchar(10) NOT NULL ,
    CONSTRAINT pk_trabaja_en PRIMARY KEY (anio, mes),
    CONSTRAINT fk_trabaja_en_a_empleado FOREIGN KEY (tipo_e, nro_e)
                        REFERENCES empleado (tipo_e, nro_E)
                        ON UPDATE RESTRICT
                        ON DELETE CASCADE
);

select * from trabaja_en;

DROP TABLE proyecto;

CREATE TABLE proyecto (
    id_proy integer NOT NULL ,
    nombre_proy varchar(10) NOT NULL ,
    anio_comienzo integer NOT NULL ,
    anio_final integer NULL ,
    CONSTRAINT pk_proyecto PRIMARY KEY (id_proy)
);

select * from proyecto;

DROP TABLE auspicio;

CREATE TABLE auspicio (
    nombre_auspiciante varchar(30) NOT NULL ,
    id_proy integer NOT NULL ,
    tipo_e char(1) NULL ,
    nro_e integer NULL ,
    CONSTRAINT pk_auspicio PRIMARY KEY (nombre_auspiciante)
);

select * from auspicio;

-- a
ALTER TABLE auspicio
    ADD CONSTRAINT fk_auspicio_a_empleado
    FOREIGN KEY (tipo_e, nro_e)
    REFERENCES empleado (tipo_e, nro_e)
    ON DELETE SET NULL
    ON UPDATE RESTRICT;

ALTER TABLE auspicio
    ADD CONSTRAINT fk_auspicio_a_proyecto
    FOREIGN KEY (id_proy)
    REFERENCES proyecto (id_proy)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT;

ALTER TABLE trabaja_en
    ADD CONSTRAINT fk_trabaja_en_a_proyecto
    FOREIGN KEY (id_proy)
    REFERENCES proyecto (id_proy)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;


-- b
DELETE FROM empleado;

INSERT INTO empleado (tipo_e, nro_E, nombre, cargo) VALUES
    ('A', 1, 'JUAN', 'LIMPIA BANIOS'),
    ('B', 2, 'PEDRO', 'CEO'),
    ('A', 2, 'FELIX', 'LIDER DE LA UNION');

SELECT * FROM empleado;

DELETE FROM proyecto;

INSERT INTO proyecto (ID_PROY, NOMBRE_PROY, ANIO_COMIENZO, ANIO_FINAL) VALUES
    (1, 'CJERUSALEM', 1214, 1215),
    (2, 'CCONSTANTI', 1473, 1474),
    (3, 'CESTAMBUL', 2020, 2021);

SELECT * FROM proyecto;

DELETE FROM trabaja_en;

INSERT INTO trabaja_en (tipo_e, nro_e, id_proy, anio, mes, cant_horas, tarea) VALUES
    ('A', 1, 1, 2010, 12, 8, 'ASDAASD'),
    ('A', 2, 2, 2020, 2, 9, 'ASDASD');

SELECT * FROM trabaja_en;

DELETE FROM auspicio;

INSERT INTO auspicio (nombre_auspiciante, id_proy, tipo_e, nro_e) VALUES
    ('PEPE', 2, 'A', 2);

SELECT * FROM auspicio;

--B.1 Ningun problema
DELETE FROM proyecto WHERE id_proy = 3;

INSERT INTO proyecto (ID_PROY, NOMBRE_PROY, ANIO_COMIENZO, ANIO_FINAL) VALUES
        (3, 'CESTAMBUL', 2020, 2021);

--B.2 Ningun problema
UPDATE proyecto SET id_proy = 7 WHERE id_proy = 3;
UPDATE proyecto SET id_proy = 3 WHERE id_proy = 7;

--B.3 No nos va a dejar por la referencia de trabaja_en
DELETE FROM proyecto WHERE id_proy = 1;

--B.4 Se va a permitir, pero va a borrar una fila de trabaja_en y
-- va a dejar los campos referenciantes de auspicio en NULL
DELETE FROM empleado WHERE tipo_e = 'A' AND nro_e = 2;

SELECT * FROM trabaja_en;

SELECT * FROM auspicio;

--B.5 Se va a permitir
UPDATE trabaja_en SET id_proy = 3 WHERE id_proy = 1;
UPDATE trabaja_en SET id_proy = 1 WHERE id_proy = 3;

--B.6 No nos va a dejar por la RIR con auspicia. No modifica nada.
UPDATE proyecto SET id_proy = 5 WHERE id_proy = 2;

--NOTA: Para el C, las tablas tienen otra forna a como las maneja el ejercicio,
--por eso el orden de los VALUES en la insercion cambia.
--C.i (Match Simple, acepta si al menos una columna en la referenciante es NULL)
--Match Simple es la opcion por defecto en postgresql, no hay que modificar la FK
--1 la va a aceptar porque una columna es NULL
INSERT INTO auspicio VALUES ('Dell',1, 'B', null);

--2 la va a aceptar porque un valor es null
INSERT INTO auspicio VALUES ('Oracle', 3, null, null);

--3
SELECT * FROM empleado; --para ver que valores debe satisfacer
--la va a rechazar porque no hay un empleado de tipo A con numero 3
INSERT INTO auspicio VALUES ('Google', 5, 'A', 3);

--4 la va a aceptar porque un atributo es null
INSERT INTO auspicio VALUES ('HP', 1, null, 3);

--C.ii (Match Parcial, los valores no null se corresponden con una tupla referenciada)
--Postgresql no soporta match parcial, no lo podemos probar :(
SELECT * FROM empleado; --para ver que debe satisfacer
--1 la va a aceptar porque hay un empleado con tipo B

--2 la va a aceptar porque todos los valores de la FK son null

--3 la va a rechazar porque no hay un empleado con numero 3 y tipo A

--4 la va a rechazar porque no hay un empleado con numero 3

--C.iii (Match Full, acepta si todos los valores que referencian son null)
--modificamos la FK para probar
ALTER TABLE auspicio DROP CONSTRAINT fk_auspicio_a_empleado;
ALTER TABLE auspicio
    ADD CONSTRAINT fk_auspicio_a_empleado
    FOREIGN KEY (tipo_e, nro_e)
    REFERENCES empleado (tipo_e, nro_e)
    MATCH FULL
    ON DELETE SET NULL
    ON UPDATE RESTRICT;
SELECT * FROM empleado; --para ver que debe satisfacer
--1 la va a rechazar porque mezcla valores que referencian no null y null
INSERT INTO auspicio VALUES ('Dell',1, 'B', null);

--2 la va a aceptar porque los dos valores que referencian son null
INSERT INTO auspicio VALUES ('Oracle', 3, null, null);

--3 la va a rechazar porque no hay una tupla con numero 3 y tipo A en empleado
INSERT INTO auspicio VALUES ('Google', 5, 'A', 3);

--4 la va a rechazar porque mezcla valores que referencian no null y null
INSERT INTO auspicio VALUES ('HP', 1, null, 3);

-- Ejercicio 2
--Creamos el esquema
CREATE TABLE cliente (
    zona char(1) NOT NULL ,
    nro_c integer NOT NULL ,
    nombre varchar(30) NOT NULL ,
    ciudad char(2) NOT NULL ,
    CONSTRAINT pk_cliente PRIMARY KEY (zona, nro_c)
);

CREATE TABLE instalacion (
    zona char(1) NOT NULL ,
    nro_c integer NOT NULL ,
    id_serv char(2) NOT NULL ,
    anio integer NOT NULL ,
    mes integer NOT NULL ,
    cant_horas integer NOT NULL ,
    tarea char(2) NOT NULL ,
    CONSTRAINT pk_instalacion PRIMARY KEY (zona,nro_c,id_serv,anio,mes)
);

CREATE TABLE servicio (
    id_serv char(2) NOT NULL ,
    nombre_serv varchar(10) NOT NULL ,
    anio_comienzo integer NOT NULL ,
    anio_fin integer NULL ,
    CONSTRAINT pk_servicio PRIMARY KEY (id_serv)
);

CREATE TABLE referecnia (
    id_serv char(2) NOT NULL ,
    motivo varchar(15) NOT NULL ,
    zona char(1) NULL ,
    nro_c integer NULL ,
    CONSTRAINT pk_referencia PRIMARY KEY (id_serv, motivo)
);

ALTER TABLE instalacion
ADD CONSTRAINT fk_instalacion_cliente
FOREIGN KEY (zona, nro_c) REFERENCES cliente (zona, nro_c)
ON DELETE CASCADE
ON UPDATE RESTRICT;

ALTER TABLE instalacion
ADD CONSTRAINT fk_instalacion_servicio
FOREIGN KEY (id_serv) REFERENCES servicio (id_serv)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE referecnia
ADD CONSTRAINT fk_referencia_servicio
FOREIGN KEY (id_serv) REFERENCES servicio (id_serv)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE referecnia
ADD CONSTRAINT fk_referencia_cliente
FOREIGN KEY (zona, nro_c) REFERENCES cliente (zona, nro_c)
ON DELETE RESTRICT
ON UPDATE SET NULL;

INSERT INTO cliente
VALUES ('A', 1, 'Juan Ro', 'C1'),
       ('A', 2, 'Alberto Efe', 'C1'),
       ('B', 1, 'Esteban Hache', 'C1'),
       ('C', 2, 'Jose Ge', 'C3'),
       ('D', 3, 'Luis Ene', 'C2');

SELECT * FROM cliente;

INSERT INTO servicio
VALUES ('S1', 'Serv 1', 2010, 2012),
       ('S2', 'Serv 2', 2012, 2012),
       ('S3', 'Serv 3', 2009, NULL);

SELECT * FROM servicio;

INSERT INTO instalacion
VALUES ('A', 1, 'S1', 5, 2011, 5, 'T1'),
       ('B', 1, 'S2', 5, 2012, 7, 'T1'),
       ('C', 2, 'S1', 4, 2010, 9, 'T2'),
       ('A', 2, 'S3', 8, 2009, 6, 'T2');

SELECT * FROM instalacion;

INSERT INTO referecnia
VALUES ('S1', 'Puntualidad', 'D', 3),
       ('S2', 'Calidad inst.', 'C', 2),
       ('S3', 'Costo', 'C', 2),
       ('S1', 'Atencion', 'D', 3);

SELECT * FROM referecnia;

--a)
--a.1
DELETE FROM Cliente WHERE nro_c = 1;
--Quedan las tuplas con Alberto F, Jose G y Luis N en cliente
-- Se eliminan las 2 tuplas de Instalacion con nro cliente 1, quedan las de nro 2.
SELECT * FROM cliente;
SELECT * FROM instalacion;

--a.2
UPDATE instalacion SET id_serv = 'S5' WHERE id_serv = 'S2';
--No hace nada porque no hay tuplas con S2  en instalacion, se borraron en lo anterior
SELECT * FROM instalacion;

--a.3
UPDATE cliente SET zona = 'Z' WHERE zona = 'D';
--cambia la zona de Luis N (nro_c 3) a Z
--en referencia, la zona y nro_c de las tuplas con S1 quedan en NULL
--no hay cambios en instalacion porque el cliente modificado no esta en instalacion
SELECT * FROM referecnia;
SELECT * FROM cliente;
SELECT * FROM instalacion;

--b con match simple

INSERT INTO referecnia VALUES ('S4', 'Prueba', null, 8);
--se rechaza por la fk con servicio, S4 no esta en serv

INSERT INTO referecnia VALUES (null, 'Prueba', null, 8);
--se rechaza porque el id serv no puede ser null

INSERT INTO referecnia VALUES ('S3', 'Prueba', null, 8);
--se acepta porque satisface la rir de servivcio y en la otra hay un referenciante nulo

INSERT INTO referecnia VALUES ('S3', 'Prueba2', null, null);
--se acepta porque satisface la rir de servivcio y en la otra hay un referenciante nulo

SELECT * FROM referecnia;

--b con match parcial (no se puede probar, match parcial no anda en postgresql)

INSERT INTO referecnia VALUES ('S4', 'Prueba', null, 8);
--se rechaza por la fk con servicio, S4 no esta en servicio

INSERT INTO referecnia VALUES (null, 'Prueba', null, 8);
--se rechaza porque el id serv no puede ser null

INSERT INTO referecnia VALUES ('S3', 'Prueba', null, 8);
--se rechaza porque 8 no es un numero de cliente que este en cliente

INSERT INTO referecnia VALUES ('S3', 'Prueba2', null, null);
--se acepta porque satisface la rir de servivcio y en la otra son todos nulos

--b con match full
--modifs para probar
DELETE FROM referecnia WHERE motivo LIKE 'Prueb%';

ALTER TABLE referecnia DROP CONSTRAINT fk_referencia_cliente;

ALTER TABLE referecnia
ADD CONSTRAINT fk_referencia_cliente
FOREIGN KEY (zona, nro_c) REFERENCES cliente (zona, nro_c)
    MATCH FULL
ON DELETE RESTRICT
ON UPDATE SET NULL;

INSERT INTO referecnia VALUES ('S4', 'Prueba', null, 8);
--se rechaza por la fk con servicio, S4 no esta en servicio

INSERT INTO referecnia VALUES (null, 'Prueba', null, 8);
--se rechaza porque el id serv no puede ser null

INSERT INTO referecnia VALUES ('S3', 'Prueba', null, 8);
--se rechaza porque no se pueden mezclar nulos y no nulos en los referenciantes

INSERT INTO referecnia VALUES ('S3', 'Prueba2', null, null);
--se acepta porque satisface la rir de servivcio y en la otra son todos nulos

SELECT * FROM referecnia;

-- Ejercicio 3
-- No estan armados los esquemas para probar, ain't nobody got time for that.

--a
CREATE DOMAIN Nacionalidad_valida
AS varchar(20) NOT NULL
CHECK ( VALUE = 'Argentina' OR VALUE = 'Espaniol' OR VALUE = 'Inglesa'
        OR VALUE = 'Alemana' OR VALUE = 'Chilena');

--b
CREATE DOMAIN Fecha_valida
AS date NOT NULL
CHECK ( extract(year from VALUE) >= 2010 );

--c
ALTER TABLE articulo
    ADD CHECK (((extract(year from fecha_pub) > 2017) AND (nacionalidad = 'Argentina'))
        OR (extract(year from fecha_pub) < 2017));

--d
ALTER TABLE contiene
    ADD CHECK ( (SELECT count(id_articulo)) <= 15 );

--e POSTGRESQL NO SOPORTA ASSERTION :(
CREATE ASSERTION assertion_e CHECK ((SELECT count(SELECT id_articulo
                                                    FROM articulo
                                                    WHERE nacionalidad = 'Argentina')
                                        FROM contiene) <= 10)

-- Ejercicio 4

--a
ALTER TABLE provee ADD CHECK ( (SELECT count(id_prov)) <= 20 )

--b
CREATE DOMAIN sucursal_valida
AS varchar(20) NOT NULL
CHECK ( VALUE LIKE 'S_%');

--c
ALTER TABLE producto
    ADD CHECK (
        ((presentacion IS NULL) AND (descripcion IS NOT NULL))
        OR ((presentacion IS NOT NULL) AND (descripcion IS NULL))
        OR (presentacion IS NOT NULL)
        OR (descripcion IS NOT NULL)
        );

--d
CREATE ASSERTION assertion_d CHECK(
    NOT EXISTS ( --subquery da los pares en provee donde la suc y el prob esten
                    --en localidades destintas. Verificamos que no existan esos pares.
        SELECT nro_prov, cod_suc
        FROM provee
        JOIN proveedor ON provee.nro_prov = proveedor.nro_prov
        JOIN sucursal ON provee.cod_suc = sucursal.cod_suc
        WHERE sucursal.localidad != proveedor.localidad
    )
)

-- Ejercicio 5

--a
CREATE DOMAIN fecha_nac_valida
AS date NOT NULL
CHECK ( extract(year from age(current_date, VALUE)) <= 70 );

--b
ALTER TABLE voluntario
ADD CHECK (
    (nro_voluntario IN (
            SELECT v1.nro_voluntario --los voluntarios con menos horas que los coord.
            FROM voluntario v1 --el voluntario
            JOIN voluntario v2 --el coordinador
            ON v1.id_coordinador = v2.nro_voluntario AND v1.id_coordinador IS NOT NULL
            WHERE v1.horas_aportadas <= v2.horas_aportadas
        )
    ) OR id_coordinador IS NULL
    );

--c
CREATE ASSERTION assertion_c CHECK (
    NOT EXISTS (
        SELECT horas_aportadas
        FROM voluntario v
        JOIN tarea t ON v.id_tarea = t.id_tarea
        WHERE v.horas_aportadas
        NOT BETWEEN t.min_horas AND t.max_horas
    )
)

--d
ALTER TABLE voluntario
ADD CHECK (
    (NOT EXISTS(
            SELECT *
            FROM voluntario v1 --el voluntario
            JOIN voluntario v2 --el coordinador
            ON v1.id_coordinador = v2.nro_voluntario AND v1.id_coordinador IS NOT NULL
            WHERE v1.id_tarea != v2.id_tarea
        ))
    OR v1.id_coordinador IS NULL
    );

--e
ALTER TABLE historico
ADD CONSTRAINT ck_historico_cambiosinstitucion
CHECK (
    NOT EXISTS ( SELECT 1
                   FROM historico
                   GROUP BY nro_voluntario, extract(year from fecha_inicio)
                   HAVING count(DISTINCT id_institucion) > 3
            )
    );