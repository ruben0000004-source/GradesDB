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

DELIMITER //
CREATE OR REPLACE PROCEDURE p_student_average(IN p_student_id INT, OUT p_average DECIMAL(4,2))
BEGIN 
	SELECT AVG(grade_value) INTO p_average
	FROM grades
	WHERE student_id = p_student_id;
END //
DELIMITER ;

-- EJECUCIÓN 3

CALL p_student_average(6, @avg_student_6);
SELECT @avg_student_6 AS 'Promedio estudiante 6';

CALL p_student_average(7, @avg_student_7);
CALL p_student_average(8, @avg_student_8);
SELECT @avg_student_6, @avg_student_7, @avg_student_8;


-- EJEMPLO 4 <-> boost_group_grades

DELIMITER //
CREATE OR REPLACE PROCEDURE p_boost_group_grades(IN p_group_id INT, IN p_exam_call VARCHAR(20))
BEGIN 
	DECLARE v_affected_rows INT;
	DECLARE v_group_name VARCHAR(40);
	SELECT group_name INTO v_group_name
	FROM groups
	WHERE group_id = p_group_id;
	
	
	UPDATE grades
	SET grade_value = LEAST(grade_value * 1.15, 10.0)
	WHERE group_id = p_group_id
		AND exam_call = p_exam_call
		AND grade_value BETWEEN 4.5 AND 8.0;
		
	SET v_affected_rows = ROW_COUNT();
	SELECT v_group_name AS group_name, v_affected_rows AS updated_grades;
END //
DELIMITER ;

-- EJECUCIÓN 4

SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera'
ORDER BY g.grade_value;

CALL p_boost_group_grades(1, 'Primera');

SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera'
ORDER BY g.grade_value;


-- EJEMPLO 5 <-> assign_honors

DELIMITER //
CREATE OR REPLACE PROCEDURE p_assign_honors(IN p_group_id INT, IN p_exam_call VARCHAR(20))
BEGIN
	DECLARE v_total_students INT;
	DECLARE v_max_honors INT;
	SELECT COUNT(*) INTO v_total_students
	FROM group_enrollments
	WHERE group_id = p_group_id;
	
	SET v_max_honors = FLOOR(v_total_students * 0.05);
	IF v_max_honors = 0 THEN
		SELECT CONCAT('No se pueden dar matrículas de honor: ', 'el 5% de ', v_total_students, ' estudiantes matriculados es 0') AS msg;
	ELSE 
		UPDATE grades
		SET with_honors = 0
		WHERE group_id = p_group_id
		AND exam_call = p_exam_call;
		
		UPDATE grades
		SET with_honors = 1
		WHERE grade_id IN (SELECT selected_grades.grade_id 
			FROM (
					SELECT grade_id
					FROM grades
					WHERE group_id = p_group_id
					AND exam_call = p_exam_call
					AND grade_value >= 9.0
					ORDER BY grade_value DESC
					LIMIT v_max_honors
				) AS selected_grades
			);
		END IF;
	END//
	DELIMITER ;

-- EJECUCIÓN 5

SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.with_honors, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera'
ORDER BY g.grade_value DESC;

CALL p_assign_honors(1, 'Primera');

SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.with_honors, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = 'Primera' AND g.with_honors = 1
ORDER BY g.grade_value DESC;