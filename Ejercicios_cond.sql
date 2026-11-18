-- crear un programa que declare las siguientes variables: nombre de un estudiante, edad, carrera y semestre
DECLARE
    -- SE DECLARAN LAS VARIABLES
    v_nombre_est NVARCHAR2(50);
    v_edad INT;
    v_carrera NVARCHAR2(50);
    v_semestre INT;
BEGIN
    -- SE ASIGNAN LOS VALORES A LAS VARIABLES
    v_nombre_est:= 'AXEL';
    v_edad:= 20;
    v_carrera:= 'INGENIERIA EN TICS';
    v_semestre:= 4;

    -- SE MUESTRAN LOS VALORES DE LAS VARIABLES EN PANTALLA
    DBMS_OUTPUT.PUT_LINE('NOMBRE:'|| v_nombre_est);
    DBMS_OUTPUT.PUT_LINE('EDAD:'|| v_edad);
    DBMS_OUTPUT.PUT_LINE('CARRERA:'|| v_carrera);
    DBMS_OUTPUT.PUT_LINE('SEMESTRE:'|| v_semestre);
END; -- SE CIERRA EL BLOQUE DE CODIGO
/

-- Identificar el numero mayor: declarar tres variables numericas y determinar cual contiene el numero mayor
-- mostrar el resultado en pantalla
DECLARE
    -- SE DECLARAN LAS VARIABLES NUMERICAS Y LA VARIABLE PARA EL NUMERO MAYOR
    v_numero1 INT;
    v_numero2 INT;
    v_numero3 INT;
    v_num_mayor INT;
BEGIN
    -- SE ASIGNAN LOS VALORES A LAS VARIABLES
    v_numero1:= 15;
    v_numero2:= 8;
    v_numero3:= 20;
    -- SE DETERMINA CUAL ES EL NUMERO MAYOR
IF v_numero1 >= v_numero2 AND v_numero1 >= v_numero3 THEN 
    v_num_mayor:= v_numero1;
ELSIF v_numero2 >= v_numero1 AND v_numero2 >= v_numero3 THEN 
    v_num_mayor:= v_numero2;
ELSE 
    v_num_mayor:= v_numero3;
END IF;
    -- SE MUESTRA EL RESULTADO EN PANTALLA
DBMS_OUTPUT.PUT_LINE('EL NUMERO MAYOR ES: ' || v_num_mayor);
END;-- SE CIERRA EL BLOQUE DE CODIGO
/

-- Hacer una calculadora que sume, reste, multiplique y divida dos numeros
DECLARE
    --SE DECLARAN LAS VARIABLES DE LOS NUMEROS Y LOS RESULTADOS
    v_num1           NUMBER;
    v_num2           NUMBER;
    v_suma           NUMBER;
    v_resta          NUMBER;
    v_multiplicacion NUMBER;
    v_division       NUMBER;

BEGIN
    -- 1. Asignación de valores
    v_num1 := 20;
    v_num2 := 4;

    -- 2. Operaciones matemáticas
    v_suma           := v_num1 + v_num2;
    v_resta          := v_num1 - v_num2;
    v_multiplicacion := v_num1 * v_num2;

    -- 3. Impresión de resultados
    DBMS_OUTPUT.PUT_LINE('Numero 1: ' || v_num1);
    DBMS_OUTPUT.PUT_LINE('Numero 2: ' || v_num2);
    DBMS_OUTPUT.PUT_LINE('---------------------------');
    DBMS_OUTPUT.PUT_LINE('Suma: ' || v_suma);
    DBMS_OUTPUT.PUT_LINE('Resta: ' || v_resta);
    DBMS_OUTPUT.PUT_LINE('Multiplicacion: ' || v_multiplicacion);

    -- Condicional para evitar division entre cero
    IF v_num2 <> 0 THEN
        v_division := v_num1 / v_num2;
        DBMS_OUTPUT.PUT_LINE('Division: ' || ROUND(v_division, 2));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Division: Error, no se puede dividir entre cero');
    END IF;-- SE CIERRA EL BLOQUE DE CODIGO

END;-- SE CIERRA EL BLOQUE DE CODIGO
/