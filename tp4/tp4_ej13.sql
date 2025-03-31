set search_path = 'unc_esq_peliculas';

SELECT  id_departamento, 
        COUNT(id_empleado) AS cant_empleados
FROM empleado
GROUP BY id_departamento




