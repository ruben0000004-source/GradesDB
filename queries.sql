-- 
-- Autor: Rubén Andrade Martínez
-- Fecha: Octubre 2026
-- Descripción: Consultas SQL de ejemplo para GradesDB
--              Cubre conceptos de consultas simples y avanzadas
-- 

USE grados;

-- 1

SELECT *
FROM subjects;

-- 2

SELECT *
FROM subjects s
WHERE s.acronym = 'IISSI-1';

-- 3

SELECT s.subject_name, s.acronym
FROM subjects s;

-- 4

SELECT s.subject_name, s.acronym, s.subject_type
FROM subjects s
WHERE s.subject_type = 'Formación Básica';

-- 5

SELECT p.first_name, p.last_name, st.access_method
FROM students st
JOIN people p ON st.student_id = p.person_id
WHERE st.access_method = 'Selectividad';

-- 6

SELECT p.first_name, p.last_name, pr.category
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id
WHERE pr.category = 'Catedrático';

-- Vista v_professors

CREATE OR REPLACE VIEW v_professors AS
SELECT 
	pr.professor_id,
	pr.category,
	p.person_id,
	p.dni,
	p.first_name,
	p.last_name,
	p.age,
	p.email
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id;

-- Vista v_students

CREATE OR REPLACE VIEW v_students AS
SELECT 
    st.student_id,
    st.access_method,
    p.person_id,
    p.dni,
    p.first_name,
    p.last_name,
    p.age,
    p.email
FROM students st
JOIN people p ON st.student_id = p.person_id;

-- 7

SELECT AVG(g.grade_value) AS average_grade
FROM grades g
WHERE g.group_id = 1;

-- 8

SELECT SUM(s.credits) AS total_credits
FROM subjects s
WHERE s.degree_id = 3;

-- 9

SELECT COUNT(*) AS total_students
FROM students;

-- 10

SELECT activity, COUNT(*) AS total_groups
FROM groups
GROUP BY activity;

-- 11

SELECT MAX(g.grade_value) AS max_grade
FROM grades g;

-- 12

SELECT MIN(g.grade_value) AS min_grade
FROM grades g;

-- 13

SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value < 5 OR g.grade_value > 9;

-- 14

SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value BETWEEN 5 AND 7;

-- 15

SELECT s.subject_name, s.credits
FROM subjects s
WHERE s.credits IN (6, 12);

-- 16

SELECT p.first_name, p.last_name, p.age
FROM people p
WHERE p.age BETWEEN 20 AND 30;
	
-- 17
	
SELECT DISTINCT g.group_name
FROM groups g;

-- 18

SELECT DISTINCT s.subject_type
FROM subjects s;

-- 19

SELECT DISTINCT g.academic_year
FROM groups g
ORDER BY g.academic_year DESC;

-- 20

SELECT MAX(g.grade_value) AS max_grade
FROM grades g
WHERE g.student_id = 6;

-- 21

SELECT DISTINCT ge.student_id
FROM group_enrollments ge
WHERE ge.group_id IN(
	SELECT g.group_id
	FROM groups g
	WHERE g.academic_year = 2024
);

-- 22

SELECT s.subject_name, s.credits
FROM subjects s
WHERE s.credits > (SELECT AVG(credits) FROM subjects);

-- 23

SELECT p.first_name, p.last_name, p.dni
FROM people p
WHERE p.dni LIKE '%A';

-- 24

SELECT s.subject_name 
FROM subjects s
WHERE s.subject_name LIKE 'Fundamentos%';

-- 25

SELECT p.first_name, p.last_name
FROM people p
WHERE p.first_name LIKE '_____';

-- 26

SELECT g.group_name, g.activity, g.academic_year
FROM groups g
WHERE g.academic_year = 2024;

-- 27

SELECT g.group_name, g.activity, g.academic_year
FROM groups g
WHERE g.academic_year BETWEEN 2020 AND 2023
ORDER BY g.academic_year;

-- Vista v_grades_with_honors

CREATE OR REPLACE VIEW v_grades_with_honors AS
SELECT g.grade_id, g.student_id, g.group_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.with_honors = 1;

-- Vista v_students_grades

CREATE OR REPLACE VIEW v_student_grades AS
SELECT
	p.person_id,
	p.first_name,
	p.last_name,
	p.dni,
	g.grade_value,
	g.exam_call,
	g.with_honors,
	gr.group_name,
	gr.activity,
	gr.academic_year,
	s.subject_name,
	s.acronym,
	s.credits
FROM people p
JOIN students st ON p.person_id = st.student_id
JOIN grades g ON st.student_id = g.student_id
JOIN groups gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- Vista v_professor_loads

CREATE OR REPLACE VIEW v_professor_loads AS
SELECT
	p.person_id,
	p.first_name,
	p.last_name,
	pr.category,
	tl.credits AS teaching_credits,
	gr.group_name,
	gr.activity,
	gr.academic_year,
	s.subject_name,
	s.acronym
FROM people p
JOIN professors pr ON p.person_id = pr.professor_id
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
JOIN groups gr ON tl.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- Vista v_degree_students

CREATE OR REPLACE VIEW v_degree_students AS
SELECT DISTINCT
   d.degree_id,
   d.degree_name,
   p.person_id,
   p.first_name,
	p.last_name,
   st.access_method,
   gr.academic_year
FROM degrees d
JOIN subjects s ON d.degree_id = s.degree_id
JOIN groups gr ON s.subject_id = gr.subject_id
JOIN group_enrollments ge ON gr.group_id = ge.group_id
JOIN students st ON ge.student_id = st.student_id
JOIN people p ON st.student_id = p.person_id;

-- 28

SELECT COUNT(*) AS total_honors
FROM v_grades_with_honors;

-- 29

SELECT v.first_name, v.last_name, AVG(v.grade_value) AS average_grade
FROM v_student_grades v
GROUP BY v.person_id, v.first_name, v.last_name;

-- 30

SELECT g.grade_id, g.student_id, g.grade_value, g.exam_call
FROM grades g
ORDER BY g.grade_value ASC;

-- 31

SELECT g.grade_id, g.student_id, g.grade_value, g.exam_call
FROM grades g
ORDER BY g.grade_value DESC;

-- 32

SELECT g.grade_id, g.student_id, g.grade_value, g.exam_call
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5;

-- 33

SELECT
	st.first_name,
	st.last_name,
	g.grade_value,
	g.exam_call
FROM grades g
JOIN v_students st ON g.student_id = st.student_id
WHERE g.grade_value >= 5
ORDER BY st.last_name ASC, st.first_name ASC;

-- 34

SELECT g.grade_id, g.student_id, g.grade_value
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5 OFFSET 5;

-- 35

SELECT g.grade_id, g.student_id, g.grade_value
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5 OFFSET 10;

-- 36

SELECT g.group_name, g.activity, g.academic_year
FROM groups g
ORDER BY g.academic_year DESC, g.group_name ASC;

-- 37

SELECT 
	st.first_name,
	st.last_name,
	gr.group_name,
	gr.activity,
	gr.academic_year
FROM v_students st
JOIN group_enrollments ge ON st.student_id = ge.student_id
JOIN groups gr ON ge.group_id = gr.group_id;

-- 38

SELECT 
	d.degree_name,
	s.subject_name,
	s.acronym,
	s.credits,
	s.course,
	s.subject_type
FROM degrees d
JOIN subjects s ON d.degree_id = s.degree_id
ORDER BY d.degree_name, s.course;

-- 39

SELECT 
   st.first_name,
   st.last_name,
   s.subject_name,
   s.acronym,
   g.grade_value,
   g.exam_call,
   gr.academic_year
FROM grades g
JOIN v_students st ON g.student_id = st.student_id
JOIN groups gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- 40

SELECT 
   pr.first_name,
   pr.last_name,
   pr.category,
   s.subject_name,
   gr.group_name,
   gr.activity,
   tl.credits AS teaching_credits
FROM v_professors pr
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
JOIN groups gr ON tl.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

-- 41

SELECT DISTINCT
	st.first_name,
	st.last_name,
	s.subject_name,
	s.acronym,
	gr.academic_year
FROM v_students st
JOIN group_enrollments ge ON st.student_id = ge.student_id
JOIN groups gr ON ge.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id
ORDER BY st.last_name, s.subject_name;

-- 42

SELECT 
	st.first_name,
	st.last_name,
	g.grade_value,
	g.exam_call
FROM v_students st
LEFT JOIN grades g ON st.student_id = g.student_id;

-- 43

SELECT 
	st.first_name,
	st.last_name,
	AVG(g.grade_value) AS average_grade,
	COUNT(*) AS total_grades
FROM v_students st
JOIN grades g ON st.student_id = g.student_id
GROUP BY st.student_id, st.first_name, st.last_name;

-- 44

SELECT 
	st.access_method,
	COUNT(*) AS total_students
FROM students st
GROUP BY st.access_method;

-- 45

SELECT 
	d.degree_name,
	COUNT(*) AS total_subjects
FROM degrees d
JOIN subjects s ON d.degree_id = s.degree_id
GROUP BY d.degree_id, d.degree_name;

-- 46

SELECT 
	s.subject_name,
	s.acronym,
	COUNT(*) AS total_groups
FROM subjects s
JOIN groups gr ON s.subject_id = gr.subject_id
GROUP BY s.subject_id, s.subject_name, s.acronym;

-- 47

SELECT 
	g.exam_call,
	AVG(g.grade_value) AS average_grade,
	COUNT(*) AS total_grades
FROM grades g
GROUP BY g.exam_call;

-- 48

SELECT 
	s.subject_name,
	g.exam_call,
	AVG(g.grade_value) AS average_grade,
	COUNT(*) AS total_grades
FROM grades g
JOIN groups gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id
GROUP BY s.subject_id, s.subject_name, g.exam_call
ORDER BY s.subject_name, g.exam_call;

-- 49

SELECT
	gr.academic_year,
	COUNT(DISTINCT ge.student_id) AS total_students
FROM groups gr
JOIN group_enrollments ge ON gr.group_id = ge.group_id
GROUP BY gr.academic_year
ORDER BY gr.academic_year DESC;

-- 50

SELECT 
	pr.first_name,
	pr.last_name,
	pr.category,
	SUM(tl.credits) AS total_credits
FROM v_professors pr
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
GROUP BY pr.professor_id, pr.first_name, pr.last_name, pr.category;

-- 51

SELECT 
	st.first_name,
	st.last_name,
	AVG(g.grade_value) AS average_grade
FROM v_students st
JOIN grades g ON st.student_id =  g.student_id
GROUP BY st.student_id, st.first_name, st.last_name
HAVING AVG(g.grade_value) > 7;

-- 52

SELECT
	s.subject_name,
	COUNT(*) AS total_groups
FROM subjects s
JOIN groups gr ON s.subject_id =  gr.subject_id
GROUP BY s.subject_id, s.subject_name
HAVING COUNT(*) > 3;

-- 53

SELECT 
	gr.group_name,
	gr.activity,
	COUNT(*) AS total_students
FROM groups gr
JOIN group_enrollments ge ON gr.group_id = ge.group_id
GROUP BY gr.group_id, gr.group_name, gr.activity
HAVING COUNT(*) > 15;

-- 54

SELECT 
	s.subject_name,
	AVG(g.grade_value) AS average_grade,
	COUNT(*) AS total_grades
FROM subjects s
JOIN groups gr ON s.subject_id = gr.subject_id
JOIN grades g ON gr.group_id = g.group_id
GROUP BY s.subject_id, s.subject_name
HAVING AVG(g.grade_value) > 5.5;

-- 55

SELECT 
	s.subject_name,
	COUNT(DISTINCT ge.student_id) AS total_students
FROM subjects s
JOIN groups gr ON s.subject_id = gr.subject_id
JOIN group_enrollments ge ON gr.group_id = ge.group_id
WHERE gr.academic_year = 2024
GROUP BY s.subject_id, s.subject_name
ORDER BY total_students DESC, s.subject_name ASC
LIMIT 3;

-- 56

SELECT 
	st.first_name,
	st.last_name,
	COUNT(*) AS total_honors
FROM v_students st
JOIN grades g ON st.student_id = g.student_id
WHERE g.with_honors = 1
GROUP BY st.student_id, st.first_name, st.last_name
HAVING COUNT(*) > 1;

-- 57

SELECT 
	d.degree_name,
	COUNT(DISTINCT ge.student_id) AS total_students
FROM degrees d
JOIN subjects s ON d.degree_id = s.degree_id
JOIN groups gr ON s.subject_id = gr.subject_id
JOIN group_enrollments ge ON gr.group_id = ge.group_id
WHERE gr.academic_year = 2024
GROUP BY d.degree_id, d.degree_name
ORDER BY COUNT(DISTINCT ge.student_id) DESC;

-- 58

SELECT
	st.first_name,
	st.last_name,
	MAX(g.grade_value) AS max_grade
FROM v_students st
JOIN grades g ON st.student_id = g.student_id
GROUP BY st.student_id, st.first_name, st.last_name
ORDER BY MAX(g.grade_value) DESC;

-- 59

SELECT
	pr.first_name,
	pr.last_name,
	COUNT(DISTINCT tl.group_id) AS total_groups
FROM v_professors pr
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
GROUP BY pr.professor_id, pr.first_name, pr.last_name
HAVING COUNT(DISTINCT tl.group_id) > 1;

-- 60

SELECT DISTINCT s.subject_name, d.degree_name
FROM subjects s
JOIN degrees d ON s.degree_id = d.degree_id
WHERE d.degree_id IN (
	SELECT degree_id
	FROM subjects
	GROUP BY degree_id
	HAVING COUNT(*) > 15
);