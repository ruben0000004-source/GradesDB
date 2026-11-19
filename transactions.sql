USE grados;

-- EJEMPLOS

-- AUTOCOMMIT 1

CALL p_populate();

SET AUTOCOMMIT = 1;
START TRANSACTION;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (7, 1, 7.5, 'Extraordinaria', 0);

SELECT @@in_transaction;
ROLLBACK;


-- AUTOCOMMIT 0

CALL p_populate();

SET AUTOCOMMIT = 0;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);

SELECT @@in_transaction;
ROLLBACK;

SET AUTOCOMMIT = 1;