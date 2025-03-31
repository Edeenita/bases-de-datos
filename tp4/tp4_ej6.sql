set search_path = 'unc_esq_peliculas';

SELECT *
FROM distribuidor
WHERE tipo = 'I' AND telefono IS NULL;