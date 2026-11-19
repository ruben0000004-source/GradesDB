USE grados;

-- SIN TRANSACCIÓN

DELIMITER //
CREATE OR REPLACE PROCEDURE p_insert_degree_subject(
	IN p_degree_name VARCHAR(80),
	IN p_degree_years TINYINT,
	IN p_subject_name VARCHAR(120),
	IN p_subject_acronym VARCHAR(12),
	IN p_subject_credits TINYINT,
	IN p_subject_course TINYINT,
	IN p_subject_type VARCHAR(30)
)
BEGIN 
	DECLARE v_new_degree_id INT;
	INSERT INTO DEGREES (degree_name, duration_years)
	VALUES (p_degree_name, p_degree_years);
	
	SET v_new_degree_id = LAST_INSERT_ID();
	
	INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type)
	VALUES (v_new_degree_id, p_subject_name, p_subject_acronym, p_subject_credits, p_subject_course, p_subject_type);

END //
DELIMITER ;

-- DATOS

CALL p_populate();

CALL p_insert_degree_subject(
	'Grado en Inteligencia Artificial',
	4,
	'Aprendizaje Automático',
	'AA',
	6,
	3,
	'Obligatoria'
);

SELECT * FROM DEGREES WHERE degree_name = 'Grado en Inteligencia Artificial';
SELECT * FROM subjects WHERE acronym = 'AA';

-- DATOS ERRONEOS

CALL p_populate();

CALL p_insert_degree_subject(
	'Grado en Ciberseguridad',
	4,
	'Redes Neuronales',
	'FP',
	6,
	3,
	'Obligatoria'
);

SELECT * FROM DEGREES WHERE degree_name = 'Grado en Ciberseguridad';
SELECT * FROM subjects WHERE subject_name = 'Redes Neuronales';

