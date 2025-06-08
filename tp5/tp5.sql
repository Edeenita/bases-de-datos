
--EJ1
--a) Cómo debería implementar las Restricciones de Integridad Referencial (RIR) si se desea que
--cada vez que se elimine un registro de la tabla PALABRA , también se eliminen los artículos
--que la referencian en la tabla CONTIENE.
alter table P5P1E1_CONTIENE
    add constraint fk_contiene_palabra
    FOREIGN KEY (idioma, cod_palabra)
    references P5P1E1_PALABRA (idioma, cod_palabra)
    on delete cascade;

--b) Verifique qué sucede con las palabras contenidas en cada artículo, al eliminar una palabra,
--si definen la Acción Referencial para las bajas (ON DELETE) de la RIR correspondiente
--como:
--ii) Restrict
ALTER TABLE P5P1E1_CONTIENE
ADD CONSTRAINT FK_PALABRA_CONTIENE
FOREIGN KEY (idioma, cod_palabra)
REFERENCES P5P1E1_PALABRA (idioma, cod_palabra)
ON DELETE RESTRICT;
--No se va a poder eliminar ninguna palabra si es usada en un articulo

--iii) Es posible para éste ejemplo colocar SET NULL o SET DEFAULT para ON
--DELETE y ON UPDATE?
-- SET NULL no se puede porque estan definidas como NOT NULL
-- SET DEFAULT es para agregar algo por defecto sino se le dio ningun valor
ALTER TABLE P5P1E1_CONTIENE
ALTER COLUMN idioma SET DEFAULT '-',
ALTER COLUMN cod_palabra SET DEFAULT 0;

------------------------------------------------------------------------------------------------------------------------
--EJ2

--a) Indique el resultado de las siguientes operaciones, teniendo en cuenta las acciones
--referenciales e instancias dadas. En caso de que la operación no se pueda realizar, indicar qué
--regla/s entra/n en conflicto y cuál es la causa. En caso de que sea aceptada, comente el
--resultado que produciría (NOTA: en cada caso considere el efecto sobre la instancia original de
--la BD, los resultados no son acumulativos).

--b.1) delete from tp5_p1_ej2_proyecto where id_proyecto = 3;
    --Me va a dejar eliminarlo ya que no hay ningun auspicio con id_proyecto = 3
--b.2) update tp5_p1_ej2_proyecto set id_proyecto = 7 where id_proyecto = 3;
    --Me va a dejar actualizarlo ya que no hay ningun auspicio que me restrinja =
--b.3) delete from tp5_p1_ej2_proyecto where id_proyecto = 1;
    --No me va a dejar eliminarlo ya que en la tabla tranaja_en hay un elemento que
    --esta referenciado al id_proyecto=1 ya que hay un constraint con restrict
--b.4) delete from tp5_p1_ej2_empleado where tipo_empleado = ‘A’ and nro_empleado = 2;
    --Me dejara borrarlo, en auspicio se seteara en null
    --y en trabaja_en se borran todos los elementos en cascada
--b.5) update tp5_p1_ej2_trabaja_en set id_proyecto = 3 where id_proyecto =1;
    --Si me dejara cambiarla ya que la regla dice que en UPDATE CASCADE
--b.6) update tp5_p1_ej2_proyecto set id_proyecto = 5 where id_proyecto = 2;
    --No dejara ya que estarias cambiando el valor de una PK

    -- SIN RESOLVER
--b) Indique el resultado de la siguiente operaciones justificando su elección:
--update auspicio set id_proyecto= 66, nro_empleado = 10
--where id_proyecto = 22
--and tipo_empleado = 'A';
--and nro_empleado = 5;
--(suponga que existe la tupla asociada)
--i. realiza la modificación si existe el proyecto 22 y el empleado TipoE = 'A'; ,NroE = 5
--ii. realiza la modificación si existe el proyecto 22 sin importar si existe el empleado TipoE = 'A', NroE = 5
--iii.se modifican los valores, dando de alta el proyecto 66 en caso de que no exista (si no se
--violan restricciones de nulidad), sin importar si existe el empleado
--iv. se modifican los valores, y se da de alta el proyecto 66 y el empleado correspondiente (si
--no se violan restricciones de nulidad)
--v. no permite en ningún caso la actualización debido a la modalidad de la restricción entre la
--tabla empleado y auspicio.
--vi. ninguna de las anteriores, cuál?