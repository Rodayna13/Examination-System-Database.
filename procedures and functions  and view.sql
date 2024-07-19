--Creating Stored Procedures
CREATE PROCEDURE AddCourse
    @CourseName NVARCHAR(255),
    @CourseDescription NVARCHAR(255),
    @MaxDegree INT,
    @MinDegree INT
AS
BEGIN
    INSERT INTO Course (CourseName, CourseDescription, MaxDegree, MinDegree)
    VALUES (@CourseName, @CourseDescription, @MaxDegree, @MinDegree);
END;

CREATE PROCEDURE AddQuestion
    @CourseID INT,
    @QuestionText NVARCHAR(255),
    @QuestionType NVARCHAR(50),
    @CorrectAnswer NVARCHAR(255),
    @BestAcceptedAnswer NVARCHAR(255)
AS
BEGIN
    INSERT INTO Question (CourseID, QuestionText, QuestionType, CorrectAnswer)
    VALUES (@CourseID, @QuestionText, @QuestionType, @CorrectAnswer);
END;

CREATE PROCEDURE AddStudent
    @IntakeID INT,
    @Result NVARCHAR(255),
    @StudentAmount DECIMAL(10, 2),
    @BranchID INT,
    @TrackID INT,
    @PersonRole NVARCHAR(50),
    @PersonPassword NVARCHAR(255),
    @PersonEmail NVARCHAR(255),
    @PersonAddress NVARCHAR(255),
    @PersonFirstName NVARCHAR(255),
    @PersonLastName NVARCHAR(255)
AS
BEGIN
    DECLARE @PersonID INT;

    -- Insert into Person table
    INSERT INTO Person (PersonRole, PersonPassword, PersonEmail, PersonAddress, PersonFirstName, PersonLastName)
    VALUES (@PersonRole, @PersonPassword, @PersonEmail, @PersonAddress, @PersonFirstName, @PersonLastName);

    -- Get the last inserted PersonID
    SET @PersonID = SCOPE_IDENTITY();

    -- Insert into Student table
    INSERT INTO Student (IntakeID, Result, StudentAmount, BranchID, TrackID)
    VALUES (@IntakeID, @Result, @StudentAmount, @BranchID, @TrackID);
END;

CREATE PROCEDURE AddExam
    @CourseID INT,
    @ExamType NVARCHAR(50),
    @IntakeID INT,
    @BranchID INT,
    @TrackID INT,
    @StartTime DATETIME,
    @EndTime DATETIME,
    @TotalTime INT,
    @AllowanceOptions NVARCHAR(255)
AS
BEGIN
    INSERT INTO Exam (CourseID, ExamType, IntakeID, BranchID, TrackID, StartTime, EndTime, TotalTime, AllowanceOptions)
    VALUES (@CourseID, @ExamType, @IntakeID, @BranchID, @TrackID, @StartTime, @EndTime, @TotalTime, @AllowanceOptions);
END;

--Function 
CREATE FUNCTION dbo.CalculateTotalDegree(@ExamID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalDegree INT;

    SELECT @TotalDegree = SUM([QuestionDegree])
    FROM Exam_Question
    WHERE ExamID = @ExamID;

    RETURN @TotalDegree;
END;

--Views
CREATE VIEW vw_CourseDetails
AS
SELECT Course.CourseID, Course.CourseName, Course.CourseDescription, Course.MaxDegree, Course.MinDegree,
       Instructor.PersonID AS InstructorID, Person.PersonFirstName, Person.PersonLastName
FROM Course
JOIN Instructor_Course ON Course.CourseID = Instructor_Course.CourseID
JOIN Instructor ON Instructor_Course.InstructorID = Instructor.InstructorID
JOIN Person ON Instructor.PersonID = Person.PersonID;

CREATE VIEW vw_ExamDetails
AS
SELECT Exam.ExamID, Exam.ExamType, Course.CourseName, Intake.IntakeYear, Branch.BranchName, Track.TrackName,
       Exam.StartTime, Exam.EndTime, Exam.TotalTime, Exam.AllowanceOptions
FROM Exam
JOIN Course ON Exam.CourseID = Course.CourseID
JOIN Intake ON Exam.IntakeID = Intake.IntakeID
JOIN Branch ON Exam.BranchID = Branch.BranchID
JOIN Track ON Exam.TrackID = Track.TrackID;

CREATE VIEW vw_StudentExamResults
AS
SELECT Student.StudentID, Person.PersonFirstName, Person.PersonLastName, Exam.ExamID, Exam.ExamType,
       Course.CourseName, Student_Exam.ExamDate, Student_Exam.StartTime, Student_Exam.EndTime,
       dbo.CalculateTotalDegree(Exam.ExamID) AS TotalDegree
FROM Student
JOIN Person ON Student.StudentID = Person.PersonID
JOIN Student_Exam ON Student.StudentID = Student_Exam.StudentID
JOIN Exam ON Student_Exam.ExamID = Exam.ExamID
JOIN Course ON Exam.CourseID = Course.CourseID;

