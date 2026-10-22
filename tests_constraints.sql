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
