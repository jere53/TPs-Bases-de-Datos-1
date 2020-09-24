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

