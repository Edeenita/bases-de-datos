set search_path = 'unc_esq_peliculas';

SELECT  id_jefe,
        COUNT(id_empleado) AS cant_empleados
FROM empleado
WHERE id_jefe IS NOT NULL
GROUP BY id_jefe
ORDER BY cant_empleados DESC
LIMIT 50;

