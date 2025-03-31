set search_path = 'unc_esq_peliculas';

SELECT codigo_pelicula
FROM renglon_entrega
WHERE cantidad BETWEEN 3 AND 5
LIMIT 20;