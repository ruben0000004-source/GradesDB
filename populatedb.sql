
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM people;
DELETE FROM professors;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO professors (professor_id, category) VALUES
    (1, 'Catedrático'),
    (2, 'Titular'),
    (3, 'AyudanteDoctor'),
    (4, 'Titular'),
    (5, 'Ayudante');
