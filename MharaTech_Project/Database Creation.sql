CREATE DATABASE MaharaProject;
GO
USE MaharaProject;
GO

-- 1. Department
CREATE TABLE Department (
	DepartmentId INT IDENTITY(1, 1) PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Location VARCHAR(20) DEFAULT('Cairo') CHECK(Location IN ('Alex', 'Cairo', 'Mansora', 'Zagaizg')),
	ManagerId INT,
);
GO

-- 2. Student
CREATE TABLE Student (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
	DepartmentId INT NOT NULL,
    Age AS FLOOR(DATEDIFF(DAY, DateOfBirth, GETDATE()) / 365.2425)
);
GO

-- 3. Instructor
CREATE TABLE Instructor (
	InstructorId INT IDENTITY(1, 1) PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	Salary MONEY Default 7000,
	DepartmentId INT NOT NULL,
);
GO

-- 4. Course
CREATE TABLE Course (
	CourseId INT IDENTITY(1, 1) PRIMARY KEY,
	Title VARCHAR(30) NOT NULL,
	Hours Decimal(10, 2) Default 30 CHECK(Hours BETWEEN 20 AND 100),
	DepartmentId INT NOT NULL,
	InstructorId INT
)
GO

-- 5. Questions
CREATE TABLE Questions (
	QuesionId INT IDENTITY(1, 1) PRIMARY KEY,
	Title VARCHAR(MAX) NOT NULL,
	Grade Decimal(10, 2) NOT NULL CHECK(Grade <= 100),
	Type VARCHAR(30) DEFAULT 'MCQ' NOT NULL,
	CourseId INT
);
GO

-- 6. Choices
CREATE TABLE Choices (
	QuesionId INT,
	Choices VARCHAR(MAX),

	CONSTRAINT FK_Questions_Choices
	FOREIGN KEY(QuesionId) 
	REFERENCES Questions(QuesionId)
);
GO

-- 7. Student_Course
CREATE TABLE Student_Course (
	StudentId int NOT NULL,
	CourseId int NOT NULL,
	PRIMARY KEY (StudentId, CourseId),

	CONSTRAINT FK_Student_Student_Course
	FOREIGN KEY(StudentId) 
	REFERENCES Student(StudentId),

	CONSTRAINT FK_Course_Student_Course
	FOREIGN KEY(CourseId) 
	REFERENCES Course(CourseId)
);
GO

-- 8. Add foreign key constraints
ALTER TABLE Student
ADD CONSTRAINT FK_Department_Student
FOREIGN KEY (DepartmentId)
REFERENCES Department(DepartmentId)
GO

ALTER TABLE Course
ADD CONSTRAINT FK_Department_Course
FOREIGN KEY (DepartmentId)
REFERENCES Department(DepartmentId)
GO

ALTER TABLE Instructor
ADD CONSTRAINT FK_Department_Instructor
FOREIGN KEY (DepartmentId)
REFERENCES Department(DepartmentId)
GO

ALTER TABLE Course
ADD CONSTRAINT FK_Instructor_Course
FOREIGN KEY (InstructorId)
REFERENCES Instructor(InstructorId);
GO

ALTER TABLE Questions
ADD CONSTRAINT FK_Course_Questions
FOREIGN KEY (CourseId)
REFERENCES Course(CourseId)
GO

ALTER TABLE Department
ADD CONSTRAINT FK_Instructor_Department
FOREIGN KEY (ManagerId)
REFERENCES Instructor(InstructorId)
GO

-- 10. Department Data
INSERT INTO Department (Name, Location) VALUES
('Computer Science', 'Zagaizg'),
('Electrical Engineering', 'Cairo'),
('Mechanical Engineering', 'Alex'),
('Civil Engineering', 'Cairo'),
('Business Administration', 'Alex'),
('Accounting', 'Mansora'),
('Marketing', 'Cairo'),
('Pharmacy', 'Zagaizg'),
('Nursing', 'Cairo'),
('Biotechnology', 'Mansora'),
('Information Systems', 'Alex'),
('Physics', 'Zagaizg'),
('Mathematics', 'Mansora'),
('Architecture', 'Cairo'),
('Psychology', 'Alex');
Go

-- 12. Insert Instructor Data
INSERT INTO Instructor (Name, Salary, DepartmentId) VALUES
('Dr. Ahmed Samir', 12000, 1),
('Prof. Mona Hassan', 15000, 2),
('Dr. Karim Adel', 11000, 3),
('Prof. Hana Mahmoud', 14000, 4),
('Dr. Tamer Nabil', 13000, 5),
('Prof. Rania Fouad', 16000, 6),
('Dr. Waleed Ashraf', 12500, 7),
('Prof. Salma Hamdi', 14500, 8),
('Dr. Adel Samy', 11500, 9),
('Prof. Farida Gamal', 15500, 10),
('Dr. Sherif Magdy', 13500, 11),
('Prof. Hoda Essam', 16500, 12),
('Dr. Nader Kamal', 12500, 13),
('Prof. Samar Tamer', 14500, 14),
('Dr. Bassem Hany', 11800, 15),
('Dr. Youssef Ibrahim', 12200, 1),
('Prof. Aisha Abdelrahman', 15200, 2),
('Dr. Khaled Samir', 11200, 3),
('Prof. Layla Ahmed', 14200, 4),
('Dr. Mohamed Mostafa', 13200, 5),
('Prof. Nour Salah', 16200, 6),
('Dr. Amr Tarek', 12700, 7),
('Prof. Hana Karim', 14700, 8),
('Dr. Tamer Nabil', 11700, 9),
('Prof. Dalia Wael', 15700, 10),
('Dr. Waleed Ashraf', 13700, 11),
('Prof. Salma Hamdi', 16700, 12),
('Dr. Hassan Reda', 12300, 13),
('Prof. Rania Fouad', 14300, 14),
('Dr. Karim Adel', 11900, 15);
GO

-- 12. Course Data
INSERT INTO Course (Title, Hours, DepartmentId, InstructorId) VALUES
('Data Structures', 57.58, 8, 8),
('Algorithms', 22.16, 7, 2),
('Databases', 39.39, 12, 4),
('Operating Systems', 99.23, 13, 5),
('Networks', 77.65, 6, 7),
('Machine Learning', 32.15, 11, 9),
('Accounting Principles', 54.88, 6, 1),
('Microeconomics', 84.23, 2, 3),
('Marketing Management', 61.12, 9, 6),
('Business Ethics', 91.04, 4, 2),
('Anatomy', 44.92, 10, 3),
('Organic Chemistry', 68.56, 5, 5),
('Calculus I', 88.89, 3, 10),
('Physics I', 34.50, 1, 4),
('Linear Algebra', 71.77, 14, 6),
('Project Management', 79.61, 15, 7),
('Engineering Mechanics', 48.34, 8, 3),
('Statics', 55.20, 13, 1),
('Architectural Design', 97.31, 11, 8),
('Clinical Psychology', 28.17, 12, 10);
Go

-- 13. Insert Student Data
INSERT INTO Student (Name, DateOfBirth, DepartmentId) VALUES
('Ahmed Mohamed', '1995-03-15', 1),
('Mariam Ali', '1998-07-22', 1),
('Omar Hassan', '1997-11-05', 2),
('Fatima Mahmoud', '1996-09-18', 2),
('Youssef Ibrahim', '1999-02-28', 3),
('Aisha Abdelrahman', '1995-12-10', 3),
('Khaled Samir', '1998-05-17', 4),
('Layla Ahmed', '1997-08-23', 4),
('Mohamed Mostafa', '1996-04-30', 5),
('Nour Salah', '1999-01-14', 5),
('Amr Tarek', '1995-10-08', 6),
('Hana Karim', '1998-06-19', 6),
('Tamer Nabil', '1997-03-25', 7),
('Dalia Wael', '1996-11-11', 7),
('Waleed Ashraf', '1999-09-03', 8),
('Salma Hamdi', '1995-07-27', 8),
('Hassan Reda', '1998-02-09', 9),
('Rania Fouad', '1997-05-21', 9),
('Karim Adel', '1996-08-16', 10),
('Yasmin Hisham', '1999-04-07', 10),
('Adel Samy', '1995-01-29', 11),
('Farida Gamal', '1998-10-12', 11),
('Sherif Magdy', '1997-07-24', 12),
('Mona Nasr', '1996-03-08', 12),
('Nader Kamal', '1999-11-20', 13),
('Heba Essam', '1995-09-02', 13),
('Fadi Rami', '1998-06-15', 14),
('Samar Tamer', '1997-02-28', 14),
('Bassem Hany', '1996-10-11', 15),
('Reem Ayman', '1999-08-04', 15),
('Ziad Osama', '1995-05-17', 1),
('Nada Sherif', '1998-12-30', 1),
('Hany Sameh', '1997-09-22', 2),
('Dina Amir', '1996-07-14', 2),
('Tarek Wagdy', '1999-04-26', 3),
('Rasha Medhat', '1995-02-07', 3),
('Amir Nasser', '1998-11-19', 4),
('Sara Fathi', '1997-08-01', 4),
('Wael Lotfy', '1996-05-13', 5),
('Amina Sami', '1999-03-25', 5),
('Samy Raafat', '1995-12-06', 6),
('Ghada Ehab', '1998-10-18', 6),
('Ehab Farouk', '1997-07-31', 7),
('Hanan Mamdouh', '1996-04-12', 7),
('Mamdouh Zakaria', '1999-01-24', 8),
('Inas Sobhy', '1995-11-05', 8),
('Zakaria Galal', '1998-08-17', 9),
('Faten Adel', '1997-06-29', 9),
('Galal Shawky', '1996-03-10', 10),
('Hind Hamza', '1999-12-22', 10),
('Shawky Maher', '1995-10-03', 11),
('Asmaa Badr', '1998-07-16', 11),
('Maher Adel', '1997-04-28', 12),
('Hoda Taha', '1996-02-09', 12),
('Adel Samir', '1999-11-21', 13),
('Iman Sabry', '1995-09-02', 13),
('Sabry Nagy', '1998-06-15', 14),
('Nermeen Raouf', '1997-03-27', 14),
('Nagy Kamel', '1996-01-08', 15),
('Manal Samy', '1999-10-20', 15),
('Kamel Fawzy', '1995-08-01', 1),
('Randa Hossam', '1998-05-14', 1),
('Fawzy Adel', '1997-02-25', 2),
('Heba Nader', '1996-12-07', 2),
('Adel Mounir', '1999-09-19', 3),
('Mai Magdy', '1995-07-31', 3),
('Mounir Samy', '1998-04-12', 4),
('Noha Ashraf', '1997-01-24', 4),
('Samy Hatem', '1996-10-06', 5),
('Dalia Adel', '1999-08-18', 5),
('Hatem Gamal', '1995-06-29', 6),
('Yara Tamer', '1998-03-11', 6),
('Gamal Samir', '1997-12-23', 7),
('Shaimaa Wagdy', '1996-09-04', 7),
('Samir Nabil', '1999-06-16', 8),
('Marwa Adel', '1995-04-28', 8),
('Nabil Hany', '1998-02-09', 9),
('Hagar Samy', '1997-11-21', 9),
('Hany Adel', '1996-08-03', 10),
('Nermeen Tarek', '1999-05-15', 10),
('Adel Karim', '1995-03-27', 11),
('Sahar Hossam', '1998-12-09', 11),
('Karim Samy', '1997-09-21', 12),
('Rania Adel', '1996-07-03', 12),
('Samy Hisham', '1999-04-15', 13),
('Mona Samir', '1995-02-25', 13),
('Hisham Adel', '1998-11-07', 14),
('Nada Karim', '1997-08-20', 14),
('Adel Tamer', '1996-05-02', 15),
('Hala Samy', '1999-02-12', 15),
('Tamer Adel', '1995-12-25', 1),
('Amal Hany', '1998-09-06', 1),
('Adel Samir', '1997-06-19', 2),
('Samia Karim', '1996-03-31', 2),
('Samir Adel', '1999-01-12', 3),
('Fadia Hany', '1995-10-24', 3),
('Adel Karim', '1998-08-05', 4),
('Hanan Samy', '1997-05-18', 4),
('Karim Adel', '1996-02-28', 5),
('Heba Samir', '1999-12-10', 5);
GO

-- 14. Updating department managers
UPDATE Department SET ManagerId = 1 WHERE DepartmentId = 1;
UPDATE Department SET ManagerId = 2 WHERE DepartmentId = 2;
UPDATE Department SET ManagerId = 3 WHERE DepartmentId = 3;
UPDATE Department SET ManagerId = 4 WHERE DepartmentId = 4;
UPDATE Department SET ManagerId = 5 WHERE DepartmentId = 5;
UPDATE Department SET ManagerId = 6 WHERE DepartmentId = 6;
UPDATE Department SET ManagerId = 7 WHERE DepartmentId = 7;
UPDATE Department SET ManagerId = 8 WHERE DepartmentId = 8;
UPDATE Department SET ManagerId = 9 WHERE DepartmentId = 9;
UPDATE Department SET ManagerId = 10 WHERE DepartmentId = 10;
UPDATE Department SET ManagerId = 11 WHERE DepartmentId = 11;
UPDATE Department SET ManagerId = 12 WHERE DepartmentId = 12;
UPDATE Department SET ManagerId = 13 WHERE DepartmentId = 13;
UPDATE Department SET ManagerId = 14 WHERE DepartmentId = 14;
UPDATE Department SET ManagerId = 15 WHERE DepartmentId = 15;
GO

-- 15. Insert Student_Course Data
INSERT INTO Student_Course (StudentId, CourseId) VALUES
-- Student 1 enrolled in 4 courses
(1, 1), (1, 5), (1, 10), (1, 15),
-- Student 2 enrolled in 3 courses
(2, 2), (2, 7), (2, 12),
-- Student 3 enrolled in 5 courses
(3, 3), (3, 8), (3, 13), (3, 18), (3, 20),
-- Student 4 enrolled in 4 courses
(4, 4), (4, 9), (4, 14), (4, 19),
-- Student 5 enrolled in 3 courses
(5, 5), (5, 10), (5, 15),
-- Student 6 enrolled in 5 courses
(6, 6), (6, 11), (6, 16), (6, 1), (6, 2),
-- Student 7 enrolled in 4 courses
(7, 7), (7, 12), (7, 17), (7, 3),
-- Student 8 enrolled in 3 courses
(8, 8), (8, 13), (8, 18),
-- Student 9 enrolled in 5 courses
(9, 9), (9, 14), (9, 19), (9, 4), (9, 5),
-- Student 10 enrolled in 4 courses
(10, 10), (10, 15), (10, 20), (10, 6),
-- Student 11 enrolled in 3 courses
(11, 1), (11, 6), (11, 11),
-- Student 12 enrolled in 5 courses
(12, 2), (12, 7), (12, 12), (12, 17), (12, 19),
-- Student 13 enrolled in 4 courses
(13, 3), (13, 8), (13, 13), (13, 18),
-- Student 14 enrolled in 3 courses
(14, 4), (14, 9), (14, 14),
-- Student 15 enrolled in 5 courses
(15, 5), (15, 10), (15, 15), (15, 20), (15, 1),
-- Student 16 enrolled in 4 courses
(16, 6), (16, 11), (16, 16), (16, 2),
-- Student 17 enrolled in 3 courses
(17, 7), (17, 12), (17, 17),
-- Student 18 enrolled in 5 courses
(18, 8), (18, 13), (18, 18), (18, 3), (18, 4),
-- Student 19 enrolled in 4 courses
(19, 9), (19, 14), (19, 19), (19, 5),
-- Student 20 enrolled in 3 courses
(20, 10), (20, 15), (20, 20),
-- Continuing this pattern for all 100 students...
-- Student 21-30
(21, 1), (21, 6), (21, 11), (21, 16),
(22, 2), (22, 7), (22, 12),
(23, 3), (23, 8), (23, 13), (23, 18), (23, 20),
(24, 4), (24, 9), (24, 14), (24, 19),
(25, 5), (25, 10), (25, 15),
(26, 6), (26, 11), (26, 16), (26, 1), (26, 2),
(27, 7), (27, 12), (27, 17), (27, 3),
(28, 8), (28, 13), (28, 18),
(29, 9), (29, 14), (29, 19), (29, 4), (29, 5),
(30, 10), (30, 15), (30, 20), (30, 6),
-- Student 31-40
(31, 1), (31, 6), (31, 11),
(32, 2), (32, 7), (32, 12), (32, 17), (32, 19),
(33, 3), (33, 8), (33, 13), (33, 18),
(34, 4), (34, 9), (34, 14),
(35, 5), (35, 10), (35, 15), (35, 20), (35, 1),
(36, 6), (36, 11), (36, 16), (36, 2),
(37, 7), (37, 12), (37, 17),
(38, 8), (38, 13), (38, 18), (38, 3), (38, 4),
(39, 9), (39, 14), (39, 19), (39, 5),
(40, 10), (40, 15), (40, 20),
-- Student 41-50
(41, 1), (41, 6), (41, 11), (41, 16),
(42, 2), (42, 7), (42, 12),
(43, 3), (43, 8), (43, 13), (43, 18), (43, 20),
(44, 4), (44, 9), (44, 14), (44, 19),
(45, 5), (45, 10), (45, 15),
(46, 6), (46, 11), (46, 16), (46, 1), (46, 2),
(47, 7), (47, 12), (47, 17), (47, 3),
(48, 8), (48, 13), (48, 18),
(49, 9), (49, 14), (49, 19), (49, 4), (49, 5),
(50, 10), (50, 15), (50, 20), (50, 6),
-- Student 51-60
(51, 1), (51, 6), (51, 11),
(52, 2), (52, 7), (52, 12), (52, 17), (52, 19),
(53, 3), (53, 8), (53, 13), (53, 18),
(54, 4), (54, 9), (54, 14),
(55, 5), (55, 10), (55, 15), (55, 20), (55, 1),
(56, 6), (56, 11), (56, 16), (56, 2),
(57, 7), (57, 12), (57, 17),
(58, 8), (58, 13), (58, 18), (58, 3), (58, 4),
(59, 9), (59, 14), (59, 19), (59, 5),
(60, 10), (60, 15), (60, 20),
-- Student 61-70
(61, 1), (61, 6), (61, 11), (61, 16),
(62, 2), (62, 7), (62, 12),
(63, 3), (63, 8), (63, 13), (63, 18), (63, 20),
(64, 4), (64, 9), (64, 14), (64, 19),
(65, 5), (65, 10), (65, 15),
(66, 6), (66, 11), (66, 16), (66, 1), (66, 2),
(67, 7), (67, 12), (67, 17), (67, 3),
(68, 8), (68, 13), (68, 18),
(69, 9), (69, 14), (69, 19), (69, 4), (69, 5),
(70, 10), (70, 15), (70, 20), (70, 6),
-- Student 71-80
(71, 1), (71, 6), (71, 11),
(72, 2), (72, 7), (72, 12), (72, 17), (72, 19),
(73, 3), (73, 8), (73, 13), (73, 18),
(74, 4), (74, 9), (74, 14),
(75, 5), (75, 10), (75, 15), (75, 20), (75, 1),
(76, 6), (76, 11), (76, 16), (76, 2),
(77, 7), (77, 12), (77, 17),
(78, 8), (78, 13), (78, 18), (78, 3), (78, 4),
(79, 9), (79, 14), (79, 19), (79, 5),
(80, 10), (80, 15), (80, 20),
-- Student 81-90
(81, 1), (81, 6), (81, 11), (81, 16),
(82, 2), (82, 7), (82, 12),
(83, 3), (83, 8), (83, 13), (83, 18), (83, 20),
(84, 4), (84, 9), (84, 14), (84, 19),
(85, 5), (85, 10), (85, 15),
(86, 6), (86, 11), (86, 16), (86, 1), (86, 2),
(87, 7), (87, 12), (87, 17), (87, 3),
(88, 8), (88, 13), (88, 18),
(89, 9), (89, 14), (89, 19), (89, 4), (89, 5),
(90, 10), (90, 15), (90, 20), (90, 6),
-- Student 91-100
(91, 1), (91, 6), (91, 11),
(92, 2), (92, 7), (92, 12), (92, 17), (92, 19),
(93, 3), (93, 8), (93, 13), (93, 18),
(94, 4), (94, 9), (94, 14),
(95, 5), (95, 10), (95, 15), (95, 20), (95, 1),
(96, 6), (96, 11), (96, 16), (96, 2),
(97, 7), (97, 12), (97, 17),
(98, 8), (98, 13), (98, 18), (98, 3), (98, 4),
(99, 9), (99, 14), (99, 19), (99, 5),
(100, 10), (100, 15), (100, 20);
GO

-- 16. Insert Questions Data
INSERT INTO Questions (Title, Grade, Type, CourseId) VALUES
-- Data Structures Questions (Course 1)
('What is the time complexity of accessing an element in an array?', 2, 'MCQ', 1),
('Which data structure uses FIFO principle?', 2, 'MCQ', 1),
('A binary search tree where the left subtree is balanced and the right subtree is balanced is called:', 3, 'MCQ', 1),
('The process of visiting all nodes of a tree is called:', 2, 'MCQ', 1),
('Which sorting algorithm has the worst time complexity O(n^2)?', 3, 'MCQ', 1),
('A hash table provides O(1) time complexity for search operations.', 1, 'True/False', 1),
('Linked lists provide constant time access to any element.', 1, 'True/False', 1),
('A stack can be implemented using two queues.', 2, 'True/False', 1),
('Bubble sort is more efficient than merge sort for large datasets.', 1, 'True/False', 1),
('In a max-heap, the root node contains the smallest value.', 1, 'True/False', 1),

-- Algorithms Questions (Course 2)
('Which algorithm design technique is used by quicksort?', 2, 'MCQ', 2),
('The time complexity of binary search is:', 2, 'MCQ', 2),
('Which algorithm is used to find the shortest path in a weighted graph?', 3, 'MCQ', 2),
('The knapsack problem is an example of:', 2, 'MCQ', 2),
('Which sorting algorithm has the best worst-case time complexity?', 3, 'MCQ', 2),
('Greedy algorithms always find the optimal solution.', 1, 'True/False', 2),
('Dynamic programming uses memoization to improve efficiency.', 1, 'True/False', 2),
('Dijkstra''s algorithm works for graphs with negative weights.', 1, 'True/False', 2),
('All NP-complete problems can be solved in polynomial time.', 1, 'True/False', 2),
('Recursive algorithms always use less memory than iterative ones.', 1, 'True/False', 2),

-- Databases Questions (Course 3)
('Which SQL clause is used to filter groups?', 2, 'MCQ', 3),
('What is the purpose of a primary key?', 2, 'MCQ', 3),
('Which normal form eliminates transitive dependencies?', 3, 'MCQ', 3),
('What type of join returns all rows from both tables?', 2, 'MCQ', 3),
('Which database model represents data as a collection of tables?', 2, 'MCQ', 3),
('A view contains actual data stored in the database.', 1, 'True/False', 3),
('The HAVING clause is applied before the GROUP BY clause.', 1, 'True/False', 3),
('NoSQL databases always require a fixed schema.', 1, 'True/False', 3),
('ACID properties ensure database transactions are processed reliably.', 1, 'True/False', 3),
('A candidate key can contain NULL values.', 1, 'True/False', 3),

-- Operating Systems Questions (Course 4)
('What is the main purpose of an operating system?', 2, 'MCQ', 4),
('Which scheduling algorithm allocates CPU to the process with shortest burst time?', 2, 'MCQ', 4),
('What is the main advantage of paging?', 3, 'MCQ', 4),
('Which of these is not a deadlock prevention technique?', 2, 'MCQ', 4),
('What is the purpose of the fork() system call?', 2, 'MCQ', 4),
('Virtual memory allows programs to use more memory than physically available.', 1, 'True/False', 4),
('In Unix, all processes except init have a parent process.', 1, 'True/False', 4),
('Round-robin scheduling is a non-preemptive algorithm.', 1, 'True/False', 4),
('A semaphore can be used to solve the critical section problem.', 1, 'True/False', 4),
('Thrashing occurs when a system spends more time paging than executing.', 1, 'True/False', 4),

-- Networks Questions (Course 5)
('Which protocol is used to translate domain names to IP addresses?', 2, 'MCQ', 5),
('What is the purpose of the TCP three-way handshake?', 2, 'MCQ', 5),
('Which layer of the OSI model handles routing?', 3, 'MCQ', 5),
('What is the main advantage of packet switching?', 2, 'MCQ', 5),
('Which of these is a private IP address range?', 2, 'MCQ', 5),
('HTTP is a connection-oriented protocol.', 1, 'True/False', 5),
('IPv6 addresses are 128 bits long.', 1, 'True/False', 5),
('A switch operates at the network layer.', 1, 'True/False', 5),
('SSL provides encryption at the transport layer.', 1, 'True/False', 5),
('Ping uses ICMP protocol.', 1, 'True/False', 5),

-- Machine Learning Questions (Course 6)
('Which algorithm is used for classification problems?', 2, 'MCQ', 6),
('What is the purpose of the learning rate in gradient descent?', 2, 'MCQ', 6),
('Which evaluation metric is best for imbalanced datasets?', 3, 'MCQ', 6),
('What is the main advantage of random forests?', 2, 'MCQ', 6),
('Which technique is used to reduce overfitting?', 2, 'MCQ', 6),
('Deep learning always performs better than traditional ML algorithms.', 1, 'True/False', 6),
('Feature scaling is necessary for decision tree algorithms.', 1, 'True/False', 6),
('K-means clustering requires specifying the number of clusters.', 1, 'True/False', 6),
('Neural networks can approximate any function.', 1, 'True/False', 6),
('ReLU is a commonly used activation function.', 1, 'True/False', 6),

-- Accounting Principles Questions (Course 7)
('Which financial statement shows revenues and expenses?', 2, 'MCQ', 7),
('What is the accounting equation?', 2, 'MCQ', 7),
('Which principle requires expenses to be recorded when incurred?', 3, 'MCQ', 7),
('What type of account is accounts receivable?', 2, 'MCQ', 7),
('Which inventory method assumes oldest items are sold first?', 2, 'MCQ', 7),
('Assets must always equal liabilities plus equity.', 1, 'True/False', 7),
('Depreciation is a process of valuation.', 1, 'True/False', 7),
('Debits always increase an account balance.', 1, 'True/False', 7),
('GAAP stands for Generally Accepted Accounting Principles.', 1, 'True/False', 7),
('Revenue is recognized when cash is received.', 1, 'True/False', 7),

-- Microeconomics Questions (Course 8)
('What does the law of demand state?', 2, 'MCQ', 8),
('Which of these is a characteristic of perfect competition?', 2, 'MCQ', 8),
('What is the main determinant of price elasticity of demand?', 3, 'MCQ', 8),
('Which cost curve is U-shaped?', 2, 'MCQ', 8),
('What type of good has negative income elasticity?', 2, 'MCQ', 8),
('A price ceiling set above equilibrium price is binding.', 1, 'True/False', 8),
('Monopolies are allocatively efficient.', 1, 'True/False', 8),
('Opportunity cost includes explicit and implicit costs.', 1, 'True/False', 8),
('The marginal product of labor eventually diminishes.', 1, 'True/False', 8),
('GDP includes the value of intermediate goods.', 1, 'True/False', 8),

-- Marketing Management Questions (Course 9)
('Which of the 4Ps represents distribution?', 2, 'MCQ', 9),
('What is the first stage in the consumer decision process?', 2, 'MCQ', 9),
('Which segmentation variable divides markets by age?', 3, 'MCQ', 9),
('What is the purpose of a SWOT analysis?', 2, 'MCQ', 9),
('Which pricing strategy sets high initial prices?', 2, 'MCQ', 9),
('Marketing only involves selling products.', 1, 'True/False', 9),
('The product life cycle has five stages.', 1, 'True/False', 9),
('Brand equity refers to the value of a brand.', 1, 'True/False', 9),
('Social media marketing is part of digital marketing.', 1, 'True/False', 9),
('Market segmentation helps target specific groups.', 1, 'True/False', 9),

-- Business Ethics Questions (Course 10)
('Which ethical approach focuses on consequences?', 2, 'MCQ', 10),
('What is corporate social responsibility?', 2, 'MCQ', 10),
('Which law prohibits bribery of foreign officials?', 3, 'MCQ', 10),
('What is the purpose of a code of ethics?', 2, 'MCQ', 10),
('Which stakeholder group is most affected by layoffs?', 2, 'MCQ', 10),
('Utilitarianism focuses on individual rights.', 1, 'True/False', 10),
('Whistleblowers are always protected by law.', 1, 'True/False', 10),
('Conflict of interest is an ethical issue.', 1, 'True/False', 10),
('Sustainability is part of business ethics.', 1, 'True/False', 10),
('Ethical decisions are always clear-cut.', 1, 'True/False', 10),

-- Anatomy Questions (Course 11)
('Which bone is the longest in the human body?', 2, 'MCQ', 11),
('What is the function of red blood cells?', 2, 'MCQ', 11),
('Which part of the brain controls balance?', 3, 'MCQ', 11),
('How many chambers does the human heart have?', 2, 'MCQ', 11),
('Which system includes the trachea and lungs?', 2, 'MCQ', 11),
('The epidermis is the outermost layer of skin.', 1, 'True/False', 11),
('Veins always carry oxygenated blood.', 1, 'True/False', 11),
('The liver is part of the digestive system.', 1, 'True/False', 11),
('Neurons can regenerate completely after injury.', 1, 'True/False', 11),
('The femur is located in the arm.', 1, 'True/False', 11),

-- Organic Chemistry Questions (Course 12)
('What is the general formula for alkanes?', 2, 'MCQ', 12),
('Which functional group defines an alcohol?', 2, 'MCQ', 12),
('What type of isomerism do enantiomers show?', 3, 'MCQ', 12),
('Which reaction converts alkenes to alkanes?', 2, 'MCQ', 12),
('What is the hybridization of carbon in methane?', 2, 'MCQ', 12),
('All organic compounds contain carbon.', 1, 'True/False', 12),
('Chiral molecules have superimposable mirror images.', 1, 'True/False', 12),
('Benzene is an aliphatic compound.', 1, 'True/False', 12),
('SN2 reactions proceed with inversion of configuration.', 1, 'True/False', 12),
('Ketones contain a carbonyl group.', 1, 'True/False', 12),

-- Calculus I Questions (Course 13)
('What is the derivative of x^2?', 2, 'MCQ', 13),
('Which rule is used to differentiate composite functions?', 2, 'MCQ', 13),
('What is the integral of 1/x?', 3, 'MCQ', 13),
('Which test determines local extrema?', 2, 'MCQ', 13),
('What does the Mean Value Theorem state?', 2, 'MCQ', 13),
('The derivative of a constant is zero.', 1, 'True/False', 13),
('All continuous functions are differentiable.', 1, 'True/False', 13),
('The limit of sin(x)/x as x approaches 0 is 1.', 1, 'True/False', 13),
('An antiderivative is unique.', 1, 'True/False', 13),
('L''Hopital''s rule applies to indeterminate forms.', 1, 'True/False', 13),

-- Physics I Questions (Course 14)
('Which law relates force, mass and acceleration?', 2, 'MCQ', 14),
('What is the SI unit of power?', 2, 'MCQ', 14),
('Which quantity is conserved in elastic collisions?', 3, 'MCQ', 14),
('What does Hooke''s Law describe?', 2, 'MCQ', 14),
('Which type of energy is stored in a spring?', 2, 'MCQ', 14),
('Acceleration due to gravity is the same everywhere.', 1, 'True/False', 14),
('Work done by conservative forces is path independent.', 1, 'True/False', 14),
('Friction always opposes motion.', 1, 'True/False', 14),
('The normal force is always equal to weight.', 1, 'True/False', 14),
('Kinetic energy is a vector quantity.', 1, 'True/False', 14),

-- Linear Algebra Questions (Course 15)
('What is the result of matrix multiplication for A(m×n) and B(n×p)?', 2, 'MCQ', 15),
('Which property must a set of vectors have to be a basis?', 2, 'MCQ', 15),
('What is the determinant of the identity matrix?', 3, 'MCQ', 15),
('Which method solves systems of linear equations?', 2, 'MCQ', 15),
('What is the rank of a matrix?', 2, 'MCQ', 15),
('All square matrices are invertible.', 1, 'True/False', 15),
('The transpose of a product is the product of transposes in reverse order.', 1, 'True/False', 15),
('Eigenvalues can be complex numbers.', 1, 'True/False', 15),
('A symmetric matrix has orthogonal eigenvectors.', 1, 'True/False', 15),
('The null space is also called the kernel.', 1, 'True/False', 15),

-- Project Management Questions (Course 16)
('Which process group comes first in project management?', 2, 'MCQ', 16),
('What is the triple constraint in project management?', 2, 'MCQ', 16),
('Which chart shows project tasks and durations?', 3, 'MCQ', 16),
('What is the purpose of a WBS?', 2, 'MCQ', 16),
('Which risk response strategy avoids the risk?', 2, 'MCQ', 16),
('A project is a temporary endeavor.', 1, 'True/False', 16),
('The critical path has no float.', 1, 'True/False', 16),
('Stakeholders include only the project team.', 1, 'True/False', 16),
('Change requests require formal approval.', 1, 'True/False', 16),
('Quality and grade are the same concepts.', 1, 'True/False', 16),

-- Engineering Mechanics Questions (Course 17)
('Which branch of mechanics deals with motion?', 2, 'MCQ', 17),
('What is the unit of moment of force?', 2, 'MCQ', 17),
('Which theorem relates work and energy?', 3, 'MCQ', 17),
('What does the coefficient of friction measure?', 2, 'MCQ', 17),
('Which condition ensures static equilibrium?', 2, 'MCQ', 17),
('Kinematics studies the causes of motion.', 1, 'True/False', 17),
('A free-body diagram shows all forces acting on a body.', 1, 'True/False', 17),
('Impulse equals change in momentum.', 1, 'True/False', 17),
('The center of mass always lies within the object.', 1, 'True/False', 17),
('Angular momentum is conserved in rotational motion.', 1, 'True/False', 17),

-- Statics Questions (Course 18)
('What condition must be met for a body to be in equilibrium?', 2, 'MCQ', 18),
('Which type of support prevents rotation?', 2, 'MCQ', 18),
('What is the moment of a force about a point?', 3, 'MCQ', 18),
('Which theorem helps find centroids?', 2, 'MCQ', 18),
('What does a frictionless surface imply?', 2, 'MCQ', 18),
('A couple produces translational motion.', 1, 'True/False', 18),
('The center of gravity coincides with the centroid for homogeneous bodies.', 1, 'True/False', 18),
('Trusses are structures composed of two-force members.', 1, 'True/False', 18),
('Shear force is perpendicular to the beam axis.', 1, 'True/False', 18),
('A simply supported beam has fixed ends.', 1, 'True/False', 18),

-- Architectural Design Questions (Course 19)
('Which principle refers to visual equilibrium?', 2, 'MCQ', 19),
('What is the golden ratio approximately equal to?', 2, 'MCQ', 19),
('Which scale is commonly used for floor plans?', 3, 'MCQ', 19),
('What does BIM stand for?', 2, 'MCQ', 19),
('Which material is known for its tensile strength?', 2, 'MCQ', 19),
('Form follows function is a Modernist principle.', 1, 'True/False', 19),
('A cantilever requires support at both ends.', 1, 'True/False', 19),
('Passive solar design uses mechanical systems.', 1, 'True/False', 19),
('The Parthenon exemplifies Gothic architecture.', 1, 'True/False', 19),
('Sustainable design considers environmental impact.', 1, 'True/False', 19),

-- Clinical Psychology Questions (Course 20)
('Which disorder involves manic and depressive episodes?', 2, 'MCQ', 20),
('What is the most common anxiety disorder?', 2, 'MCQ', 20),
('Which therapy focuses on changing negative thoughts?', 3, 'MCQ', 20),
('What does DSM-5 classify?', 2, 'MCQ', 20),
('Which neurotransmitter is associated with depression?', 2, 'MCQ', 20),
('Schizophrenia is a mood disorder.', 1, 'True/False', 20),
('Cognitive-behavioral therapy is short-term and goal-oriented.', 1, 'True/False', 20),
('The unconscious mind is central to humanistic therapy.', 1, 'True/False', 20),
('Antisocial personality disorder involves disregard for others'' rights.', 1, 'True/False', 20),
('Psychologists can prescribe medication in all states.', 1, 'True/False', 20);
GO

-- 17. Insert Choices Data
DECLARE @StudentId INT = 1;
DECLARE @CourseCount INT;
DECLARE @CourseId INT;

WHILE @StudentId <= 100
BEGIN
    -- Randomly decide how many courses (3-5) this student will take
    SET @CourseCount = FLOOR(RAND() * 3) + 3;
    
    -- Assign @CourseCount random courses to this student
    DECLARE @Assigned INT = 0;
    WHILE @Assigned < @CourseCount
    BEGIN
        -- Get a random course (1-20)
        SET @CourseId = FLOOR(RAND() * 20) + 1;
        
        -- Only insert if this student isn't already assigned to this course
        IF NOT EXISTS (SELECT 1 FROM Student_Course WHERE StudentId = @StudentId AND CourseId = @CourseId)
        BEGIN
            INSERT INTO Student_Course (StudentId, CourseId) VALUES (@StudentId, @CourseId);
            SET @Assigned = @Assigned + 1;
        END
    END
    
    SET @StudentId = @StudentId + 1;
END
GO

-- 18. Trigger: Students must be at least 18
CREATE TRIGGER trg_Student_MinAge
ON Student
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE FLOOR(DATEDIFF(DAY, DateOfBirth, GETDATE()) / 365.2425) < 18
    )
    BEGIN
        RAISERROR('Student must be at least 18 years old.', 16, 1);
        ROLLBACK;
    END
    ELSE
    BEGIN
        INSERT INTO Student (Name, DateOfBirth)
        SELECT Name, DateOfBirth FROM inserted;
    END
END;