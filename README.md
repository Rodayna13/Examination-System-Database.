# Examination-System-Database.
1. Introduction
•	Purpose: This document outlines the requirements for the Examination System Database. The system will manage students, instructors, courses, exams, questions, and results.
•	Scope: The database will be used by educational institutions to streamline examination processes, including scheduling, student enrollment, and result management.
2. Overall Description
•	Product Perspective: The system will be a standalone database application.
•	Product Functions:
o	Manage user roles and authentication.
o	Manage student and instructor records.
o	Manage courses and their association with departments.
o	Schedule and manage exams.
o	Record and manage exam questions and results.
3. System Requirements
3.1 Functional Requirements
•	User Management:
o	Users can register and log in.
o	Users have roles such as Student, Instructor, and Admin.
o	Each user has personal information including email, address, first name, last name, and full name.
•	Student Management:
o	Add, edit, and delete student records.
o	Each student is associated with an intake.
•	Instructor Management:
o	Add, edit, and delete instructor records.
o	Each instructor has a role and an enrollment year.
o	Instructors are associated with departments and courses.
•	Course Management:
o	Add, edit, and delete courses.
o	Courses have details such as name, duration, description, minimum and maximum degree.
o	Courses are associated with departments and instructors.
•	Exam Management:
o	Schedule exams with start and end times.
o	Manage exam details including degree and options.
o	Exams are associated with courses, students, and instructors.
•	Question Management:
o	Add, edit, and delete questions.
o	Questions are associated with exams and can have multiple types (e.g., multiple choice, descriptive).
•	Results Management:
o	Record and manage student results for each exam.
o	Results include corrective status, score, and date.
3.2 NonFunctional Requirements
•	Performance Requirements:
o	The system should support concurrent access by multiple users.
o	The database should handle large amounts of data efficiently.
•	Security Requirements:
o	User authentication should be secure.
o	Sensitive data should be encrypted.
o	Access controls should be in place to restrict data based on user roles.
•	Usability Requirements:
o	The system should have a userfriendly interface.
o	Users should be able to perform tasks with minimal training.
•	Reliability Requirements:
o	The system should have high availability.
o	Data integrity should be maintained at all times.
4-Technical Requirments:
•	Proucedures:
o	Add Course
o	Add Question
o	AddStudent
o	AddExam
o	Add Student to Exam
o	Correct Exam
o	Link Exam to Course
o	Add Answer to question
o	 Grade Student Exam
•	Functions: 
o	 CalculateTotalDegree 
o	make a function to calculate the correct intake as ITI  structure and made it add automatically by date
•	Trigger:
o	TRIGGER to ensure only the authorized instructor can update or delete questions 
o	TRIGGER Validate Exam
o	TRIGGER enforce degree limits
o	TRIGGER Check exam Time
o	  TRIGGER Prevent Deletion of Exams 
o	  TRIGGER Prevent Deletion of Students 
o	  TRIGGER Ensure Exam Times Are Valid
o	 TRIGGER Update Exam Score on Answer Submission
•	Veiw:
o	View: Course Details
o	View: Exam Details
o	 A view showing which students are taking the exam
o	  View: Exams With Course Details
o	 View: Student Exam Results
o	 View: Course Exam Details

5.  Database Accounts and Passwords
Admin Account:
 Login: AdminLogin
 Password: AdminPassword123

Training Manager Account:
 Login: TrainingManagerLogin
 Password: ManagerPassword123

Instructor Account:
 Login: InstructorLogin
 Password: InstructorPassword123

Student Account:
 Login: StudentLogin
 Password: StudentPassword12
