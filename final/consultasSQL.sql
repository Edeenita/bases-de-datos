-- Consultas SQL 


-- Ejercicio 1
-- Mostrar todos los campos de la tabla `estudiante`.
SELECT * FROM estudiante;
---

--- Ejercicio 2
--- Mostrar únicamente el nombre y apellido de los estudiantes.
SELECT nombre, apellido FROM estudiante;
---

--- Ejercicio 3
--- Listar los emails de estudiantes nacidos después del 1 de enero del año 2000.
SELECT email FROM estudiante
WHERE fecha_nac >= '2000-1-1'
---

-- Ejercicio 4
-- Listar todos los estudiantes ordenados por apellido (alfabéticamente ascendente).
SELECT apellido FROM estudiante
ORDER BY apellido ASC -- POR DEFECTO ES ASCENDENTE
---

-- Ejercicio 5
-- Mostrar cuántos estudiantes hay registrados.
SELECT count(*) FROM estudiante

---

-- Ejercicio 6
-- Mostrar el nombre de todas las carreras que tengan una duración mayor a 4 años.
SELECT nombre FROM carrera
WHERE duracion_anios > 4;
---
-- Ejercicio 7
-- Mostrar la duración promedio (en años) de las carreras.
SELECT AVG(duracion_anios) FROM carrera
WHERE duracion_anios IS NOT NULL;
---

-- Ejercicio 8
-- Mostrar el nombre de la carrera con mayor duración.
SELECT nombre from carrera
ORDER BY duracion DESC 
LIMIT 1
---

-- Ejercicio 9
-- Listar todos los profesores mostrando nombre, apellido y email.
SELECT nombre, apellido, email from profesor
---

-- Ejercicio 10
-- Contar cuántos profesores hay por cada departamento (solo usando la tabla `profesor`).
SELECT count(*), d.nombre from profesor p 
join departamento d on p.id_departamento = d.id_departamento
GROUP BY d.nombre;
---
--parte 2
-- Ejercicio 1
-- Mostrar el nombre completo de los estudiantes junto con el nombre de la carrera que están cursando.
SELECT e.nombre, e.apellido, c.nombre from estudiante e
join carrea c on e.id_carrera = c.id_carrera
--


-- Ejercicio 2
-- Listar el nombre y apellido de los profesores que pertenecen al departamento 'Ciencias Exactas'.
SELECT p.apellido, p.nombre from profesor
join d.departamento on p.id_departamento = d.id_departamento
WHERE d.nombre = 'Ciencias Exactas'
--


-- Ejercicio 3
-- Mostrar los nombres de las materias dictadas por profesores cuyo apellido sea 'Gómez'.


--


-- Ejercicio 4
-- Listar el nombre y apellido de los estudiantes que nacieron después del 1 de enero del 2000
-- y que están en una carrera con duración mayor a 4 años.

--


-- Ejercicio 5
-- Mostrar el nombre de las carreras que tienen más de 2 estudiantes inscriptos.

--


-- Ejercicio 6
-- Mostrar para cada carrera el promedio de edad de los estudiantes inscriptos.
-- Usar funciones de agrupamiento, JOIN, y cálculo de edad.

--


-- Ejercicio 7
-- Mostrar el nombre y apellido del profesor que dicta más materias.

--


-- Ejercicio 8
-- Listar los estudiantes que cursan al menos una materia dictada por un profesor del departamento 'Matemática'.

--


-- Ejercicio 9
-- Mostrar los nombres de las materias que no tienen ningún estudiante inscripto.
-- Usar subconsulta o LEFT JOIN con IS NULL.

--


-- Ejercicio 10
-- Listar el nombre y apellido de los estudiantes que cursan exactamente las mismas materias que el estudiante con ID = 1.

--
