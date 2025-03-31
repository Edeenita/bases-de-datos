set search_path = 'unc_esq_voluntario';

SELECT apellido || ' ' || nombre "Apellido y Nombre", e_mail "Direccion de mail"
FROM voluntario
WHERE telefono LIKE '+51%';