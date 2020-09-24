--Ejercicio 1
-- 1
SELECT nro_voluntario, count(nro_voluntario) - 1 AS cant_cambios
FROM (
    SELECT nro_voluntario
    FROM unc_esq_voluntario.voluntario
    UNION ALL
    SELECT nro_voluntario
    FROM unc_esq_voluntario.historico) AS todas_tareas
GROUP BY nro_voluntario
ORDER BY cant_cambios DESC;


-- 2
SELECT nombre, apellido, e_mail, telefono, h.nro_voluntario, h.id_tarea, t.id_tarea, horas_aportadas, fecha_fin, max_horas, min_horas
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.historico h ON v.nro_voluntario = h.nro_voluntario
JOIN unc_esq_voluntario.tarea t ON h.id_tarea = t.id_tarea
WHERE (max_horas - min_horas <= 5000)
    AND (fecha_fin < TO_DATE('1998/07/24', 'YYYY/MM/DD'));

-- 3
--La subquery elige las instituciones de los voluntarios que se pasaron de horas
--Elegimos las instituciones que no estan en el resultado de esa subquery
SELECT *
FROM unc_esq_voluntario.institucion
WHERE id_institucion IN (
    SELECT DISTINCT v.id_institucion
    FROM unc_esq_voluntario.voluntario v
    JOIN unc_esq_voluntario.tarea t ON v.id_tarea = t.id_tarea
    WHERE horas_aportadas > max_horas);

-- 4
--La subquery da todos los paises que aperecen en el historico
SELECT nombre_pais
FROM unc_esq_voluntario.pais
WHERE nombre_pais NOT IN (SELECT nombre_pais
                            FROM unc_esq_voluntario.historico h
                            JOIN unc_esq_voluntario.institucion i ON h.id_institucion = i.id_institucion
                            JOIN unc_esq_voluntario.direccion d ON i.id_direccion = d.id_direccion
                            JOIN unc_esq_voluntario.pais p ON d.id_pais = p.id_pais)
ORDER BY nombre_pais;

-- 5
SELECT nombre_tarea
FROM unc_esq_voluntario.tarea
WHERE id_tarea NOT IN (SELECT id_tarea FROM unc_esq_voluntario.voluntario);

-- 6
SELECT *
FROM unc_esq_voluntario.voluntario
WHERE id_tarea IN (SELECT id_tarea --selecciona las tareas en ejecucion de Munich
                FROM unc_esq_voluntario.voluntario v
                JOIN unc_esq_voluntario.institucion i ON v.id_institucion = i.id_institucion
                JOIN unc_esq_voluntario.direccion d ON i.id_direccion = d.id_direccion
                WHERE ciudad = 'Munich'
                GROUP BY id_tarea --agrupa por id_tarea y descarta los grupos con mas de una fila
                HAVING count(v.id_tarea) = 1);

-- 7
-- La primer subquery devuelve una tabla con todas las tareas realizadas en el historico
-- de instituciones que poseen director y en que institucion fueron realizadas

-- ensamblamos esa tabla con direccion para conseguir los datos

-- Despues nos quedamos con las filas en las que la tarea aparece en la tabla pero con otra
-- institucion

SELECT DISTINCT d.id_direccion
FROM (SELECT id_tarea, h.id_institucion, id_direccion --tareas que realizo c/institucion
        FROM (SELECT id_institucion, id_direccion --Que tenga director
                FROM unc_esq_voluntario.institucion
                WHERE id_director IS NOT NULL) AS i
        JOIN unc_esq_voluntario.historico h ON i.id_institucion = h.id_institucion) AS i2
JOIN unc_esq_voluntario.direccion d ON i2.id_direccion = d.id_direccion
WHERE id_tarea IN (SELECT DISTINCT id_tarea
                    FROM unc_esq_voluntario.voluntario v
                    WHERE i2.id_institucion != v.id_institucion)
ORDER BY id_direccion;

-- 8
SELECT id_empleado, nombre, apellido, (SELECT e2.apellido FROM unc_esq_peliculas.empleado e2 WHERE e2.id_empleado = e.id_jefe) as apellido_jefe
FROM unc_esq_peliculas.empleado e
WHERE id_jefe IS NOT NULL;

-- 9
SELECT id_empleado, e.nombre, e.apellido
FROM unc_esq_peliculas.departamento d
    JOIN unc_esq_peliculas.empleado e ON e.id_empleado = d.jefe_departamento
WHERE id_ciudad IN (SELECT c.id_ciudad
                    FROM unc_esq_peliculas.departamento d2
                        JOIN unc_esq_peliculas.ciudad c ON d2.id_ciudad = c.id_ciudad
                    WHERE c.nombre_ciudad = 'Rawalpindi')
;

-- 10
SELECT id_distribuidor, nro_inscripcion
FROM unc_esq_peliculas.nacional
WHERE id_distribuidor IN (SELECT e.id_distribuidor
                            FROM unc_esq_peliculas.entrega e
                                JOIN unc_esq_peliculas.renglon_entrega r ON e.nro_entrega = r.nro_entrega
                                JOIN unc_esq_peliculas.pelicula p ON r.codigo_pelicula = p.codigo_pelicula
                            WHERE p.idioma = 'Farsi' AND EXTRACT(year from e.fecha_entrega) = 1998)
;

-- 11
SELECT codigo_pelicula
FROM unc_esq_peliculas.pelicula
WHERE codigo_pelicula
NOT IN (SELECT codigo_pelicula
        FROM unc_esq_peliculas.nacional n
            JOIN unc_esq_peliculas.entrega e ON e.id_distribuidor = n.id_distribuidor
            JOIN unc_esq_peliculas.renglon_entrega r ON e.nro_entrega = r.nro_entrega
    );

-- 12
SELECT apellido, nombre
FROM unc_esq_peliculas.empleado
WHERE id_departamento IN (SELECT d.id_departamento
                            FROM unc_esq_peliculas.departamento d
                                JOIN unc_esq_peliculas.ciudad c ON d.id_ciudad = c.id_ciudad
                                JOIN unc_esq_peliculas.pais p ON c.id_pais = p.id_pais
                                JOIN unc_esq_peliculas.empleado e ON d.jefe_departamento = e.id_empleado
                            WHERE nombre_pais = 'ARGENTINA' AND porc_comision > 40.00
                        );

-- 13
SELECT DISTINCT id_departamento, id_distribuidor, nombre
FROM unc_esq_peliculas.departamento d
WHERE (d.id_departamento, d.id_distribuidor) IN (SELECT id_departamento, e.id_distribuidor
                            FROM unc_esq_peliculas.empleado e
                                JOIN unc_esq_peliculas.tarea t ON e.id_tarea = t.id_tarea AND sueldo_minimo < 6000
                            GROUP BY id_departamento, e.id_distribuidor
                            HAVING count(id_departamento) > 3
                        );

--Ejercicio 2
-- 1
SELECT id_institucion
FROM unc_esq_voluntario.institucion i
WHERE id_institucion IN (SELECT v.id_institucion --que tengan un solo voluntario
        FROM unc_esq_voluntario.voluntario v
        GROUP BY v.id_institucion
        HAVING count(v.id_institucion) = 1)
EXCEPT (SELECT h.id_institucion FROM unc_esq_voluntario.historico h);
--Salvo las que hayan terminado tareas

-- 2
SELECT DISTINCT id_coordinador
FROM unc_esq_voluntario.voluntario v
JOIN unc_esq_voluntario.voluntario v2 ON