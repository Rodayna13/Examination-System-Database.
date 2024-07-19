------------------------------------ PROCEDURE ------------------------------------
---AddStudentToExam
CREATE PROCEDURE AddStudentToExam
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    -- Check if the student is already added to the exam
    IF EXISTS (SELECT 1 FROM Student_Exam WHERE StudentID = @StudentID AND ExamID = @ExamID)
    BEGIN
        PRINT 'Student is already added to this exam.'
        RETURN
    END

    -- Add student to the exam
    INSERT INTO Student_Exam (StudentID, ExamID)
    VALUES (@StudentID, @ExamID)
    
    PRINT 'Student added to the exam successfully.'
END
go
--- Correct Exam
CREATE PROCEDURE CorrectExam
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    DECLARE @TotalQuestions INT;
    DECLARE @CorrectAnswers INT;
    DECLARE @Score INT;

    -- Calculate total questions in the exam
    SELECT @TotalQuestions = COUNT(*)
    FROM Exam_Question
    WHERE ExamID = @ExamID;

    -- Calculate correct answers given by the student
    SELECT @CorrectAnswers = COUNT(*)
    FROM Exam_Question EQ
    JOIN Exam_Answers EA ON EQ.QuestionID = EA.QuestionID
    JOIN Student_Answers SA ON EQ.QuestionID = SA.QuestionID AND SA.Answer = EA.CorrectAnswer
    WHERE EQ.ExamID = @ExamID AND SA.StudentID = @StudentID;

    -- Calculate the score
    SET @Score = (@CorrectAnswers * 100) / @TotalQuestions;

    -- Update the student's score for the exam
    UPDATE Student_Exam
    SET Score = @Score
    WHERE StudentID = @StudentID AND ExamID = @ExamID;

    PRINT 'Exam corrected successfully. Student score updated.'
END
go
--- LinkExamToCourse
CREATE PROCEDURE LinkExamToCourse
    @CourseID INT,
    @ExamID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course_Exam WHERE CourseID = @CourseID AND ExamID = @ExamID)
    BEGIN
        PRINT 'Exam is already linked to this course.'
        RETURN
    END

    INSERT INTO Course_Exam (CourseID, ExamID)
    VALUES (@CourseID, @ExamID);

    PRINT 'Exam linked to course successfully.'
END
go
--- Add Answer to question
CREATE PROCEDURE AddAnswerToQuestion
    @QuestionID INT,
    @StudentID INT,
    @Answer NVARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Student_Answers WHERE QuestionID = @QuestionID AND StudentID = @StudentID)
    BEGIN
        PRINT 'Answer for this question by this student already exists.'
        RETURN
    END

    INSERT INTO Student_Answers (QuestionID, StudentID, Answer)
    VALUES (@QuestionID, @StudentID, @Answer);

    PRINT 'Answer added successfully.'
END
go
-- GradeStudentExam

CREATE PROCEDURE GradeStudentExam
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    DECLARE @TotalQuestions INT;
    DECLARE @CorrectAnswers INT;
    DECLARE @Score INT;

    -- Calculate total questions in the exam
    SELECT @TotalQuestions = COUNT(*)
    FROM Exam_Question
    WHERE ExamID = @ExamID;

    -- Calculate correct answers given by the student
    SELECT @CorrectAnswers = COUNT(*)
    FROM Exam_Question EQ
    JOIN Exam_Answers EA ON EQ.QuestionID = EA.QuestionID
    JOIN Student_Answers SA ON EQ.QuestionID = SA.QuestionID AND SA.Answer = EA.CorrectAnswer
    WHERE EQ.ExamID = @ExamID AND SA.StudentID = @StudentID;

    -- Calculate the score
    SET @Score = (@CorrectAnswers * 100) / @TotalQuestions;

    -- Update the student's score for the exam
    UPDATE Student_Exam
    SET Score = @Score
    WHERE StudentID = @StudentID AND ExamID = @ExamID;

    PRINT 'Student exam graded successfully. Score updated.'
END
go

------------------------------------ TRIGGER ------------------------------------
--TRIGGER Check exam Time
CREATE TRIGGER trg_CheckExamTime
ON Student_Exam_Start
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @StudentID INT;
    DECLARE @ExamID INT;
    DECLARE @CurrentTime DATETIME;
    DECLARE @StartTime DATETIME;
    DECLARE @EndTime DATETIME;
    DECLARE @StartTimeStr NVARCHAR(20);
    DECLARE @EndTimeStr NVARCHAR(20);


    SELECT @StudentID = inserted.StudentID, @ExamID = inserted.ExamID
    FROM inserted;

    SET @CurrentTime = GETDATE();

    SELECT @StartTime = StartTime, @EndTime = EndTime
    FROM Exam
    WHERE ExamID = @ExamID;

    SET @StartTimeStr = CONVERT(NVARCHAR(20), @StartTime, 120);
    SET @EndTimeStr = CONVERT(NVARCHAR(20), @EndTime, 120);

    IF @CurrentTime >= @StartTime AND @CurrentTime <= @EndTime
    BEGIN
        INSERT INTO Student_Exam_Start (StudentID, ExamID, StartTime)
        VALUES (@StudentID, @ExamID, @CurrentTime);

        PRINT 'Exam started successfully.'
    END
    ELSE
    BEGIN
        RAISERROR ('Cannot start the exam. The exam is only available between %s and %s.', 16, 1, @StartTimeStr, @EndTimeStr);
    END
END
go
 -- TRIGGER Prevent Deletion of Exams 
 CREATE TRIGGER trg_PreventExamDeletion
ON Exam
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Student_Exam SE JOIN deleted d ON SE.ExamID = d.ExamID)
    BEGIN
        RAISERROR ('Cannot delete the exam. There are students registered for this exam.', 16, 1);
        RETURN;
    END

    DELETE FROM Exam
    WHERE ExamID IN (SELECT ExamID FROM deleted);

    PRINT 'Exam deleted successfully.'
END
go

-- TRIGGER Prevent Deletion of Students 
CREATE TRIGGER trg_PreventStudentDeletion
ON Student
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Student_Exam SE JOIN deleted d ON SE.StudentID = d.StudentID)
    BEGIN
        RAISERROR ('Cannot delete the student. There are exam records for this student.', 16, 1);
        RETURN;
    END

    DELETE FROM Student
    WHERE StudentID IN (SELECT StudentID FROM deleted);

    PRINT 'Student deleted successfully.'
END
go

-- TRIGGER Ensure Exam Times Are Valid
CREATE TRIGGER trg_ValidateExamTimes
ON Exam
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    DECLARE @StartTime DATETIME;
    DECLARE @EndTime DATETIME;

    SELECT @StartTime = inserted.StartTime, @EndTime = inserted.EndTime
    FROM inserted;

    IF @StartTime >= @EndTime
    BEGIN
        RAISERROR ('End time must be after start time.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM inserted WHERE inserted.ExamID IS NULL)
    BEGIN
        INSERT INTO Exam (CourseID, ExamType, StartTime, EndTime, TotalTime, AllowanceOptions)
        SELECT CourseID, ExamType, StartTime, EndTime, TotalTime, AllowanceOptions
        FROM inserted;
    END
    ELSE
    BEGIN
       
        UPDATE Exam
        SET CourseID = inserted.CourseID,
            ExamType = inserted.ExamType,
            StartTime = inserted.StartTime,
            EndTime = inserted.EndTime,
            TotalTime = inserted.TotalTime,
            AllowanceOptions = inserted.AllowanceOptions
        FROM inserted
        WHERE Exam.ExamID = inserted.ExamID;
    END

    PRINT 'Exam times validated successfully.'
END
go

--TRIGGER Update Exam Score on Answer Submission
CREATE TRIGGER trg_UpdateExamScore
ON Student_Answers
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @StudentID INT;
    DECLARE @ExamID INT;
    DECLARE @TotalQuestions INT;
    DECLARE @CorrectAnswers INT;
    DECLARE @Score INT;

    SELECT @StudentID = inserted.StudentID, @ExamID = EQ.ExamID
    FROM inserted
    JOIN Exam_Question EQ ON inserted.QuestionID = EQ.QuestionID;

    -- Calculate total questions in the exam
    SELECT @TotalQuestions = COUNT(*)
    FROM Exam_Question
    WHERE ExamID = @ExamID;

    -- Calculate correct answers given by the student
    SELECT @CorrectAnswers = COUNT(*)
    FROM Exam_Question EQ
    JOIN Exam_Answers EA ON EQ.QuestionID = EA.QuestionID
    JOIN Student_Answers SA ON EQ.QuestionID = SA.QuestionID AND SA.Answer = EA.CorrectAnswer
    WHERE EQ.ExamID = @ExamID AND SA.StudentID = @StudentID;

    -- Calculate the score
    SET @Score = (@CorrectAnswers * 100) / @TotalQuestions;

    -- Update the student's score for the exam
    UPDATE Student_Exam
    SET Score = @Score
    WHERE StudentID = @StudentID AND ExamID = @ExamID;

    PRINT 'Student exam score updated successfully.'
END
go

------------------------------------ VIEW ------------------------------------

--A view showing which students are taking the exam
CREATE VIEW StudentsTakingExam AS
SELECT 
    S.StudentID,
    E.ExamID,
    E.CourseID,
    E.ExamType,
    E.StartTime,
    E.EndTime,
    E.TotalTime,
    E.AllowanceOptions
FROM 
    Student S
JOIN 

    Student_Exam SE ON S.StudentID = SE.StudentID
JOIN 
    Exam E ON SE.ExamID = E.ExamID
go
-- View: ExamsWithCourseDetails
CREATE VIEW ExamsWithCourseDetails AS
SELECT 
    E.ExamID,
    E.CourseID,
    C.CourseName, 
    E.ExamType,
    E.StartTime,
    E.EndTime,
    E.TotalTime,
    E.AllowanceOptions
FROM 
    Exam E
JOIN 
    Course C ON E.CourseID = C.CourseID
go

--View: StudentExamResults
CREATE VIEW StudentExamResults AS
SELECT 
    S.StudentID, 
    E.ExamID,
    E.ExamType,
    SE.Score
FROM 
    Student S
JOIN 
    Student_Exam SE ON S.StudentID = SE.StudentID
JOIN 
    Exam E ON SE.ExamID = E.ExamID
go

--View: CourseExamDetails
CREATE VIEW CourseExamDetails AS
SELECT 
    C.CourseID,
    C.CourseName, 
    E.ExamID,
    E.ExamType,
    E.StartTime,
    E.EndTime,
    E.TotalTime,
    E.AllowanceOptions
FROM 
    Course C
JOIN 
    Course_Exam CE ON C.CourseID = CE.CourseID
JOIN 
    Exam E ON CE.ExamID = E.ExamID
go
