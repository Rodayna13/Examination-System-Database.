---- Create users and roles
CREATE LOGIN AdminLogin WITH PASSWORD = 'AdminPassword123';
CREATE LOGIN TrainingManagerLogin WITH PASSWORD = 'ManagerPassword123';
CREATE LOGIN InstructorLogin WITH PASSWORD = 'InstructorPassword123';
CREATE LOGIN StudentLogin WITH PASSWORD = 'StudentPassword123';

CREATE USER AdminUser FOR LOGIN AdminLogin;
CREATE USER TrainingManagerUser FOR LOGIN TrainingManagerLogin;
CREATE USER InstructorUser FOR LOGIN InstructorLogin;
CREATE USER StudentUser FOR LOGIN StudentLogin;

CREATE ROLE AdminRole;
CREATE ROLE TrainingManagerRole;
CREATE ROLE InstructorRole;
CREATE ROLE StudentRole;

ALTER ROLE AdminRole ADD MEMBER AdminUser;
ALTER ROLE TrainingManagerRole ADD MEMBER TrainingManagerUser;
ALTER ROLE InstructorRole ADD MEMBER InstructorUser;
ALTER ROLE StudentRole ADD MEMBER StudentUser;

-- Grant permissions to roles
GRANT INSERT, UPDATE, DELETE, SELECT ON Course TO AdminRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Instructor TO AdminRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Branch TO AdminRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Track TO AdminRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Intake TO AdminRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Student TO AdminRole;

GRANT INSERT, UPDATE, DELETE, SELECT ON Course TO TrainingManagerRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Instructor TO TrainingManagerRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Branch TO TrainingManagerRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Track TO TrainingManagerRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Intake TO TrainingManagerRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Student TO TrainingManagerRole;

GRANT INSERT, UPDATE, DELETE, SELECT ON Question TO InstructorRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Exam TO InstructorRole;
GRANT INSERT, UPDATE, DELETE, SELECT ON Student_Exam TO InstructorRole;
GRANT SELECT ON Student TO InstructorRole;

GRANT SELECT ON Course TO StudentRole;
GRANT SELECT ON Question TO StudentRole;
GRANT INSERT, UPDATE, SELECT ON Student_Answer TO StudentRole;