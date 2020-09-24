--Ejercicio 1
-- 1
select distinct id_tarea
from unc_esq_voluntario.voluntario;
--

-- 2
select distinct nro_voluntario, fecha_inicio, id_institucion, id_tarea
from unc_esq_voluntario.historico
order by nro_voluntario;
--

--Ejercicio 2
-- 1
select apellido || ', ' || nombre as nombre_completo, e_mail
from unc_esq_voluntario.voluntario
where horas_aportadas > 1000
order by apellido;
--

-- 2
select apellido, telefono
from unc_esq_voluntario.voluntario
where id_institucion = 20 or id_institucion = 50
order by apellido, nombre;
--

-- 3
select apellido || ', ' || nombre as "Apellido y Nombre", e_mail as "Direccion de mail"
from unc_esq_voluntario.voluntario
where telefono like '011%';
--

--Ejercicio 3
-- 1
SELECT apellido, nombre, id_empleado
FROM unc_esq_peliculas.empleado
WHERE porc_comision IS NULL
    OR porc_comision = 0
ORDER BY apellido;
--

-- 2
SELECT id_distribuidor, nombre, direccion, telefono, tipo
FROM unc_esq_peliculas.distribuidor
WHERE telefono IS NULL;
--

-- 3
SELECT id_departamento || ', ' || id_distribuidor as ClaveDpto
FROM unc_esq_peliculas.departamento
WHERE jefe_departamento IS NULL;
--

--Ejercicio 4
-- 1
SELECT apellido, id_tarea, to_char(fecha_nacimiento, 'YYYY-MM-DD') AS "Fecha de Nacimiento"
FROM unc_esq_voluntario.voluntario
WHERE extract(month from fecha_nacimiento) = 5;
--

-- 2
SELECT nombre || ', ' || apellido as Cumpleaniero, to_char(fecha_nacimiento, 'DD-MM') as Cumpleanios
FROM unc_esq_voluntario.voluntario
WHERE fecha_nacimiento IS NOT NULL
ORDER BY extract(month from fecha_nacimiento), extract(day from fecha_nacimiento);

-- 3
SELECT nombre, id_empleado, fecha_nacimiento, sueldo
FROM unc_esq_peliculas.empleado
WHERE extract(year from fecha_nacimiento) = 1960
    AND sueldo > 1500
ORDER BY id_empleado;
--

--Ejercicio 5
-- 1
SELECT sum(sueldo)
FROM unc_esq_peliculas.empleado;

-- 2
SELECT id_institucion, count(nro_voluntario)
FROM unc_esq_voluntario.voluntario
GROUP BY id_institucion;

-- 3
SELECT nombre || ' ' || apellido as NombreCompleto, fecha_nacimiento
FROM unc_esq_voluntario.voluntario
WHERE fecha_nacimiento = (select max(fecha_nacimiento) from unc_esq_voluntario.voluntario)
    OR fecha_nacimiento = (select min(fecha_nacimiento) from unc_esq_voluntario.voluntario);

-- 4
SELECT h.nro_voluntario, (count(*) - 1) as CantCambios
FROM unc_esq_voluntario.historico h
GROUP BY h.nro_voluntario
HAVING count(*) > 1;

-- 5
SELECT avg(coalesce(horas_aportadas,0)) as avg, max(horas_aportadas) as max, min(horas_aportadas) as min
FROM unc_esq_voluntario.voluntario
WHERE extract(year from age(now(), fecha_nacimiento)) > 25;

--Ejercicio 6
-- 1
SELECT *
FROM unc_esq_voluntario.direccion
ORDER BY id_direccion
LIMIT 10;

-- 2
SELECT *
FROM unc_esq_voluntario.tarea
WHERE nombre_tarea LIKE 'A%'
LIMIT 5
OFFSET 10;
