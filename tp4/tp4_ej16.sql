set search_path = 'unc_esq_voluntario';

SELECT  id_institucion,
        COUNT(nro_voluntario) AS cantidad_voluntarios
FROM voluntario
GROUP BY id_institucion
ORDER BY cantidad_voluntarios DESC
LIMIT 2;