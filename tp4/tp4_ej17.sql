set search_path = 'unc_esq_peliculas';

SELECT  id_ciudad,
        COUNT(id_departamento) AS cant_departamentos
FROM departamento
GROUP BY id_ciudad
HAVING COUNT(id_departamento)>1
ORDER BY cant_departamentos DESC






