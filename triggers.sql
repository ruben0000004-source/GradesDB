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