set search_path = 'unc_esq_peliculas';

SELECT  nombre || ', ' || apellido AS nombre_completo,
        EXTRACT(DAY FROM fecha_nacimiento) AS dia,
        EXTRACT(MONTH FROM fecha_nacimiento) AS mes
FROM empleado
ORDER BY mes, dia
LIMIT 250;