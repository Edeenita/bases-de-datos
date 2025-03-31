set search_path = 'unc_esq_peliculas';

SELECT idioma, COUNT(*) AS cantidad_peliculas
FROM pelicula
GROUP BY idioma