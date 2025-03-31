set search_path = 'unc_esq_peliculas';

SELECT  id_departamento,
        AVG(sueldo) AS sueldo_promedio
FROM empleado
GROUP BY id_departamento
HAVING AVG(sueldo) > 4500.00
ORDER BY sueldo_promedio DESC









