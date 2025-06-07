set search_path = 'unc_esq_voluntario', 'unc_esq_peliculas' ;


-- 1.1 Listar todas las películas que poseen entregas de películas de idioma inglés durante
-- el año 2006. (P)
SELECT *
FROM pelicula p
WHERE idioma = 'Inglés'
    AND EXISTS (
        SELECT 1
        FROM renglon_entrega re
        JOIN entrega e ON re.nro_entrega = e.nro_entrega
        WHERE re.codigo_pelicula = p.codigo_pelicula
            AND EXTRACT(YEAR FROM e.fecha_entrega) = 2006
      );

--1.2 Indicar la cantidad de películas que han sido entregadas en 2006 por un distribuidor
--nacional. Trate de resolverlo utilizando ensambles.(P)

SELECT COUNT(DISTINCT(re.codigo_pelicula)) AS cant_peliculas
FROM entrega e
JOIN renglon_entrega re ON e.nro_entrega = re.nro_entrega
JOIN nacional n ON e.id_distribuidor = n.id_distribuidor
WHERE EXTRACT(YEAR FROM e.fecha_entrega) = 2006;

-- 1.3 Indicar los departamentos que no posean empleados cuya diferencia de sueldo
--máximo y mínimo (asociado a la tarea que realiza) no supere el 40% del sueldo máximo.
--(P) (Probar con 10% para que retorne valores)

SELECT d.id_departamento, d.nombre
FROM departamento d
WHERE NOT EXISTS (
    SELECT 1
    FROM empleado e
    JOIN tarea t ON e.id_tarea = t.id_tarea
    WHERE e.id_departamento = d.id_departamento
      AND ((t.sueldo_maximo - t.sueldo_minimo) / t.sueldo_maximo) <= 0.08 -- no funciona en 10% y 40% pero si con 8% o menos xd
);

--1.4. Liste las películas que nunca han sido entregadas por un distribuidor nacional.(P)

SELECT DISTINCT *
FROM pelicula p
WHERE NOT EXISTS (
    SELECT 1
    FROM renglon_entrega re
    JOIN entrega e ON re.nro_entrega = e.nro_entrega
    JOIN distribuidor d ON e.id_distribuidor = d.id_distribuidor
    JOIN nacional n ON d.id_distribuidor = n.id_distribuidor
    WHERE re.codigo_pelicula = p.codigo_pelicula
);

--1.5. Determinar los jefes que poseen personal a cargo y cuyos departamentos (los del
--jefe) se encuentren en la Argentina.

SELECT DISTINCT e.id_empleado as jefe , e.nombre, e.apellido, e.e_mail
FROM empleado e
WHERE EXISTS (
    SELECT 1
    FROM empleado sub
    JOIN departamento d ON sub.id_departamento = d.id_departamento
    JOIN ciudad c ON d.id_ciudad = c.id_ciudad
    JOIN pais p ON c.id_pais = p.id_pais
    WHERE sub.id_jefe = e.id_empleado
      AND p.nombre_pais = 'Argentina'
)
LIMIT 50;

-- 1.6 Liste el apellido y nombre de los empleados que pertenecen a
-- a aquellos departamentos de Argentina y donde el jefe de
-- departamento posee una comision del mas del 10% de la que
-- posee su empleado a cargo

select e.apellido, e.nombre
from empleado e
where exists(
    select 1
    from empleado sub
    join departamento d on sub.id_departamento = d.id_departamento
    join ciudad c on d.id_ciudad = c.id_ciudad
    join pais p on c.id_pais = p.id_pais
    where p.nombre_pais = 'Argentina'
        and sub.porc_comision > e.porc_comision * 1.1
        and sub.id_empleado = e.id_jefe
)
LIMIT 50;
-- 1.7. Indicar la cantidad de películas entregadas a partir del 2010, por género.
select count(*) AS cant_peliculas, p.genero
from pelicula p
where exists(
    select 1
    from renglon_entrega re
    join entrega e on re.nro_entrega = e.nro_entrega
    where re.codigo_pelicula = p.codigo_pelicula
         and e.fecha_entrega >= '2010-01-01'
 )
group by genero;

--1.8. Realizar un resumen de entregas por día, indicando el video club al cual se le
-- realizó la entrega y la cantidad entregada. Ordenar el resultado por fecha.

SELECT e.fecha_entrega, ep.nombre_productora AS video_club,
    COUNT(re.codigo_pelicula) AS cantidad_entregada
FROM entrega e
JOIN renglon_entrega re ON e.nro_entrega = re.nro_entrega
JOIN pelicula p on re.codigo_pelicula = p.codigo_pelicula
join empresa_productora ep on p.codigo_productora = ep.codigo_productora
GROUP BY e.fecha_entrega, ep.nombre_productora
ORDER BY e.fecha_entrega;

--1.9. Listar, para cada ciudad, el nombre de la ciudad y la cantidad de empleados
--mayores de edad que desempeñan tareas en departamentos de la misma y que posean al
--menos 30 empleados.

select c.nombre_ciudad, count(e.id_empleado) as cantidad_empleados
from departamento d
join ciudad c on d.id_ciudad = c.id_ciudad
join empleado e on d.id_departamento = e.id_departamento
where e.id_tarea is not null and e.fecha_nacimiento <= '2006-01-01'
group by c.nombre_ciudad
having count(e.id_empleado) >= 30
LIMIT 20;

--2.1. Muestre, para cada institución, su nombre y la cantidad de voluntarios que realizan
--aportes. Ordene el resultado por nombre de institución.
select i.nombre_institucion, count(v.nro_voluntario) as cant_voluntarios
from voluntario v
join institucion i on v.id_institucion = i.id_institucion
where v.horas_aportadas is not null
group by i.nombre_institucion;

--2.2. Determine la cantidad de coordinadores en cada país, agrupados por nombre de
--país y nombre de continente. Etiquete la primer columna como "Número de coordinadores";
select count(DISTINCT v.id_coordinador) "Numero de coordinadores",
       p.nombre_pais,
       c.nombre_continente
from voluntario v
join institucion i on v.id_institucion = i.id_institucion
join direccion d on i.id_direccion = d.id_direccion
join pais p on d.id_pais = p.id_pais
join continente c on p.id_continente = c.id_continente
where v.id_coordinador is not null
group by  p.nombre_pais, c.nombre_continente;

--2.3. Escriba una consulta para mostrar el apellido, nombre y fecha de nacimiento de
--cualquier voluntario que trabaje en la misma institución que el Sr. de apellido Zlotkey.
--Excluya del resultado a Zlotkey.

select v.apellido, v.nombre, v.fecha_nacimiento
from voluntario v
where v.id_institucion = (
            select id_institucion
            from  voluntario v
            where  v.apellido = 'Zlotkey')
      and v.apellido != 'Zlotkey';

--2.4. Cree una consulta para mostrar los números de voluntarios y los apellidos de todos
--los voluntarios cuya cantidad de horas aportadas sea mayor que la media de las horas
--aportadas. Ordene los resultados por horas aportadas en orden ascendente.
select nro_voluntario, apellido
from voluntario
where horas_aportadas > (
                        select avg(horas_aportadas)
                        from voluntario)
order by horas_aportadas;

--Dada la siguiente tabla y basándose en el esquema de películas,
CREATE TABLE distribuidor_nac
(
id_distribuidor numeric(5,0) NOT NULL,
nombre character varying(80) NOT NULL,
direccion character varying(120) NOT NULL,
telefono character varying(20),
nro_inscripcion numeric(8,0) NOT NULL,
encargado character varying(60) NOT NULL,
id_distrib_mayorista numeric(5,0),
CONSTRAINT pk_distribuidorNac PRIMARY KEY (id_distribuidor)
);

--3.1 Se solicita llenarla con la información correspondiente a los datos completos de
--todos los distribuidores nacionales.
INSERT INTO distribuidor_nac (
    id_distribuidor,nombre,direccion,telefono,nro_inscripcion,encargado,id_distrib_mayorista
)
SELECT d.id_distribuidor, d.nombre, d.direccion, d.telefono,
       n.nro_inscripcion, n.encargado, n.id_distrib_mayorista
FROM distribuidor d
JOIN nacional n ON d.id_distribuidor = n.id_distribuidor;

--3.2 Agregar a la definición de la tabla distribuidor_nac, el campo &quot;codigo_pais&quot; que
--indica el código de país del distribuidor mayorista que atiende a cada distribuidor
--nacional.(codigo_pais varchar(5) NULL)
ALTER TABLE distribuidor_nac
ADD COLUMN codigo_pais VARCHAR(5) NULL;
--3.3. Para todos los registros de la tabla distribuidor_nac, llenar el nuevo campo
--&quot;codigo_pais&quot; con el valor correspondiente existente en la tabla &quot;Internacional&quot;.
UPDATE distribuidor_nac dn
SET codigo_pais = i.codigo_pais
FROM internacional i
JOIN distribuidor d ON i.id_distribuidor = d.id_distribuidor
WHERE dn.id_distrib_mayorista = d.id_distribuidor;
--3.4. Eliminar de la tabla distribuidor_nac los registros que no tienen asociado un
--distribuidor mayorista.
DELETE FROM distribuidor_nac
WHERE id_distrib_mayorista IS NULL;





