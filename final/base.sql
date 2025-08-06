-- Creamos la base de datos
CREATE DATABASE universidad;
\c universidad;

-- Tabla carrera
CREATE TABLE carrera (
    id_carrera SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    duracion_anios INT CHECK (duracion_anios BETWEEN 1 AND 10)
);

-- Tabla estudiante
CREATE TABLE estudiante (
    id_estudiante SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    id_carrera INT REFERENCES carrera(id_carrera) ON DELETE SET NULL
);

-- Tabla profesor
CREATE TABLE profesor (
    id_profesor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    id_departamento INT
);

-- Tabla departamento
CREATE TABLE departamento (
    id_departamento SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

-- Agregamos la clave foránea faltante a profesor
ALTER TABLE profesor
ADD CONSTRAINT fk_profesor_departamento
FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) ON DELETE SET NULL;

-- Tabla materia
CREATE TABLE materia (
    id_materia SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_carrera INT REFERENCES carrera(id_carrera),
    id_profesor INT REFERENCES profesor(id_profesor),
    cuatrimestre INT CHECK (cuatrimestre BETWEEN 1 AND 2)
);

-- Tabla aula
CREATE TABLE aula (
    id_aula SERIAL PRIMARY KEY,
    edificio VARCHAR(50) NOT NULL,
    numero_aula VARCHAR(10) NOT NULL,
    capacidad INT CHECK (capacidad > 0)
);

-- Tabla horario
CREATE TABLE horario (
    id_horario SERIAL PRIMARY KEY,
    id_materia INT REFERENCES materia(id_materia) ON DELETE CASCADE,
    id_aula INT REFERENCES aula(id_aula),
    dia_semana VARCHAR(10) CHECK (dia_semana IN ('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes')),
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    CHECK (hora_fin > hora_inicio)
);

-- Tabla inscripcion
CREATE TABLE inscripcion (
    id_inscripcion SERIAL PRIMARY KEY,
    id_estudiante INT REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    id_materia INT REFERENCES materia(id_materia) ON DELETE CASCADE,
    fecha_inscripcion DATE DEFAULT CURRENT_DATE,
    nota NUMERIC(4,2) CHECK (nota BETWEEN 0 AND 10)
);
