set search_path = 'unc_esq_voluntario';
set search_path = 'unc_esq_peliculas';

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






