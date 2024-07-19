-- constraints
-- Add constraints for Course table
ALTER TABLE Course
ADD CONSTRAINT chk_course_degrees CHECK (MaxDegree > MinDegree);

-- Add constraints for Question table
ALTER TABLE Question
ADD CONSTRAINT chk_question_type CHECK (QuestionType IN ('Multiple Choice', 'True/False', 'Text'));

-- Add constraints for Exam table
ALTER TABLE Exam
ADD CONSTRAINT chk_exam_time CHECK (EndTime > StartTime);

-- Add constraints for Student_Exam table
ALTER TABLE Student_Exam
ADD CONSTRAINT chk_student_exam_time CHECK (EndTime > StartTime);

-- Add constraints for Student_Answer table
ALTER TABLE Student_Answer
ADD CONSTRAINT chk_answer_not_empty CHECK (LEN(Answer) > 0);


--Triggers

-- Create a trigger to ensure only the authorized instructor can update or delete questions

CREATE TRIGGER trg_authorized_question_edit
ON Question
AFTER UPDATE, DELETE
AS
BEGIN
    DECLARE @InstructorID INT;
    DECLARE @CourseID INT;
    DECLARE @PersonID INT;

    -- Assume the current user ID is stored in a session or passed as a parameter
    -- For the sake of this example, we'll hardcode an instructor ID
    SET @PersonID = 1; -- Example: Ahmed Saad's PersonID

    -- Get the InstructorID for the current user
    SELECT @InstructorID = InstructorID
    FROM Instructor
    WHERE PersonID = @PersonID;

    -- Get the CourseID from the deleted or updated rows
    SELECT @CourseID = CourseID
    FROM DELETED;

    -- Check if the instructor is authorized to edit the question
    IF NOT EXISTS (
        SELECT 1
        FROM Instructor_Course
        WHERE InstructorID = @InstructorID AND CourseID = @CourseID
    )
    BEGIN
        RAISERROR ('You are not authorized to edit or delete questions for this course',16, 1);
        ROLLBACK TRANSACTION;
    END
END;
---trg_Validate_Exam
CREATE TRIGGER trg_Validate_Exam
ON dbo.Exam
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE StartTime < GETDATE())
    BEGIN
        RAISERROR ('Exam start time cannot be in the past.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
--enforce_degree_limits 
CREATE TRIGGER enforce_degree_limits 
ON dbo.Course
AFTER INSERT, UPDATE
AS
BEGIN
  DECLARE @MinDegree int, @MaxDegree int;
  
  SELECT @MinDegree = MinDegree, @MaxDegree = MaxDegree
  FROM INSERTED;

  IF (@MinDegree IS NULL OR @MaxDegree IS NULL OR @MinDegree > @MaxDegree)
  BEGIN
    RAISERROR ('Minimum degree must be less than maximum degree.', 16, 1);
    ROLLBACK TRANSACTION;
  END;
END;
-- Create roles on users' access.
CREATE ROLE TrainingManager;
CREATE ROLE Instructor;
CREATE ROLE Student;

-- Grant permissions to Training Manager
GRANT INSERT, UPDATE, DELETE, SELECT ON Course TO TrainingManager;
GRANT INSERT, UPDATE, DELETE, SELECT ON Instructor TO TrainingManager;
GRANT INSERT, UPDATE, DELETE, SELECT ON Branch TO TrainingManager;
GRANT INSERT, UPDATE, DELETE, SELECT ON Track TO TrainingManager;
GRANT INSERT, UPDATE, DELETE, SELECT ON Intake TO TrainingManager;
GRANT INSERT, UPDATE, DELETE, SELECT ON Student TO TrainingManager;

-- Grant permissions to Instructor
GRANT INSERT, UPDATE, DELETE, SELECT ON Question TO Instructor;
GRANT INSERT, UPDATE, DELETE, SELECT ON Exam TO Instructor;
GRANT INSERT, UPDATE, DELETE, SELECT ON Student_Exam TO Instructor;
GRANT SELECT ON Student TO Instructor;

-- Grant permissions to Student
GRANT SELECT ON Course TO Student;
GRANT SELECT ON Question TO Student;
GRANT INSERT, UPDATE, SELECT ON Student_Answer TO Student;


