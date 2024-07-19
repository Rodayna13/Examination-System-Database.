
DECLARE @startYear INT = 1993;
DECLARE @currentYear INT = YEAR(GETDATE());
DECLARE @intakeYear INT = @startYear;

WHILE @intakeYear <= @currentYear
BEGIN
    DECLARE @intakeCount INT = CASE
                                   WHEN @intakeYear BETWEEN 1993 AND 1995 THEN 2
                                   ELSE 1
                               END;

    -- ÅÏÑÇÌ ÇáÜ intakes
    DECLARE @i INT = 1;
    WHILE @i <= @intakeCount
    BEGIN
        INSERT INTO Intake (IntakeYear, IntakeName) VALUES (@intakeYear, 'Temporary Name');
        SET @i = @i + 1;
    END

    SET @intakeYear = @intakeYear + 1;
END;

UPDATE Intake
SET IntakeName = 'Intake ' + CAST([IntakeID] AS NVARCHAR(10));

-- Insert Branch Data
INSERT INTO Branch (BranchName, BranchLocation) VALUES
('Smart Village', 'Smart Village building B148 - 28 Km by Cairo / Alexandria Desert road- 6 October'),
('New Capital', 'Building 4, Knowledge City at New Administrative Capital, Cairo, Egypt'),
('Cairo University', 'Alsokari street, beside faculty of CS & AI credit - Cairo University, Dokki, Giza, Egypt.'),
('Alexandria', '1 Mahmoud Saeed Street - Al Shuhada Square - Post Authority Building - 10th Floor'),
('Assiut', 'Assiut University – Information Network Building - Fourth floor – in front of Faculty of Dentistry'),
('Aswan', 'Egypt Creativity Digital Center in Aswan,Aswan Abu Simbel Road - inside the campus of Aswan University in Sahara'),
('Beni Suef', ' Creativa Beni suif - Smart Village - New Beni Suif, Beni Suef, Egypt'),
('Fayoum', 'Al-Mashtal District, Fayoum University, Faculty of Education Campus - Fayoum'),
('Ismailia', 'Ismailia-Suez Canal University, Entrance to the main gate, Information Technology Institute (ITI)'),
('Mansoura', '60 El-Gomhourya, st. Mit Khamis WA Kafr Al Mougi, El Mansoura 1, Dakahlia Governorate'),
('Menofia', 'Shebin El Kom . University stadium street, behind the military hospital, the institute has a private entrance next to the public service center of Menoufia University'),
('Minya', 'Minia University next to the ring road gate'),
('Qena', 'South Valley University - Creativa Qena Building, Qena'),
('Sohag', 'Sohag University - Creativa Sohag Building, New Sohag');

-- Insert Department and Track Data

-- Industrial Systems Department
INSERT INTO Department (DepCode, DepartmentName) VALUES ('IS', 'Industrial Systems');

INSERT INTO Track (TrackName) VALUES 
('Embedded Systems'),
('Wireless Communications'),
('Digital IC Design'),
('Industrial Automation');

-- Content Developments Department
INSERT INTO Department (DepCode, DepartmentName) VALUES ('CD', 'Content Developments');

INSERT INTO Track (TrackName) VALUES 
('3D Art'),
('Game Programming'),
('Game Art'),
('VFX Compositing'),
('2D Animation and Motion Graphics');

-- Infastructure Network And Security Services Department
INSERT INTO Department (DepCode, DepartmentName) VALUES ('INSS', 'Infastructure Network And Security Services');

INSERT INTO Track (TrackName) VALUES 
('Systems Administration'),
('Cyber Security'),
('Cloud Architecture');

-- Information Systems Department
INSERT INTO Department (DepCode, DepartmentName) VALUES ('IS', 'Information Systems');

INSERT INTO Track (TrackName) VALUES 
('Geoinformatics'),
('ERP Consulting'),
('Architecture, Engineering and Construction Informatics'),
('Data Management'),
('Data Science');

-- Software Engineering And Development Department
INSERT INTO Department (DepCode, DepartmentName) VALUES ('SED', 'Software Engineering And Development');

INSERT INTO Track (TrackName) VALUES 
('Computer Aided Design'),
('Open Source Applications Development'),
('Enterprise & Web Apps Development (Java)'),
('Mobile Applications Development (Native)'),
('Professional Web Development & BI'),
('Web & Person Interface Development'),
('Telecom Applications Development'),
('Internet of Things Applications Development'),
('Data Management');

-- Cognitive Computing and Artificial Intelligence Department
INSERT INTO Department (DepCode, DepartmentName) VALUES ('CCAI', 'Cognitive Computing and Artificial Intelligence');

INSERT INTO Track (TrackName) VALUES 
('AI and Machine Learning');

-- QA Engineering & Validation Department
INSERT INTO Department (DepCode, DepartmentName) VALUES ('QAEV', 'QA Engineering & Validation');

INSERT INTO Track (TrackName) VALUES 
('Software Testing & Quality Assurance');

-- Industrial Systems Department
INSERT INTO Department_Track (DepartmentID, TrackID)
SELECT DepartmentID, TrackID FROM Department, Track
WHERE DepCode = 'IS' AND TrackName IN ('Embedded Systems', 'Wireless Communications', 'Digital IC Design', 'Industrial Automation');

-- Content Developments Department
INSERT INTO Department_Track (DepartmentID, TrackID)
SELECT DepartmentID, TrackID FROM Department, Track
WHERE DepCode = 'CD' AND TrackName IN ('3D Art', 'Game Programming', 'Game Art', 'VFX Compositing', '2D Animation and Motion Graphics');

-- Infastructure Network And Security Services Department
INSERT INTO Department_Track (DepartmentID, TrackID)
SELECT DepartmentID, TrackID FROM Department, Track
WHERE DepCode = 'INSS' AND TrackName IN ('Systems Administration', 'Cyber Security', 'Cloud Architecture');

-- Information Systems Department
INSERT INTO Department_Track (DepartmentID, TrackID)
SELECT DepartmentID, TrackID FROM Department, Track
WHERE DepCode = 'IS' AND TrackName IN ('Geoinformatics', 'ERP Consulting', 'Architecture, Engineering and Construction Informatics', 'Data Management', 'Data Science');

-- Software Engineering And Development Department
INSERT INTO Department_Track (DepartmentID, TrackID)
SELECT DepartmentID, TrackID FROM Department, Track
WHERE DepCode = 'SED' AND TrackName IN ('Computer Aided Design', 'Open Source Applications Development', 'Enterprise & Web Apps Development (Java)', 'Mobile Applications Development (Native)', 'Professional Web Development & BI', 'Web & Person Interface Development', 'Telecom Applications Development', 'Internet of Things Applications Development', 'Data Management');

-- Cognitive Computing and Artificial Intelligence Department
INSERT INTO Department_Track (DepartmentID, TrackID)
SELECT DepartmentID, TrackID FROM Department, Track
WHERE DepCode = 'CCAI' AND TrackName IN ('AI and Machine Learning');

-- QA Engineering & Validation Department
INSERT INTO Department_Track (DepartmentID, TrackID)
SELECT DepartmentID, TrackID FROM Department, Track
WHERE DepCode = 'QAEV' AND TrackName IN ('Software Testing & Quality Assurance');

-- Insert Instructor Data
INSERT INTO Person (PersonRole, PersonPassword, PersonEmail, PersonAddress, PersonFirstName, PersonLastName) VALUES
('Instructor', 'password123', 'mohamed.ali@gmail.com', '123 Main St', 'Mohamed', 'Ali'),
('Instructor', 'password123', 'ahmed.hassan@gmail.com', '456 Elm St', 'Ahmed', 'Hassan'),
('Instructor', 'password123', 'fatma.elsayed@gmail.com', '789 Oak St', 'Fatma', 'ElSayed'),
('Instructor', 'password123', 'sara.mostafa@gmail.com', '101 Pine St', 'Sara', 'Mostafa');

INSERT INTO Instructor (PersonID, Role, EnrollYear) 
SELECT PersonID, PersonRole, 2023 FROM Person 
WHERE PersonEmail IN ('mohamed.ali@gmail.com', 'ahmed.hassan@gmail.com', 'fatma.elsayed@gmail.com', 'sara.mostafa@gmail.com');

-- Insert Course Data
INSERT INTO Course (CourseName, CourseDescription, MinDegree, MaxDegree, Duration)
VALUES ('Embedded Systems Basics', 'Introduction to Embedded Systems', 60, 100, 120),
       ('Clintserver', 'Advanced topics in HTML&CSS', 60, 100, 120),
       ('SQL', 'Basics of Sql', 50, 100, 90),
       ('Advanced 3D Art', 'Advanced techniques in 3D Art', 50, 100, 90);


	   -- Insert Question Data
INSERT INTO [dbo].[Question](CourseID, QuestionText, QuestionType, TextAnswer, CorrectAnswer)
VALUES ((SELECT CourseID FROM Course WHERE CourseName = 'Embedded Systems Basics'), 'What is an embedded system?', 'Text', 'A computer system with a dedicated function', 'A computer system with a dedicated function'),
       ((SELECT CourseID FROM Course WHERE CourseName = 'SQL'), 'What is DataBase', 'Text', 'Collection of relaed dara', 'Collection of related data');
	
-- Insert into Round Table
INSERT INTO Round (RoundName) VALUES
('R0'),
('R1'),
('R2'),
('R3');
-- Insert into Type Table
INSERT INTO Type (TypeName) VALUES
('Professional Training Program'),
('Intensive Code Camp - (ICC)');

-- Insert into Person Table
INSERT INTO Person (PersonRole, PersonPassword, PersonEmail, PersonAddress, PersonFirstName, PersonLastName) VALUES
('Teacher', 'password123', 'ahmed.saad@iti.com', '123 Street, Cairo', 'Ahmed', 'Saad'),
('Teacher', 'password123', 'mohamed.hassan@iti.com', '456 Avenue, Alexandria', 'Mohamed', 'Hassan'),
('Teacher', 'password123', 'sara.ali@iti.com', '789 Boulevard, Assiut', 'Sara', 'Ali'),
('Student', 'password123', 'student1@iti.com', '321 Street, Cairo', 'Mona', 'Ahmed'),
('Student', 'password123', 'student2@iti.com', '654 Avenue, Alexandria', 'Youssef', 'Ali');

-- Insert into Student Table
INSERT INTO Student (IntakeID, Result, StudentAmount, BranchID, TrackID) VALUES
(35, 'Passed', 1000.00, 1, 1),
(34, 'Passed', 1000.00, 2, 2);
-- Insert into Track_Student Table
INSERT INTO Track_Student (TrackID, StudentID) VALUES
(1, 1),
(2, 2);

-- Insert into Student_Instructor Table
INSERT INTO Student_Instructor (StudentID, InstructorID) VALUES
(1, 1),
(2, 2);

-- Insert into Instructor_Course Table
INSERT INTO Instructor_Course (InstructorID, CourseID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 3),
(3, 2);

INSERT INTO Course_Track (CourseID, TrackID) VALUES
(1, 1),
(2, 5),
(3, 2),
(4, 3);

-- Insert into Exam Table
INSERT INTO Exam (CourseID, ExamType, IntakeID, BranchID, TrackID, StartTime, EndTime, TotalTime, AllowanceOptions) VALUES
(1, 'MCQ', 1, 1, 1, '2024-07-01 09:00:00', '2024-07-01 11:00:00', 120, 'Open Book'),
(2, 'T/F', 2, 2, 2, '2024-07-02 10:00:00', '2024-07-02 12:00:00', 120, 'Calculator Allowed'),
(3, 'TEXT', 1, 3, 3, '2024-07-03 14:00:00', '2024-07-03 16:00:00', 120, NULL),
(4, 'MCQ', 2, 4, 4, '2024-07-04 09:00:00', '2024-07-04 11:00:00', 120, 'Notes Allowed'),
(2, 'MCQ', 1, 5, 5, '2024-07-05 13:00:00', '2024-07-05 15:00:00', 120, NULL),
(1, 'Text', 2, 6, 6, '2024-07-06 10:00:00', '2024-07-06 12:00:00', 120, 'Open Book');
-- Insert into Course_Exam Table
INSERT INTO Course_Exam (CourseID, ExamID) VALUES
(1, 3),
(2, 4),
(3, 5),
(4, 6);

-- Insert into Student_Exam Table
INSERT INTO Student_Exam (StudentID, ExamID, ExamDate, StartTime, EndTime) VALUES
(1, 3, '2024-07-15', '2024-07-15 09:00:00', '2024-07-15 11:00:00'),
(2, 4, '2024-07-16', '2024-07-16 10:00:00', '2024-07-16 12:00:00');


-- Insert into Intake_Track Table
INSERT INTO Intake_Track (IntakeID, TrackID) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert into Intake_Branch Table
INSERT INTO Intake_Branch (IntakeID, BranchID) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert into Intake_Type Table
INSERT INTO Intake_Type (IntakeID, TypeID) VALUES
(1, 1),
(2, 2);


-- Insert into Branch_Track Table
INSERT INTO Branch_Track (BranchID, TrackID) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert into Department_Student Table
INSERT INTO Department_Student (DepartmentID, StudentID) VALUES
(1, 1),
(2, 2);

-- Insert into Exam_Question Table
INSERT INTO Exam_Question (ExamID, QuestionID,QuestionDegree) VALUES
(3, 1,10),
(5, 2,20),
(4, 1,15);


-- Insert into Round_Department Table
INSERT INTO Round_Department (RoundID, DepartmentID) VALUES
(1, 1),
(2, 2);


-- Insert into Student_Answer Table
INSERT INTO Student_Answer (StudentID, QuestionID,Answer,IsCorrect) VALUES
(1, 1, 'A combination of hardware and software designed for a specific function.',0),
(2, 2, 'Interrupts are crucial for handling real-time tasks efficiently.',1);


-- Insert into Type_Round Table
INSERT INTO Type_Round (TypeID, RoundID) VALUES
(1, 1),
(2, 2);




