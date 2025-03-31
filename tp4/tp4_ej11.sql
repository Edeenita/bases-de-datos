set search_path = 'unc_esq_voluntario';

SELECT  MIN(horas_aportadas) AS horas_minimas_aportadas,
        MAX(horas_aportadas) AS horas_maximas_aportadas,
        AVG(horas_aportadas) AS horas_promedio_aportadas
FROM voluntario
WHERE fecha_nacimiento >= '1990-1-1';