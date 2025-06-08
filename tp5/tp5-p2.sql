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

--Ejercicio 3
--Para el esquema de la figura cuyo script de creación de tablas lo podes descargar de aquí
--A. Controlar que las nacionalidades sean &#39;Argentina&#39; &#39;Español&#39; &#39;Inglés&#39; &#39;Alemán&#39; o &#39;Chilena&#39;.
alter table articulo
add constraint ck_nacionalidad
check ( nacionalidad in ('Argentina', 'Español', 'Inglés', 'Alemán', 'Chilena' ));
--B. Para las fechas de publicaciones se debe considerar que sean fechas posteriores o iguales
--al 2010.
alter table articulo
add constraint fecha_posterior_2010
check ( fecha_publicacion >= '2010-01-01' );
--C. Cada palabra clave puede aparecer como máximo en 5 artículos.
alter table articulo
add constraint max_token_art
check (
    not exists(
        select 1
        from contiene c
        group by c.cod_palabra
        having (count(*)) > 5
        )
    );
--D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
--claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
--artículos que contengan hasta 10 palabras claves.
create assertion max_token_arg
check(not exists(
       select 1
       from articulo a
       join contiene co on a.id_articulo = co.id_articulo
       where a.nacionalidad = 'Argentino'
       group by co.cod_palabra
       having (count(co.cod_palabra)) > 15
)and not exists(
              select 1
       from articulo a
       join contiene co on a.id_articulo = co.id_articulo
       where a.nacionalidad <> 'Argentino'
       group by co.cod_palabra
       having (count(co.cod_palabra)) > 10
));

--Ejercicio 4
--Para el esquema de la figura cuyo script de creación de tablas lo podes descargar de aquí
--A. La modalidad de la imagen médica puede tomar los siguientes valores RADIOLOGIA
--CONVENCIONAL, FLUOROSCOPIA, ESTUDIOS RADIOGRAFICOS CON
--FLUOROSCOPIA, MAMOGRAFIA, SONOGRAFIA,
alter table imagen_medica
add constraint modalidad_imagen_tomas
check ( modalidad in ('RADIOLOGIA', 'CONVENCIONAL', 'FLUOROSCOPIA',
                      'ESTUDIOS RADIOGRAFICOS CON FLUOROSCOPIA',
                      'MAMOGRAFIA', 'SONOGRAFIA'));
--B. Cada imagen no debe tener más de 5 procesamientos.
alter table procesamiento
add constraint max_proces
check ( not exists(
            select 1
            from procesamiento p
            group by p.id_paciente, p.id_imagen
            having count(*) > 5
        )
    )
--C. Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una
--indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle
--que la segunda no sea menor que la primera.
ALTER TABLE imagen_medica
ADD COLUMN fecha_img date;

ALTER TABLE procesamiento
ADD COLUMN fecha_proc date;

create assertion control_fechas_imgmed_proces
check(not exists(
       select 1
       from imagen_medica im
       join procesamiento p on im.id_imagen = p.id_imagen
       where fecha_img > fecha_proc
));
--D. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.
ALTER TABLE imagen_medica
   ADD CONSTRAINT ck_max_fluoroscopia
   CHECK ( NOT EXISTS (
                SELECT 1
                FROM imagen_medica
                WHERE modalidad = 'FLUOROSCOPIA'
                GROUP BY id_paciente, extract(year from fecha_img)
                HAVING COUNT(*) > 2 ));
--E. No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de
--FLUOROSCOPIA
CREATE ASSERTION
   CHECK ( NOT EXISTS (
                SELECT 1
                FROM imagen_medica im
                JOIN procesedimiento p on (im.id_imagen = p.id_imagen and im.id_paciente = p.id_paciente)
                JOIN algoritmo a on p.id_algoritmo = a.id_algoritmo
                WHERE im.modalidad = 'FLUOROSCOPIA'
                    and a.costo_computacional = '0(n)'
             )
       );

--Ejercicio 5
--A. Los descuentos en las ventas son porcentajes y deben estar entre 0 y 100.
alter table ventas
add constraint porc_desc
check ( descuento between (0 and 100));
--B. Los descuentos realizados en fechas de liquidación deben superar el 30%.
create assertion fec_liq_desc_30
check(
       not exists(
            select 1
            from venta v
            join fecha_liq_ fl on (
                    extract(day from v.fecha) = fl.dia_liq
                    and
                    extract(month from v.fecha) = fl.mes_liq
            )
            where v.descuento <= 30
       )
);
--C. Las liquidaciones de Julio y Diciembre no deben superar los 5 días.
       create assertion max_dis_liq
check(
       not exists(
            select 1
            from fecha_liq
            where mes_liq not in (7 and 12)
            group by cant_dias
            having count(cant_dias) < 5
       )
);
--D. Las prendas de categoría ‘oferta’ no tienen descuentos.
CREATE ASSERTION ck_oferta_sin_descuento
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM venta v
        JOIN PRENDA p ON v.id_prenda = p.id_prenda
        WHERE p.categoria = 'oferta'
          AND v.descuento > 0.00
    )
);
