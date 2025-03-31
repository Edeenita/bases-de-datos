set search_path = 'unc_esq_peliculas';

SELECT nombre, apellido, telefono
FROM empleado
WHERE id_tarea = '7231'
ORDER BY apellido, nombre;