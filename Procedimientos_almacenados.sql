-- Habilitar la salida en consola de SQL Developer
SET SERVEROUTPUT ON;


-- =====================================================================
-- 1. REINICIAR TABLAS Y SECUENCIAS SI YA EXISTEN
-- Nota: En Oracle no se usa CREATE DATABASE ni USE; se trabaja
-- directamente en el esquema/usuario de tu conexión actual.
-- =====================================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Alumnos CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_alumnos';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Personas CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_personas';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN RAISE; END IF;
END;
/


-- =====================================================================
-- 2. CREAR TABLA ALUMNOS (CON SECUENCIA Y TRIGGER AUTOINCREMENTABLE)
-- =====================================================================

CREATE TABLE Alumnos (
    IdAlumno     NUMBER(10) PRIMARY KEY,
    Nombre       VARCHAR2(100) NOT NULL,
    Edad         NUMBER(10) NOT NULL,
    Calificacion NUMBER(5,2) NOT NULL,
    Estado       VARCHAR2(30) NOT NULL
);

CREATE SEQUENCE seq_alumnos
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_alumnos_id
BEFORE INSERT ON Alumnos
FOR EACH ROW
WHEN (NEW.IdAlumno IS NULL)
BEGIN
    SELECT seq_alumnos.NEXTVAL INTO :NEW.IdAlumno FROM DUAL;
END;
/


-- =====================================================================
-- 3. PROCEDIMIENTO PARA INSERTAR ALUMNOS
-- =====================================================================

CREATE OR REPLACE PROCEDURE InsertarAlumno (
    p_nombre       IN VARCHAR2,
    p_edad         IN NUMBER,
    p_calificacion IN NUMBER
) AS
BEGIN
    -- Insertar directamente el alumno con estado inicial Inscrito.
    INSERT INTO Alumnos (
        Nombre,
        Edad,
        Calificacion,
        Estado
    )
    VALUES (
        p_nombre,
        p_edad,
        p_calificacion,
        'Inscrito'
    );

    COMMIT;
END;
/


-- =====================================================================
-- 4. PROCEDIMIENTO CON CONDICIONAL IF Y ELSE
-- =====================================================================

CREATE OR REPLACE PROCEDURE RegistrarAlumno (
    p_nombre       IN VARCHAR2,
    p_edad         IN NUMBER,
    p_calificacion IN NUMBER
) AS
    v_estado VARCHAR2(30);
BEGIN
    -- Evaluar la calificación recibida.
    IF p_calificacion >= 70 THEN
        v_estado := 'Aprobado';
    ELSE
        v_estado := 'Reprobado';
    END IF;

    -- Insertar los datos del alumno.
    INSERT INTO Alumnos (
        Nombre,
        Edad,
        Calificacion,
        Estado
    )
    VALUES (
        p_nombre,
        p_edad,
        p_calificacion,
        v_estado
    );

    COMMIT;
END;
/


-- =====================================================================
-- 5. PROCEDIMIENTO CON IF, ELSIF Y ELSE
-- =====================================================================

CREATE OR REPLACE PROCEDURE EvaluarAlumno (
    p_nombre       IN VARCHAR2,
    p_edad         IN NUMBER,
    p_calificacion IN NUMBER
) AS
    v_estado VARCHAR2(30);
BEGIN
    -- Clasificar la calificación en 4 niveles.
    IF p_calificacion >= 90 THEN
        v_estado := 'Excelente';
    ELSIF p_calificacion >= 80 THEN
        v_estado := 'Bueno';
    ELSIF p_calificacion >= 70 THEN
        v_estado := 'Suficiente';
    ELSE
        v_estado := 'Reprobado';
    END IF;

    -- Registrar al alumno con su clasificación.
    INSERT INTO Alumnos (
        Nombre,
        Edad,
        Calificacion,
        Estado
    )
    VALUES (
        p_nombre,
        p_edad,
        p_calificacion,
        v_estado
    );

    COMMIT;
END;
/


-- =====================================================================
-- 6. PROCEDIMIENTO CON VALIDACIONES Y CONDICIONALES
-- =====================================================================

CREATE OR REPLACE PROCEDURE RegistrarAlumnoValidado (
    p_nombre       IN VARCHAR2,
    p_edad         IN NUMBER,
    p_calificacion IN NUMBER
) AS
    v_estado VARCHAR2(30);
BEGIN
    -- Validar que el nombre no sea nulo ni esté vacío.
    IF p_nombre IS NULL OR TRIM(p_nombre) IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'El nombre no puede estar vacio');

    -- Validar que la edad sea mayor que cero.
    ELSIF p_edad IS NULL OR p_edad <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La edad debe ser mayor que cero');

    -- Validar que la calificación esté entre 0 y 100.
    ELSIF p_calificacion IS NULL
       OR p_calificacion < 0
       OR p_calificacion > 100 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Calificacion fuera de rango');

    ELSE
        -- Evaluar el resultado académico.
        IF p_calificacion >= 90 THEN
            v_estado := 'Excelente';
        ELSIF p_calificacion >= 80 THEN
            v_estado := 'Bueno';
        ELSIF p_calificacion >= 70 THEN
            v_estado := 'Suficiente';
        ELSE
            v_estado := 'Reprobado';
        END IF;

        -- Insertar el registro validado.
        INSERT INTO Alumnos (
            Nombre,
            Edad,
            Calificacion,
            Estado
        )
        VALUES (
            p_nombre,
            p_edad,
            p_calificacion,
            v_estado
        );

        COMMIT;
    END IF;
END;
/


-- =====================================================================
-- 7. PROCEDIMIENTO PARA ACTUALIZAR CALIFICACIONES
-- =====================================================================

CREATE OR REPLACE PROCEDURE ActualizarCalificacion (
    p_id           IN NUMBER,
    p_calificacion IN NUMBER
) AS
    v_estado VARCHAR2(30);
BEGIN
    -- Validar que la calificación sea correcta.
    IF p_calificacion IS NULL
       OR p_calificacion < 0
       OR p_calificacion > 100 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Calificacion fuera de rango');
    ELSE
        -- Clasificar la nueva calificación.
        IF p_calificacion >= 90 THEN
            v_estado := 'Excelente';
        ELSIF p_calificacion >= 80 THEN
            v_estado := 'Bueno';
        ELSIF p_calificacion >= 70 THEN
            v_estado := 'Suficiente';
        ELSE
            v_estado := 'Reprobado';
        END IF;

        -- Actualizar el registro correspondiente.
        UPDATE Alumnos
        SET
            Calificacion = p_calificacion,
            Estado       = v_estado
        WHERE IdAlumno = p_id;

        COMMIT;
    END IF;
END;
/


-- =====================================================================
-- 8. PROCEDIMIENTO PARA ELIMINAR ALUMNOS
-- =====================================================================

CREATE OR REPLACE PROCEDURE EliminarAlumno (
    p_id IN NUMBER
) AS
BEGIN
    DELETE FROM Alumnos
    WHERE IdAlumno = p_id;

    COMMIT;
END;
/


-- =====================================================================
-- 9. PROCEDIMIENTO PARA CONSULTAR TODOS LOS ALUMNOS
-- =====================================================================

CREATE OR REPLACE PROCEDURE ConsultarAlumnos AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== LISTADO DE ALUMNOS ===');

    FOR alumno IN (
        SELECT
            IdAlumno,
            Nombre,
            Edad,
            Calificacion,
            Estado
        FROM Alumnos
        ORDER BY IdAlumno ASC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || alumno.IdAlumno);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || alumno.Nombre);
        DBMS_OUTPUT.PUT_LINE('Edad: ' || alumno.Edad);
        DBMS_OUTPUT.PUT_LINE('Calificacion: ' || TRIM(TO_CHAR(alumno.Calificacion, '990.00')));
        DBMS_OUTPUT.PUT_LINE('Estado: ' || alumno.Estado);
        DBMS_OUTPUT.PUT_LINE('---------------------------');
    END LOOP;
END;
/


-- =====================================================================
-- 10. EJECUTAR LOS PROCEDIMIENTOS BASE
-- =====================================================================

BEGIN
    -- Insertar alumnos con el primer procedimiento.
    InsertarAlumno('Carlos', 20, 95);
    InsertarAlumno('Maria', 19, 85);

    -- Insertar alumnos utilizando IF y ELSE.
    RegistrarAlumno('Pedro', 21, 70);
    RegistrarAlumno('Andrea', 20, 60);

    -- Insertar alumnos utilizando IF, ELSIF y ELSE.
    EvaluarAlumno('Daniel', 20, 98);
    EvaluarAlumno('Fernanda', 21, 85);
    EvaluarAlumno('Miguel', 19, 75);
    EvaluarAlumno('Karla', 20, 60);

    -- Insertar alumnos con validaciones.
    RegistrarAlumnoValidado('Alejandro', 22, 90);
    RegistrarAlumnoValidado('Sofia', 20, 65);
END;
/


-- =====================================================================
-- 11. CONSULTAR LOS REGISTROS
-- =====================================================================

BEGIN
    ConsultarAlumnos;
END;
/


-- =====================================================================
-- 12. ACTUALIZAR UNA CALIFICACION
-- =====================================================================

BEGIN
    -- Cambiar la calificación del alumno con ID 1.
    ActualizarCalificacion(1, 65);

    -- Verificar los cambios.
    ConsultarAlumnos;
END;
/


-- =====================================================================
-- 13. ELIMINAR UN ALUMNO
-- =====================================================================

BEGIN
    -- Eliminar el alumno con ID 2.
    EliminarAlumno(2);

    -- Verificar que el registro haya sido eliminado.
    ConsultarAlumnos;
END;
/

-- =====================================================================
-- PREPARACION DE DATOS PARA LAS ACTIVIDADES 1 Y 2
-- En los pasos anteriores quedaron 9 alumnos activos en la tabla Alumnos
-- (se insertaron 10 y se elimino el ID 2). Aqui agregamos 11 mas para
-- tener exactamente 20 alumnos que cubran todos los rangos de edad
-- (menores de 18, adultos y adultos mayores) y todos los rangos de beca.
-- =====================================================================

-- Bloque anonimo PL/SQL para ejecutar varias llamadas al procedimiento.
BEGIN
    -- Menores de edad (< 18) con calificaciones de Beca completa (95 a 100).
    RegistrarAlumnoValidado('Ana', 15, 98);
    RegistrarAlumnoValidado('Luis', 17, 100);
    RegistrarAlumnoValidado('Valeria', 16, 96);
    RegistrarAlumnoValidado('Camila', 14, 95);

    -- Adultos (18 a 59) con calificaciones de Media beca (90 a 94.99).
    RegistrarAlumnoValidado('Michelle', 18, 94.50);
    RegistrarAlumnoValidado('Jorge', 28, 94.99);
    RegistrarAlumnoValidado('Gabriela', 59, 92);

    -- Adultos mayores (60 o mas) con los tres tipos de beca.
    RegistrarAlumnoValidado('Roberto', 60, 91.50);   -- Media beca
    RegistrarAlumnoValidado('Elena', 65, 97);        -- Beca completa
    RegistrarAlumnoValidado('Hector', 72, 89.99);    -- Sin beca
    RegistrarAlumnoValidado('Rosa', 68, 78);         -- Sin beca
END;
-- La diagonal (/) le indica a Oracle SQL Developer que ejecute el bloque.
/


-- =====================================================================
-- PRUEBA TECNICA - UNIDAD 4
-- ACTIVIDAD 1. CLASIFICACION POR EDAD
--   Menor de 18    : Menor de edad
--   Entre 18 y 59  : Adulto
--   60 o mas       : Adulto mayor
-- =====================================================================

-- CREATE OR REPLACE crea el procedimiento o lo actualiza si ya existia.
CREATE OR REPLACE PROCEDURE ClasificarPorEdad (
    -- Parametro de entrada (IN) que recibe el nombre del alumno.
    p_nombre IN VARCHAR2,
    -- Parametro de entrada (IN) que recibe la edad del alumno.
    p_edad   IN NUMBER
) AS
    -- Variable local donde se guarda el texto de la clasificacion.
    v_clasificacion VARCHAR2(30);
BEGIN
    -- Validar que el nombre no sea nulo ni contenga solo espacios (TRIM).
    IF p_nombre IS NULL OR TRIM(p_nombre) IS NULL THEN
        -- Detener la ejecucion y lanzar un error personalizado de Oracle
        -- (los codigos de usuario van del -20000 al -20999).
        RAISE_APPLICATION_ERROR(-20001, 'El nombre no puede estar vacio');

    -- Validar que la edad no sea nula ni negativa.
    ELSIF p_edad IS NULL OR p_edad < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Edad fuera de rango');

    -- Si los datos son validos, evaluar el rango de edad.
    ELSE
        -- Primera condicion: menores de 18 anos.
        IF p_edad < 18 THEN
            -- El operador (:=) asigna un valor a una variable en PL/SQL.
            v_clasificacion := 'Menor de edad';

        -- Segunda condicion: edades desde 18 hasta 59 inclusive (BETWEEN).
        ELSIF p_edad BETWEEN 18 AND 59 THEN
            v_clasificacion := 'Adulto';

        -- Cualquier edad restante (60 o mas) cae en el ELSE.
        ELSE
            v_clasificacion := 'Adulto mayor';

        -- Cierra el condicional interno de clasificacion.
        END IF;

        -- Imprimir en la consola los resultados usando (||) para concatenar texto.
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || p_nombre);
        DBMS_OUTPUT.PUT_LINE('Edad: ' || p_edad);
        DBMS_OUTPUT.PUT_LINE('Clasificacion: ' || v_clasificacion);
        DBMS_OUTPUT.PUT_LINE('---------------------------');

    -- Cierra el condicional externo de validaciones.
    END IF;
END;
-- Compila y guarda el procedimiento ClasificarPorEdad en la base de datos.
/

-- Ejecutar Actividad 1 recorriendo los mismos 20 alumnos de la tabla Alumnos.
BEGIN
    -- Encabezado en consola para identificar la salida de la Actividad 1.
    DBMS_OUTPUT.PUT_LINE('=== ACTIVIDAD 1: CLASIFICACION POR EDAD (20 ALUMNOS) ===');

    -- Ciclo FOR con cursor implicito: recorre cada fila devuelta por el SELECT
    -- ordenando primero por edad de menor a mayor (ASC) y luego por ID.
    FOR alumno IN (
        SELECT
            IdAlumno,
            Nombre,
            Edad
        FROM Alumnos
        ORDER BY Edad ASC, IdAlumno ASC
    ) LOOP
        -- Mostrar el ID del registro actual antes de clasificarlo.
        DBMS_OUTPUT.PUT_LINE('ID: ' || alumno.IdAlumno);

        -- Llamar al procedimiento pasando el nombre y la edad de la fila actual.
        ClasificarPorEdad(alumno.Nombre, alumno.Edad);

    -- Finaliza el recorrido cuando ya no quedan mas registros.
    END LOOP;
END;
/


-- =====================================================================
-- ACTIVIDAD 2. SISTEMA DE BECAS
--   Calificacion de 95 a 100    : Beca completa
--   Calificacion de 90 a 94.99  : Media beca
--   Menor de 90                 : Sin beca
-- =====================================================================

-- Crear o reemplazar el procedimiento que evalua la beca de cada alumno.
CREATE OR REPLACE PROCEDURE SistemaBecas AS
    -- Variable local para almacenar el tipo de beca asignado a cada alumno.
    v_beca VARCHAR2(30);
BEGIN
    -- Encabezado en consola para identificar la salida de la Actividad 2.
    DBMS_OUTPUT.PUT_LINE('=== ACTIVIDAD 2: SISTEMA DE BECAS (20 ALUMNOS) ===');

    -- Recorrer los mismos 20 registros de la tabla Alumnos ordenados por ID.
    FOR alumno IN (
        SELECT
            IdAlumno,
            Nombre,
            Edad,
            Calificacion,
            Estado
        FROM Alumnos
        ORDER BY IdAlumno ASC
    ) LOOP
        -- Evaluar si la calificacion esta entre 95 y 100 inclusive.
        IF alumno.Calificacion BETWEEN 95 AND 100 THEN
            v_beca := 'Beca completa';

        -- Evaluar si es mayor o igual a 90 y menor que 95 (cubre 90 a 94.99).
        ELSIF alumno.Calificacion >= 90
          AND alumno.Calificacion < 95 THEN
            v_beca := 'Media beca';

        -- Evaluar si esta entre 0 y menos de 90.
        ELSIF alumno.Calificacion >= 0
          AND alumno.Calificacion < 90 THEN
            v_beca := 'Sin beca';

        -- Respaldo en caso de existir algun valor fuera de 0 a 100.
        ELSE
            v_beca := 'Calificacion no valida';

        -- Cierra el bloque condicional de becas.
        END IF;

        -- Mostrar cada campo del alumno junto con la beca calculada.
        -- TO_CHAR(..., '990.00') formatea el numero siempre con 2 decimales
        -- y TRIM elimina el espacio inicial reservado para el signo.
        DBMS_OUTPUT.PUT_LINE('ID: ' || alumno.IdAlumno);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || alumno.Nombre);
        DBMS_OUTPUT.PUT_LINE('Edad: ' || alumno.Edad);
        DBMS_OUTPUT.PUT_LINE('Calificacion: ' || TRIM(TO_CHAR(alumno.Calificacion, '990.00')));
        DBMS_OUTPUT.PUT_LINE('Estado: ' || alumno.Estado);
        DBMS_OUTPUT.PUT_LINE('Beca: ' || v_beca);
        DBMS_OUTPUT.PUT_LINE('---------------------------');

    -- Finaliza el ciclo FOR al terminar los 20 alumnos.
    END LOOP;
END;
-- Compila y guarda el procedimiento SistemaBecas.
/

-- Ejecutar el procedimiento de la Actividad 2.
BEGIN
    SistemaBecas;
END;
/


-- =====================================================================
-- CONSULTAS DE VERIFICACION FINAL
-- =====================================================================

-- Contar cuantos alumnos hay en total (debe devolver 20).
SELECT COUNT(*) AS TotalAlumnos
FROM Alumnos;

-- Mostrar en formato tabla los 20 alumnos utilizados en ambas actividades.
SELECT
    IdAlumno,
    Nombre,
    Edad,
    Calificacion,
    Estado
FROM Alumnos
ORDER BY IdAlumno ASC;

--INTEGRANTES
-- ABIMAEL SALUIS SANLUIS
-- MICHELLE MARQUEZ OROPEZA
-- ALEJANDRO HERRERA HERNANDEZ