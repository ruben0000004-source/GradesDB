USE grados;

-- Trigger RN08

DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_students_rn08
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW
BEGIN
	DECLARE v_age TINYINT;
	if NEW.access_method = 'Selectividad' THEN
		SELECT age INTO v_age FROM people WHERE person_id = NEW.student_id;
		if v_age < 16 then
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'RN08: No puede acceder con menos de 16 años por Selectividad';
		END if;
	END if;
END //
DELIMITER ;				 

-- Trigger RN02

DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_grades_rn02
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW 
BEGIN
	DECLARE v_count INT;
	SELECT COUNT(*) INTO v_count
	FROM groups_enrollments
	WHERE student_id = NEW.student_id
		AND group_id = NEW.group_id;
	IF v_count = 0 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'RN02: El alumno no pertenece al grupo indicado';
	END IF;
END //
DELIMITER ;