set search_path = 'unc_esq_peliculas';

SELECT apellido, id_empleado
FROM empleado
WHERE porc_comision IS NULL
LIMIT 20