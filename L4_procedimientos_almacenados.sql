-- Rubén Andrade Martínez
-- Fecha: Octubre 2026

USE grados;


-- EJEMPLO 1 <-> delete_student_grades

DELIMITER //

CREATE OR REPLACE PROCEDURE p_delete_student_grades(IN p_student_dni CHAR(9))
BEGIN 
	DECLARE v_student_id INT;
	
	SELECT student_id INTO v_student_id
	FROM people p
	JOIN students s ON s.student_id = p.person_id
	WHERE p.dni = p_student_dni;
	DELETE FROM grades WHERE student_id = v_student_id;

END //
DELIMITER ;

-- EJECUCIÓN 1

CALL p_delete_student_grades('10000006F');

SELECT * FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE p.dni = '10000006F';


-- EJEMPLO 2 <-> delete_all_dato

DELIMITER //
CREATE OR REPLACE PROCEDURE p_delete_all_data()
BEGIN
	DELETE FROM grades;
	DELETE FROM teaching_loads;
	DELETE FROM group_enrollments;
	DELETE FROM subject_enrollments;
	DELETE FROM groups;
	DELETE FROM subjects;
	DELETE FROM students;
	DELETE FROM professors;
	DELETE FROM degrees;
	DELETE FROM people;
END //
DELIMITER ;

-- EJECUCIÓN 2

CALL p_delete_all_data();

SELECT COUNT(*) AS total_grades FROM grades;
SELECT COUNT(*) AS total_students FROM students;
SELECT COUNT(*) AS total_people FROM people;

-- EJEMPLO 3 <-> student_average

-- EJECUCIÓN 3



-- EJEMPLO 4 <-> boost_group_grades

-- EJECUCIÓN 4



-- EJEMPLO 5 <-> assign_honors

-- EJECUCIÓN 5