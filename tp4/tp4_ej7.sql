set search_path = 'unc_esq_peliculas';

SELECT apellido, nombre, e_mail
FROM empleado
WHERE sueldo > 1000.00 AND e_mail LIKE '%gmail.com'
LIMIT 20;