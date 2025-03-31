set search_path = 'unc_esq_voluntario';

SELECT id_institucion, nombre_institucion
FROM  institucion
WHERE nombre_institucion LIKE 'FUNDACION%';