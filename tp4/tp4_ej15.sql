set search_path = 'unc_esq_voluntario';

SELECT  EXTRACT(MONTH FROM fecha_nacimiento) AS mes,
        COUNT(nro_voluntario) AS cant_voluntarios
FROM voluntario
GROUP BY mes
ORDER BY mes

