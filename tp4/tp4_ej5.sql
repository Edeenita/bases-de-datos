set search_path = 'unc_esq_voluntario';

SELECT apellido, id_tarea
FROM voluntario
WHERE id_coordinador IS NULL