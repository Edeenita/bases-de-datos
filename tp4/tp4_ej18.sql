set search_path = 'unc_esq_peliculas';

SELECT  id_distribuidor,
        COUNT(id_departamento) AS cant_departamentos
FROM departamento
GROUP BY id_distribuidor
HAVING COUNT(id_departamento)>3
ORDER BY cant_departamentos DESC