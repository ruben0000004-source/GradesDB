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
	
