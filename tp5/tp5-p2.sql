set search_path = 'unc_esq_voluntario', 'unc_esq_peliculas';
--Ejercicio 1
--Considere las siguientes restricciones que debe definir sobre el esquema de la BD de
--Voluntarios:
--A. No puede haber voluntarios de más de 70 años. Aquí como la edad es un dato que
--depende de la fecha actual lo deberíamos controlar de otra manera.
    alter table voluntario
    add constraint ck_edadLimite_voluntario
    check (
        fecha_nacimiento >= '1954-01-01'
        );
--A.Bis - Controlar que los voluntarios deben ser mayores a 18 años.
    alter table voluntario
    add constraint ck_edadMayores_voluntario
    check (
        fecha_nacimiento <= '2006-01-01'
        );
--B. Ningún voluntario puede aportar más horas que las de su coordinador.
    alter table voluntario
    add constraint ck_horasMaximas_Voluntario
    check (
        not exists(
            select 1
            from voluntario v
            join voluntario c on v.nro_voluntario = c.id_coordinador
            where v.horas_aportadas > c.horas_aportadas
            )
        );
    -- ESTA DB NO SOPORTA ESTO
--C. Las horas aportadas por los voluntarios deben estar dentro de los valores máximos y
--mínimos consignados en la tarea.
       create assertion horas_aportadas_dentro_rangos
        check(
              not exists(
                    select 1
                    from voluntario v
                    join tarea t on v.id_tarea = t.id_tarea
                    where v.horas_aportadas < t.min_horas
                        or v._horas_aportadas > t.max_horas
              )
        );
    -- NO SOPORTA ASSERTION
--D. Todos los voluntarios deben realizar la misma tarea que su coordinador.
    alter table voluntario
    add constraint ck_mimsa_tarea_vol
    check (
        not exists(
            select 1
            from voluntario v
            join voluntario c on v.nro_voluntario = c.id_coordinador
            where c.id_tarea <> v.id_tarea
                and v.id_coordinador is not null
            )
        );
--E. Los voluntarios no pueden cambiar de institución más de tres veces al año.
    alter table voluntario
    add constraint ck_max_cambios
    check(
           not exists(
                      select 1
                       from voluntario v
                       join historico hi on v.nro_voluntario = hi nro_voluntario
                       group by v.nro_voluntario, extract(YEAR from hi.fecha_inicio)
                       having count(extract(YEAR from hi.fecha_inicio))
           )
    );
--F. En el histórico, la fecha de inicio debe ser siempre menor que la fecha de finalización.
    alter table historico
    add constraint ck_correspondencia_fechas
    check (fecha_inicio <= fecha_fin)
    );

--Ejercicio 2
--Considere las siguientes restricciones que debe definir sobre el esquema de la BD de Películas:
--A. Para cada tarea el sueldo máximo debe ser mayor que el sueldo mínimo.
    alter table tarea
    add constraint consistencia_sueldo
    check ( sueldo_maximo > sueldo_minimo );
--B. No puede haber más de 70 empleados en cada departamento.
    create assertion max_empleados
           check(
            not exists(
               select 1
               from empleado e
               join departamento de on e.id_departamento = de.id_departamento
               group by de.id_departamento
               having count(de.id_departamento) > 70
            )
           )
--C. Los empleados deben tener jefes que pertenezcan al mismo departamento.
    alter table empleado
    add constraint empleado_mismo_jefe
    check (
        not exists(
            select 1
            from empleado e
            join empleado j on e.id_jefe = j.id_jefe
            where e.id_jefe is not null
                and e.id_jefe <> j.id_jefe
        )
    );
--D. Todas las entregas, tienen que ser de películas de un mismo idioma.
    create assertion pel_same_language
    check(
           not exists(
                select 1
                from entrega e
                join renglon_entrega re on e.nro_entrega = re.nro_entrega
                join pelicula p on re.codigo_pelicula = p.codigo_pelicula
                join renglon_entrega re2 on e.nro_entrega = re2.nro_entrega
                join pelicula p2 on re.codigo_pelicula = p2.codigo_pelicula
                where p.idioma <> p2.idioma
           )
    );
--E. No pueden haber más de 10 empresas productoras por ciudad.
    create assertion max_ciudad
    check(
        not exists(
                select 1
                from ciudad ci
                join empresa_productora ep on ci.id_ciudad = ep.id_ciudad
                group by ci.id_ciudad
                having count(ep.id_ciudad) > 10
             )
         );
--F. Para cada película, si el formato es 8mm, el idioma tiene que ser francés.
    alter table pelicula
    add constraint formato_8mm_french
    check (formato <> '8mm' or idioma = 'FR')
--G. El teléfono de los distribuidores Nacionales debe tener la misma característica que la de su
--distribuidor mayorista.
create assertion mismo_num_disNacional_disMayor
check(
       not exists(
            select 1
            from nacional n
            join distribuidor dn on n.id_distribuidor = dn.id_distribuidor
            join distribuidor dm on n.id_distribuidor_mayorista = dm.id_distribuidor
            where n.id_distribuidor_mayorista is not null
                and dn.telefono <> dm.telefono
       )
);

