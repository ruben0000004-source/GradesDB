-- REPEATABLE READ

CALL p_populate();

UPDATE grades
SET grade_value = grade_value + 1
WHERE grade_id = 3;


-- READ COMMITTED

CALL p_populate();

UPDATE grades
SET grade_value = grade_value + 1
WHERE grade_id = 3;