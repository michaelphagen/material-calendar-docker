/*
 * This is a template file for starting a new SQL database.
 * Replace all strings with curly braces with your own values.
 */
DROP DATABASE IF EXISTS booking;
CREATE DATABASE booking;
USE booking;
SOURCE material_calendar.sql;
-- This is the SQL file that contains the schema
/* Inserting minimal needed data for app to startup. */
INSERT INTO user
SET user_id = 'mph354',
    first_name = 'michael',
    last_name = 'hagen',
    email = 'mph354@nyu.edu';
INSERT INTO role (title)
VALUES ('admin'),
    ('user');
INSERT INTO user_role (user_id, role_id)
VALUES (1, 1);
INSERT INTO semester
SET title = 'Summer 2021',
    start = '2021-05-01',
end = '2012-10-30';
INSERT INTO active_semester
SET semester_id = 1;
INSERT INTO project
SET title = "Walk-in",
    group_hours = 999,
    open = 1,
    book_start = '2000-01-01',
    start = '2000-01-01',
end = '9999-12-31',
group_size = 1;
INSERT INTO project_group
SET name = 'Michael Hagen',
    project_id = 1;
INSERT INTO student_group
SET student_id = 1,
    group_id = 1;