USE grados;

-- EJEMPLO 1

DELIMITER //
CREATE OR REPLACE FUNCTION f_student_average(
   p_student_id INT
) RETURNS DECIMAL(4,2)
BEGIN
   DECLARE v_average DECIMAL(4,2) DEFAULT 0;
   SELECT COALESCE(AVG(grade_value), 0) INTO v_average
   FROM grades
   WHERE student_id = p_student_id;
   RETURN v_average;
END //
DELIMITER ;

-- EJECUCIÓN 1

SELECT f_student_average(6) AS 'Promedio del estudiante 6';

SELECT p.person_id, p.first_name, p.last_name, f_student_average(s.student_id) AS promedio
FROM people p
JOIN students s ON s.student_id = p.person_id
ORDER BY promedio DESC;

SELECT p.first_name, p.last_name
FROM people p
JOIN students s ON s.student_id = p.person_id
WHERE f_student_average(s.student_id) >= 7.0;

