-- Rubén Andrade Martínez
-- Fecha: Octubre 2026

USE grados

CREATE OR REPLACE TABLE test_results(
	test_id VARCHAR(20) PRIMARY KEY,
	test_name VARCHAR(200) NOT NULL,
	test_message VARCHAR(500) NOT NULL,
	test_status ENUM('PASS', 'FAIL') NOT NULL,
	execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);
	
	
DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(
	IN p_test_id VARCHAR(20),
	IN p_message VARCHAR(500),
	IN p_status ENUM('PASS','FAIL')
	)
BEGIN 
	INSERT INTO test_results(test_id, test_name, test_message, test_status)
	VALUES (p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;


-- TEST RN01

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn01_mh_requirement()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('RN01', 'RN01: MH necesita una nota >= 9', 'PASS');
		CALL p_populate();
		UPDATE grades
			SET with_honors = 1
			WHERE grade_id = 21;
		
		CALL p_log_test('RN01', 'ERROR: Se permitió MH con una nota inferior a 9', 'FAIL');
		
END //
DELIMITER ;


-- TEST RN09

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn09_not_null_attributes()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('RN09', 'RN09: Los atributos obligatorios no pueden ser NULL', 'PASS');
	CALL p_populate();
	
	INSERT INTO people(person_id, dni, first_name, last_name, age, email)
	VALUES (103, '20000003C', NULL, 'Campos', 22, 'null@alum.us.es');
	
	CALL p_log_test('RN09', 'ERROR: Hay atributos obligatorios que son NULL', 'FAIL');
END //
DELIMITER ;


-- TEST RN10

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn10_subject_credits()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	CALL p_log_test('RN10', 'RN10: Los créditos de una asignatura solamente pueden ser 6 o 12', 'PASS');
	
	CALL p_populate();
	
	INSERT INTO subjects(subject_id, degree_id, subject_name, acronym, credits, course, subject_type)
	VALUES (31, 3, 'Asignatura Inválida', 'AI', 8, 2, 'Obligatoria');
	
	CALL p_log_test('RN10', 'ERROR: Se permitió una asignatura con créditos inválidos', 'FAIL');
END //
DELIMITER ;


-- TEST RN11

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn11_grade_range()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	CALL p_log_test('RN11', 'RN11: La nota debe ser mayor o igual a 0 y menor o igual a 10', 'PASS');
	
	CALL p_populate();
	
	INSERT INTO grades (grade_id, student_id, group_id, grade_value, exam_call, with_honors)
	VALUES (201, 6, 1, 11.0, 'Primera', 0);
	
	CALL p_log_test('RN11', 'ERROR: Hay una nota fuera de rango', 'FAIL');
END // 
DELIMITER ;


-- TEST RN12

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn12_people_age()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	CALL p_log_test('RN12', 'RN12: La edad debe ser un valor comprendido entre 16 y 70', 'PASS');
	
	CALL p_populate();
	
	INSERT INTO people(person_id, dni, first_name, last_name, age, email)
	VALUES (105, '20000005E', 'Edad', 'Fuera', 80, 'edad@alum.us.es');
	
	CALL p_log_test('RN12', 'ERROR: Hay una edad fuera de rango','FAIL');
END //
DELIMITER ;
