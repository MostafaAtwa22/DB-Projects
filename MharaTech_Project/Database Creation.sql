CREATE DATABASE MaharaProject;
GO
USE MaharaProject;
GO

-- 1. Department (no dependencies)
CREATE TABLE Department (
    DepartmentId INT IDENTITY(1, 1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Location VARCHAR(20) DEFAULT('Cairo') CHECK(Location IN ('Alex', 'Cairo', 'Mansora', 'Zagaizg')),
    ManagerId INT
);
GO

-- 2. Instructor (depends on Department)
CREATE TABLE Instructor (
    InstructorId INT IDENTITY(1, 1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Salary MONEY Default 7000,
    DepartmentId INT NOT NULL
);
GO

-- 3. Student (depends on Department)
CREATE TABLE Student (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    DepartmentId INT NOT NULL,
    Age AS FLOOR(DATEDIFF(DAY, DateOfBirth, GETDATE()) / 365.2425)
);
GO

-- 4. Course (depends on Department and Instructor)
CREATE TABLE Course (
    CourseId INT IDENTITY(1, 1) PRIMARY KEY,
    Title VARCHAR(30) NOT NULL,
    Hours Decimal(10, 2) DEFAULT 30 CHECK(Hours BETWEEN 20 AND 100),
    MinDegree INT NOT NULL CHECK(MinDegree > 0),
    MaxDegree INT NOT NULL CHECK(MaxDegree <= 150),
    DepartmentId INT NOT NULL,
    InstructorId INT
);
GO

-- 5. Questions (depends on Course)
CREATE TABLE Questions (
    QuesionId INT IDENTITY(1, 1) PRIMARY KEY,
    Title VARCHAR(MAX) NOT NULL,
    Grade Decimal(10, 2) NOT NULL CHECK(Grade <= 100),
    Type VARCHAR(30) DEFAULT 'MCQ' NOT NULL CHECK(Type in ('MCQ', 'True/False')),
    [Correct answer] VARCHAR(MAX) NOT NULL,
    CourseId INT
);
GO

-- 6. Choices (depends on Questions)
CREATE TABLE Choices (
    QuesionId INT,
    Choices VARCHAR(MAX),
    CONSTRAINT FK_Questions_Choices FOREIGN KEY(QuesionId) REFERENCES Questions(QuesionId)
);
GO

-- 7. Student_Course (depends on Student and Course)
CREATE TABLE Student_Course (
    StudentId int NOT NULL,
    CourseId int NOT NULL,
    Grade DECIMAL(8, 2) NOT NULL CHECK(Grade Between 1 AND 150),
    PRIMARY KEY (StudentId, CourseId),
    CONSTRAINT FK_Student_Student_Course FOREIGN KEY(StudentId) REFERENCES Student(StudentId),
    CONSTRAINT FK_Course_Student_Course FOREIGN KEY(CourseId) REFERENCES Course(CourseId)
);
GO

-- 8. Exam (no dependencies)
CREATE TABLE Exam (
    ExamId INT IDENTITY(1, 1) PRIMARY KEY,
    Titel VARCHAR(200) NOT NULL
);
GO

-- 9. Student Answer (depends on Student and Questions)
CREATE TABLE Student_Question_Answer (
    StudentId int NOT NULL,
    QuesionId int NOT NULL,
    State VARCHAR(20) NOT NULL CHECK (State in ('Correct Answer', 'Wrong Answer')),
    PRIMARY KEY (StudentId, QuesionId),
    CONSTRAINT FK_Student_Student_Question_Answer FOREIGN KEY(StudentId) REFERENCES Student(StudentId),
    CONSTRAINT FK_Question_Student_Question_Answer FOREIGN KEY(QuesionId) REFERENCES Questions(QuesionId)
);
GO

-- 10. Student Exam (depends on Student and Exam)
CREATE TABLE Student_Exam (
    StudentId int NOT NULL,
    ExamId int NOT NULL,
    Degree DECIMAL(8, 2) NOT NULL CHECK(Degree Between 1 AND 10),
    PRIMARY KEY (StudentId, ExamId),
    CONSTRAINT FK_Student_Student_Exam FOREIGN KEY(StudentId) REFERENCES Student(StudentId),
    CONSTRAINT FK_Exam_Student_Exam FOREIGN KEY(ExamId) REFERENCES Exam(ExamId)
);
GO

-- 11. Exam Question (depends on Questions and Exam)
CREATE TABLE Exam_Question (
    QuesionId INT NOT NULL,
    ExamId INT NOT NULL,
    PRIMARY KEY (QuesionId, ExamId),
    CONSTRAINT FK_Question_Exam_Question FOREIGN KEY(QuesionId) REFERENCES Questions(QuesionId),
    CONSTRAINT FK_Exam_Exam_Question FOREIGN KEY(ExamId) REFERENCES Exam(ExamId)
);
GO

-- 12. Instructor Exam Course (depends on Instructor, Questions, and Exam)
CREATE TABLE Instructor_Exam_Course (
    InstructorId INT NOT NULL,
    QuesionId INT NOT NULL,
    ExamId INT NOT NULL,
    Degree DECIMAL(8, 2) NOT NULL CHECK(Degree Between 1 AND 10),
    PRIMARY KEY (QuesionId, ExamId, InstructorId),
    CONSTRAINT FK_QuestionInstructor_Exam_Course FOREIGN KEY(QuesionId) REFERENCES Questions(QuesionId),
    CONSTRAINT FK_Exam_Instructor_Exam_Course FOREIGN KEY(ExamId) REFERENCES Exam(ExamId),
    CONSTRAINT FK_Instructor_Instructor_Exam_Course FOREIGN KEY(InstructorId) REFERENCES Instructor(InstructorId)
);
GO

-- Add foreign key constraints after all tables are created
ALTER TABLE Student
ADD CONSTRAINT FK_Department_Student FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId);
GO

ALTER TABLE Course
ADD CONSTRAINT FK_Department_Course FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId);
GO

ALTER TABLE Instructor
ADD CONSTRAINT FK_Department_Instructor FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId);
GO

ALTER TABLE Course
ADD CONSTRAINT FK_Instructor_Course FOREIGN KEY (InstructorId) REFERENCES Instructor(InstructorId);
GO

ALTER TABLE Questions
ADD CONSTRAINT FK_Course_Questions FOREIGN KEY (CourseId) REFERENCES Course(CourseId);
GO

ALTER TABLE Department
ADD CONSTRAINT FK_Instructor_Department FOREIGN KEY (ManagerId) REFERENCES Instructor(InstructorId);
GO

-- Insert data in proper order to satisfy foreign key constraints

-- 1. Insert Department Data (no dependencies)
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
GO

-- 2. Insert Instructor Data (depends on Department)
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

-- 3. Update Department Managers (depends on Instructor)
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

-- 4. Insert Student Data (depends on Department)
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

-- 5. Insert Course Data (depends on Department and Instructor)
INSERT INTO Course (Title, Hours, MinDegree, MaxDegree, DepartmentId, InstructorId) VALUES
('Data Structures', 57.58, 50, 100, 8, 8),
('Algorithms', 22.16, 60, 120, 7, 2),
('Databases', 39.39, 55, 110, 12, 4),
('Operating Systems', 99.23, 65, 130, 13, 5),
('Networks', 77.65, 70, 140, 6, 7),
('Machine Learning', 32.15, 75, 150, 11, 9),
('Accounting Principles', 54.88, 50, 100, 6, 1),
('Microeconomics', 84.23, 60, 120, 2, 3),
('Marketing Management', 61.12, 55, 110, 9, 6),
('Business Ethics', 91.04, 65, 130, 4, 2),
('Anatomy', 44.92, 70, 140, 10, 3),
('Organic Chemistry', 68.56, 75, 150, 5, 5),
('Calculus I', 88.89, 50, 100, 3, 10),
('Physics I', 34.50, 60, 120, 1, 4),
('Linear Algebra', 71.77, 55, 110, 14, 6),
('Project Management', 79.61, 65, 130, 15, 7),
('Engineering Mechanics', 48.34, 70, 140, 8, 3),
('Statics', 55.20, 75, 150, 13, 1),
('Architectural Design', 97.31, 50, 100, 11, 8),
('Clinical Psychology', 28.17, 60, 120, 12, 10);
GO

-- 6. Insert Questions Data (depends on Course)
INSERT INTO Questions (Title, Grade, Type, [Correct answer], CourseId) VALUES
-- Data Structures Questions (Course 1)
('What is the time complexity of accessing an element in an array?', 2, 'MCQ', 'O(1)', 1),
('Which data structure uses FIFO principle?', 2, 'MCQ', 'Queue', 1),
('A binary search tree where the left subtree is balanced and the right subtree is balanced is called:', 3, 'MCQ', 'Balanced BST', 1),
('The process of visiting all nodes of a tree is called:', 2, 'MCQ', 'Traversal', 1),
('Which sorting algorithm has the worst time complexity O(n^2)?', 3, 'MCQ', 'Bubble Sort', 1),
('A hash table provides O(1) time complexity for search operations.', 1, 'True/False', 'True', 1),
('Linked lists provide constant time access to any element.', 1, 'True/False', 'False', 1),
('A stack can be implemented using two queues.', 2, 'True/False', 'True', 1),
('Bubble sort is more efficient than merge sort for large datasets.', 1, 'True/False', 'False', 1),
('In a max-heap, the root node contains the smallest value.', 1, 'True/False', 'False', 1),

-- Algorithms Questions (Course 2)
('Which algorithm design technique is used by quicksort?', 2, 'MCQ', 'Divide and Conquer', 2),
('The time complexity of binary search is:', 2, 'MCQ', 'O(log n)', 2),
('Which algorithm is used to find the shortest path in a weighted graph?', 3, 'MCQ', 'Dijkstra''s Algorithm', 2),
('The knapsack problem is an example of:', 2, 'MCQ', 'Dynamic Programming', 2),
('Which sorting algorithm has the best worst-case time complexity?', 3, 'MCQ', 'Merge Sort', 2),
('Greedy algorithms always find the optimal solution.', 1, 'True/False', 'False', 2),
('Dynamic programming uses memoization to improve efficiency.', 1, 'True/False', 'True', 2),
('Dijkstra''s algorithm works for graphs with negative weights.', 1, 'True/False', 'False', 2),
('All NP-complete problems can be solved in polynomial time.', 1, 'True/False', 'False', 2),
('Recursive algorithms always use less memory than iterative ones.', 1, 'True/False', 'False', 2),

-- Databases Questions (Course 3)
('Which SQL clause is used to filter groups?', 2, 'MCQ', 'HAVING', 3),
('What is the purpose of a primary key?', 2, 'MCQ', 'Uniquely identify rows', 3),
('Which normal form eliminates transitive dependencies?', 3, 'MCQ', '3NF', 3),
('What type of join returns all rows from both tables?', 2, 'MCQ', 'Full Outer Join', 3),
('Which database model represents data as a collection of tables?', 2, 'MCQ', 'Relational', 3),
('A view contains actual data stored in the database.', 1, 'True/False', 'False', 3),
('The HAVING clause is applied before the GROUP BY clause.', 1, 'True/False', 'False', 3),
('NoSQL databases always require a fixed schema.', 1, 'True/False', 'False', 3),
('ACID properties ensure database transactions are processed reliably.', 1, 'True/False', 'True', 3),
('A candidate key can contain NULL values.', 1, 'True/False', 'False', 3),

-- Operating Systems Questions (Course 4)
('What is the main purpose of an operating system?', 2, 'MCQ', 'Manage hardware and software resources', 4),
('Which scheduling algorithm allocates CPU to the process with shortest burst time?', 2, 'MCQ', 'SJF', 4),
('What is the main advantage of paging?', 3, 'MCQ', 'Memory management without external fragmentation', 4),
('Which of these is not a deadlock prevention technique?', 2, 'MCQ', 'Ignore', 4),
('What is the purpose of the fork() system call?', 2, 'MCQ', 'Create a new process', 4),
('Virtual memory allows programs to use more memory than physically available.', 1, 'True/False', 'True', 4),
('In Unix, all processes except init have a parent process.', 1, 'True/False', 'True', 4),
('Round-robin scheduling is a non-preemptive algorithm.', 1, 'True/False', 'False', 4),
('A semaphore can be used to solve the critical section problem.', 1, 'True/False', 'True', 4),
('Thrashing occurs when a system spends more time paging than executing.', 1, 'True/False', 'True', 4),

-- Networks Questions (Course 5)
('Which protocol is used to translate domain names to IP addresses?', 2, 'MCQ', 'DNS', 5),
('What is the purpose of the TCP three-way handshake?', 2, 'MCQ', 'Establish connection', 5),
('Which layer of the OSI model handles routing?', 3, 'MCQ', 'Network', 5),
('What is the main advantage of packet switching?', 2, 'MCQ', 'Efficient bandwidth usage', 5),
('Which of these is a private IP address range?', 2, 'MCQ', '192.168.0.0', 5),
('HTTP is a connection-oriented protocol.', 1, 'True/False', 'False', 5),
('IPv6 addresses are 128 bits long.', 1, 'True/False', 'True', 5),
('A switch operates at the network layer.', 1, 'True/False', 'False', 5),
('SSL provides encryption at the transport layer.', 1, 'True/False', 'True', 5),
('Ping uses ICMP protocol.', 1, 'True/False', 'True', 5),

-- Machine Learning Questions (Course 6)
('Which algorithm is used for classification problems?', 2, 'MCQ', 'Logistic Regression', 6),
('What is the purpose of the learning rate in gradient descent?', 2, 'MCQ', 'Control step size', 6),
('Which evaluation metric is best for imbalanced datasets?', 3, 'MCQ', 'F1 Score', 6),
('What is the main advantage of random forests?', 2, 'MCQ', 'Reduced overfitting', 6),
('Which technique is used to reduce overfitting?', 2, 'MCQ', 'Regularization', 6),
('Deep learning always performs better than traditional ML algorithms.', 1, 'True/False', 'False', 6),
('Feature scaling is necessary for decision tree algorithms.', 1, 'True/False', 'False', 6),
('K-means clustering requires specifying the number of clusters.', 1, 'True/False', 'True', 6),
('Neural networks can approximate any function.', 1, 'True/False', 'True', 6),
('ReLU is a commonly used activation function.', 1, 'True/False', 'True', 6),

-- Accounting Principles Questions (Course 7)
('Which financial statement shows revenues and expenses?', 2, 'MCQ', 'Income Statement', 7),
('What is the accounting equation?', 2, 'MCQ', 'Assets = Liabilities + Equity', 7),
('Which principle requires expenses to be recorded when incurred?', 3, 'MCQ', 'Matching', 7),
('What type of account is accounts receivable?', 2, 'MCQ', 'Asset', 7),
('Which inventory method assumes oldest items are sold first?', 2, 'MCQ', 'FIFO', 7),
('Assets must always equal liabilities plus equity.', 1, 'True/False', 'True', 7),
('Depreciation is a process of valuation.', 1, 'True/False', 'False', 7),
('Debits always increase an account balance.', 1, 'True/False', 'False', 7),
('GAAP stands for Generally Accepted Accounting Principles.', 1, 'True/False', 'True', 7),
('Revenue is recognized when cash is received.', 1, 'True/False', 'False', 7),

-- Microeconomics Questions (Course 8)
('What does the law of demand state?', 2, 'MCQ', 'Price and quantity demanded are inversely related', 8),
('Which of these is a characteristic of perfect competition?', 2, 'MCQ', 'Many buyers and sellers', 8),
('What is the main determinant of price elasticity of demand?', 3, 'MCQ', 'Availability of substitutes', 8),
('Which cost curve is U-shaped?', 2, 'MCQ', 'Average Total Cost', 8),
('What type of good has negative income elasticity?', 2, 'MCQ', 'Inferior', 8),
('A price ceiling set above equilibrium price is binding.', 1, 'True/False', 'False', 8),
('Monopolies are allocatively efficient.', 1, 'True/False', 'False', 8),
('Opportunity cost includes explicit and implicit costs.', 1, 'True/False', 'True', 8),
('The marginal product of labor eventually diminishes.', 1, 'True/False', 'True', 8),
('GDP includes the value of intermediate goods.', 1, 'True/False', 'False', 8),

-- Marketing Management Questions (Course 9)
('Which of the 4Ps represents distribution?', 2, 'MCQ', 'Place', 9),
('What is the first stage in the consumer decision process?', 2, 'MCQ', 'Need Recognition', 9),
('Which segmentation variable divides markets by age?', 3, 'MCQ', 'Demographic', 9),
('What is the purpose of a SWOT analysis?', 2, 'MCQ', 'Assess internal and external factors', 9),
('Which pricing strategy sets high initial prices?', 2, 'MCQ', 'Skimming', 9),
('Marketing only involves selling products.', 1, 'True/False', 'False', 9),
('The product life cycle has five stages.', 1, 'True/False', 'False', 9),
('Brand equity refers to the value of a brand.', 1, 'True/False', 'True', 9),
('Social media marketing is part of digital marketing.', 1, 'True/False', 'True', 9),
('Market segmentation helps target specific groups.', 1, 'True/False', 'True', 9),

-- Business Ethics Questions (Course 10)
('Which ethical approach focuses on consequences?', 2, 'MCQ', 'Utilitarianism', 10),
('What is corporate social responsibility?', 2, 'MCQ', 'Business concern for societal welfare', 10),
('Which law prohibits bribery of foreign officials?', 3, 'MCQ', 'FCPA', 10),
('What is the purpose of a code of ethics?', 2, 'MCQ', 'Guide ethical behavior', 10),
('Which stakeholder group is most affected by layoffs?', 2, 'MCQ', 'Employees', 10),
('Utilitarianism focuses on individual rights.', 1, 'True/False', 'False', 10),
('Whistleblowers are always protected by law.', 1, 'True/False', 'False', 10),
('Conflict of interest is an ethical issue.', 1, 'True/False', 'True', 10),
('Sustainability is part of business ethics.', 1, 'True/False', 'True', 10),
('Ethical decisions are always clear-cut.', 1, 'True/False', 'False', 10),

-- Anatomy Questions (Course 11)
('Which bone is the longest in the human body?', 2, 'MCQ', 'Femur', 11),
('What is the function of red blood cells?', 2, 'MCQ', 'Oxygen transport', 11),
('Which part of the brain controls balance?', 3, 'MCQ', 'Cerebellum', 11),
('How many chambers does the human heart have?', 2, 'MCQ', '4', 11),
('Which system includes the trachea and lungs?', 2, 'MCQ', 'Respiratory', 11),
('The epidermis is the outermost layer of skin.', 1, 'True/False', 'True', 11),
('Veins always carry oxygenated blood.', 1, 'True/False', 'False', 11),
('The liver is part of the digestive system.', 1, 'True/False', 'True', 11),
('Neurons can regenerate completely after injury.', 1, 'True/False', 'False', 11),
('The femur is located in the arm.', 1, 'True/False', 'False', 11),

-- Organic Chemistry Questions (Course 12)
('What is the general formula for alkanes?', 2, 'MCQ', 'CnH2n+2', 12),
('Which functional group defines an alcohol?', 2, 'MCQ', '-OH', 12),
('What type of isomerism do enantiomers show?', 3, 'MCQ', 'Optical', 12),
('Which reaction converts alkenes to alkanes?', 2, 'MCQ', 'Hydrogenation', 12),
('What is the hybridization of carbon in methane?', 2, 'MCQ', 'sp3', 12),
('All organic compounds contain carbon.', 1, 'True/False', 'True', 12),
('Chiral molecules have superimposable mirror images.', 1, 'True/False', 'False', 12),
('Benzene is an aliphatic compound.', 1, 'True/False', 'False', 12),
('SN2 reactions proceed with inversion of configuration.', 1, 'True/False', 'True', 12),
('Ketones contain a carbonyl group.', 1, 'True/False', 'True', 12),

-- Calculus I Questions (Course 13)
('What is the derivative of x^2?', 2, 'MCQ', '2x', 13),
('Which rule is used to differentiate composite functions?', 2, 'MCQ', 'Chain Rule', 13),
('What is the integral of 1/x?', 3, 'MCQ', 'ln|x| + C', 13),
('Which test determines local extrema?', 2, 'MCQ', 'Second Derivative Test', 13),
('What does the Mean Value Theorem state?', 2, 'MCQ', 'Slope equals average rate of change', 13),
('The derivative of a constant is zero.', 1, 'True/False', 'True', 13),
('All continuous functions are differentiable.', 1, 'True/False', 'False', 13),
('The limit of sin(x)/x as x approaches 0 is 1.', 1, 'True/False', 'True', 13),
('An antiderivative is unique.', 1, 'True/False', 'False', 13),
('L''Hopital''s rule applies to indeterminate forms.', 1, 'True/False', 'True', 13),

-- Physics I Questions (Course 14)
('Which law relates force, mass and acceleration?', 2, 'MCQ', 'Newton''s Second Law', 14),
('What is the SI unit of power?', 2, 'MCQ', 'Watt', 14),
('Which quantity is conserved in elastic collisions?', 3, 'MCQ', 'Kinetic Energy', 14),
('What does Hooke''s Law describe?', 2, 'MCQ', 'Spring force', 14),
('Which type of energy is stored in a spring?', 2, 'MCQ', 'Elastic Potential', 14),
('Acceleration due to gravity is the same everywhere.', 1, 'True/False', 'False', 14),
('Work done by conservative forces is path independent.', 1, 'True/False', 'True', 14),
('Friction always opposes motion.', 1, 'True/False', 'True', 14),
('The normal force is always equal to weight.', 1, 'True/False', 'False', 14),
('Kinetic energy is a vector quantity.', 1, 'True/False', 'False', 14),

-- Linear Algebra Questions (Course 15)
('What is the result of matrix multiplication for A(m×n) and B(n×p)?', 2, 'MCQ', 'Matrix C(m×p)', 15),
('Which property must a set of vectors have to be a basis?', 2, 'MCQ', 'Linear Independence', 15),
('What is the determinant of the identity matrix?', 3, 'MCQ', '1', 15),
('Which method solves systems of linear equations?', 2, 'MCQ', 'Gaussian Elimination', 15),
('What is the rank of a matrix?', 2, 'MCQ', 'Number of linearly independent rows', 15),
('All square matrices are invertible.', 1, 'True/False', 'False', 15),
('The transpose of a product is the product of transposes in reverse order.', 1, 'True/False', 'True', 15),
('Eigenvalues can be complex numbers.', 1, 'True/False', 'True', 15),
('A symmetric matrix has orthogonal eigenvectors.', 1, 'True/False', 'True', 15),
('The null space is also called the kernel.', 1, 'True/False', 'True', 15),

-- Project Management Questions (Course 16)
('Which process group comes first in project management?', 2, 'MCQ', 'Initiating', 16),
('What is the triple constraint in project management?', 2, 'MCQ', 'Scope, Time, Cost', 16),
('Which chart shows project tasks and durations?', 3, 'MCQ', 'Gantt Chart', 16),
('What is the purpose of a WBS?', 2, 'MCQ', 'Break down project scope', 16),
('Which risk response strategy avoids the risk?', 2, 'MCQ', 'Avoidance', 16),
('A project is a temporary endeavor.', 1, 'True/False', 'True', 16),
('The critical path has no float.', 1, 'True/False', 'True', 16),
('Stakeholders include only the project team.', 1, 'True/False', 'False', 16),
('Change requests require formal approval.', 1, 'True/False', 'True', 16),
('Quality and grade are the same concepts.', 1, 'True/False', 'False', 16),

-- Engineering Mechanics Questions (Course 17)
('Which branch of mechanics deals with motion?', 2, 'MCQ', 'Kinematics', 17),
('What is the unit of moment of force?', 2, 'MCQ', 'Nm', 17),
('Which theorem relates work and energy?', 3, 'MCQ', 'Work-Energy Theorem', 17),
('What does the coefficient of friction measure?', 2, 'MCQ', 'Resistance to sliding', 17),
('Which condition ensures static equilibrium?', 2, 'MCQ', 'ΣF=0 and ΣM=0', 17),
('Kinematics studies the causes of motion.', 1, 'True/False', 'False', 17),
('A free-body diagram shows all forces acting on a body.', 1, 'True/False', 'True', 17),
('Impulse equals change in momentum.', 1, 'True/False', 'True', 17),
('The center of mass always lies within the object.', 1, 'True/False', 'False', 17),
('Angular momentum is conserved in rotational motion.', 1, 'True/False', 'True', 17),

-- Statics Questions (Course 18)
('What condition must be met for a body to be in equilibrium?', 2, 'MCQ', 'ΣF=0 and ΣM=0', 18),
('Which type of support prevents rotation?', 2, 'MCQ', 'Fixed', 18),
('What is the moment of a force about a point?', 3, 'MCQ', 'Force × perpendicular distance', 18),
('Which theorem helps find centroids?', 2, 'MCQ', 'Pappus-Guldinus', 18),
('What does a frictionless surface imply?', 2, 'MCQ', 'No tangential force', 18),
('A couple produces translational motion.', 1, 'True/False', 'False', 18),
('The center of gravity coincides with the centroid for homogeneous bodies.', 1, 'True/False', 'True', 18),
('Trusses are structures composed of two-force members.', 1, 'True/False', 'True', 18),
('Shear force is perpendicular to the beam axis.', 1, 'True/False', 'False', 18),
('A simply supported beam has fixed ends.', 1, 'True/False', 'False', 18),

-- Architectural Design Questions (Course 19)
('Which principle refers to visual equilibrium?', 2, 'MCQ', 'Balance', 19),
('What is the golden ratio approximately equal to?', 2, 'MCQ', '1.618', 19),
('Which scale is commonly used for floor plans?', 3, 'MCQ', '1:50', 19),
('What does BIM stand for?', 2, 'MCQ', 'Building Information Modeling', 19),
('Which material is known for its tensile strength?', 2, 'MCQ', 'Steel', 19),
('Form follows function is a Modernist principle.', 1, 'True/False', 'True', 19),
('A cantilever requires support at both ends.', 1, 'True/False', 'False', 19),
('Passive solar design uses mechanical systems.', 1, 'True/False', 'False', 19),
('The Parthenon exemplifies Gothic architecture.', 1, 'True/False', 'False', 19),
('Sustainable design considers environmental impact.', 1, 'True/False', 'True', 19),

-- Clinical Psychology Questions (Course 20)
('Which disorder involves manic and depressive episodes?', 2, 'MCQ', 'Bipolar Disorder', 20),
('What is the most common anxiety disorder?', 2, 'MCQ', 'Generalized Anxiety Disorder', 20),
('Which therapy focuses on changing negative thoughts?', 3, 'MCQ', 'Cognitive Behavioral Therapy', 20),
('What does DSM-5 classify?', 2, 'MCQ', 'Mental Disorders', 20),
('Which neurotransmitter is associated with depression?', 2, 'MCQ', 'Serotonin', 20),
('Schizophrenia is a mood disorder.', 1, 'True/False', 'False', 20),
('Cognitive-behavioral therapy is short-term and goal-oriented.', 1, 'True/False', 'True', 20),
('The unconscious mind is central to humanistic therapy.', 1, 'True/False', 'False', 20),
('Antisocial personality disorder involves disregard for others'' rights.', 1, 'True/False', 'True', 20),
('Psychologists can prescribe medication in all states.', 1, 'True/False', 'False', 20);
GO

-- 7. Insert Choices Data (depends on Questions)
-- For MCQ questions, we'll add 4 choices (1 correct, 3 incorrect)
-- For True/False questions, we'll add the two options
INSERT INTO Choices (QuesionId, Choices) VALUES
-- Data Structures Questions (Course 1)
(1, 'O(1),O(n),O(log n),O(n^2)'),
(2, 'Queue,Stack,Heap,Tree'),
(3, 'Balanced BST,AVL Tree,Red-Black Tree,Splay Tree'),
(4, 'Traversal,Searching,Insertion,Deletion'),
(5, 'Bubble Sort,Merge Sort,Quick Sort,Heap Sort'),
(6, 'True,False'),
(7, 'True,False'),
(8, 'True,False'),
(9, 'True,False'),
(10, 'True,False'),

-- Algorithms Questions (Course 2)
(11, 'Divide and Conquer,Greedy,Dynamic Programming,Backtracking'),
(12, 'O(log n),O(n),O(n log n),O(n^2)'),
(13, 'Dijkstra''s Algorithm,Prim''s Algorithm,Kruskal''s Algorithm,Floyd-Warshall'),
(14, 'Dynamic Programming,Greedy,Divide and Conquer,Backtracking'),
(15, 'Merge Sort,Quick Sort,Heap Sort,Insertion Sort'),
(16, 'True,False'),
(17, 'True,False'),
(18, 'True,False'),
(19, 'True,False'),
(20, 'True,False'),

-- Databases Questions (Course 3)
(21, 'HAVING,WHERE,GROUP BY,ORDER BY'),
(22, 'Uniquely identify rows,Store large data,Improve performance,Enforce constraints'),
(23, '3NF,2NF,1NF,BCNF'),
(24, 'Full Outer Join,Inner Join,Left Join,Right Join'),
(25, 'Relational,Hierarchical,Network,Object-oriented'),
(26, 'True,False'),
(27, 'True,False'),
(28, 'True,False'),
(29, 'True,False'),
(30, 'True,False'),

-- Operating Systems Questions (Course 4)
(31, 'Manage hardware and software resources,Run applications,Connect to internet,Store files'),
(32, 'SJF,FCFS,Round Robin,Priority'),
(33, 'Memory management without external fragmentation,Faster access,Less overhead,Better security'),
(34, 'Ignore,Prevention,Avoidance,Detection'),
(35, 'Create a new process,Terminate a process,Change priority,Allocate memory'),
(36, 'True,False'),
(37, 'True,False'),
(38, 'True,False'),
(39, 'True,False'),
(40, 'True,False'),

-- Networks Questions (Course 5)
(41, 'DNS,HTTP,TCP,IP'),
(42, 'Establish connection,Terminate connection,Transfer data,Encrypt data'),
(43, 'Network,Transport,Session,Presentation'),
(44, 'Efficient bandwidth usage,Faster speed,More reliable,Better security'),
(45, '192.168.0.0,8.8.8.8,172.217.0.0,203.0.113.0'),
(46, 'True,False'),
(47, 'True,False'),
(48, 'True,False'),
(49, 'True,False'),
(50, 'True,False'),

-- Machine Learning Questions (Course 6)
(51, 'Logistic Regression,Linear Regression,K-means,PCA'),
(52, 'Control step size,Adjust weights,Compute loss,Regularize model'),
(53, 'F1 Score,Accuracy,Precision,Recall'),
(54, 'Reduced overfitting,Faster training,Better interpretability,Less data needed'),
(55, 'Regularization,Dropout,Data augmentation,Early stopping'),
(56, 'True,False'),
(57, 'True,False'),
(58, 'True,False'),
(59, 'True,False'),
(60, 'True,False'),

-- Accounting Principles Questions (Course 7)
(61, 'Income Statement,Balance Sheet,Cash Flow,Statement of Equity'),
(62, 'Assets = Liabilities + Equity,Debits = Credits,Revenue - Expenses = Profit,Assets - Liabilities = Equity'),
(63, 'Matching,Revenue Recognition,Consistency,Materiality'),
(64, 'Asset,Liability,Equity,Revenue'),
(65, 'FIFO,LIFO,Weighted Average,Specific Identification'),
(66, 'True,False'),
(67, 'True,False'),
(68, 'True,False'),
(69, 'True,False'),
(70, 'True,False'),

-- Microeconomics Questions (Course 8)
(71, 'Price and quantity demanded are inversely related,Price and quantity demanded are directly related,Price and supply are inversely related,Price and supply are directly related'),
(72, 'Many buyers and sellers,Unique product,Barriers to entry,Price maker'),
(73, 'Availability of substitutes,Price of complements,Consumer income,Time horizon'),
(74, 'Average Total Cost,Marginal Cost,Average Variable Cost,Total Cost'),
(75, 'Inferior,Normal,Luxury,Necessity'),
(76, 'True,False'),
(77, 'True,False'),
(78, 'True,False'),
(79, 'True,False'),
(80, 'True,False'),

-- Marketing Management Questions (Course 9)
(81, 'Place,Price,Product,Promotion'),
(82, 'Need Recognition,Information Search,Evaluation,Purchase'),
(83, 'Demographic,Psychographic,Behavioral,Geographic'),
(84, 'Assess internal and external factors,Analyze competitors,Evaluate customers,Plan marketing mix'),
(85, 'Skimming,Penetration,Competitive,Value-based'),
(86, 'True,False'),
(87, 'True,False'),
(88, 'True,False'),
(89, 'True,False'),
(90, 'True,False'),

-- Business Ethics Questions (Course 10)
(91, 'Utilitarianism,Deontology,Virtue Ethics,Rights-based'),
(92, 'Business concern for societal welfare,Maximizing profits,Legal compliance,Employee satisfaction'),
(93, 'FCPA,Sarbanes-Oxley,Sherman Act,Clayton Act'),
(94, 'Guide ethical behavior,Set company policies,Ensure legal compliance,Improve productivity'),
(95, 'Employees,Shareholders,Customers,Suppliers'),
(96, 'True,False'),
(97, 'True,False'),
(98, 'True,False'),
(99, 'True,False'),
(100, 'True,False'),

-- Anatomy Questions (Course 11)
(101, 'Femur,Tibia,Humerus,Radius'),
(102, 'Oxygen transport,Immune defense,Blood clotting,Hormone production'),
(103, 'Cerebellum,Cerebrum,Brain stem,Thalamus'),
(104, '4,2,3,1'),
(105, 'Respiratory,Digestive,Circulatory,Nervous'),
(106, 'True,False'),
(107, 'True,False'),
(108, 'True,False'),
(109, 'True,False'),
(110, 'True,False'),

-- Organic Chemistry Questions (Course 12)
(111, 'CnH2n+2,CnH2n,CnH2n-2,CnHn'),
(112, '-OH,-COOH,-CHO,-NH2'),
(113, 'Optical,Geometric,Structural,Conformational'),
(114, 'Hydrogenation,Halogenation,Hydration,Oxidation'),
(115, 'sp3,sp2,sp,sp3d'),
(116, 'True,False'),
(117, 'True,False'),
(118, 'True,False'),
(119, 'True,False'),
(120, 'True,False'),

-- Calculus I Questions (Course 13)
(121, '2x,x^2,2,0'),
(122, 'Chain Rule,Product Rule,Quotient Rule,Power Rule'),
(123, 'ln|x| + C,1/x + C,x ln x - x + C,e^x + C'),
(124, 'Second Derivative Test,First Derivative Test,Mean Value Theorem,Intermediate Value Theorem'),
(125, 'Slope equals average rate of change,Function equals its derivative,Integral equals area,Derivative is continuous'),
(126, 'True,False'),
(127, 'True,False'),
(128, 'True,False'),
(129, 'True,False'),
(130, 'True,False'),

-- Physics I Questions (Course 14)
(131, 'Newton''s Second Law,Newton''s First Law,Newton''s Third Law,Law of Gravitation'),
(132, 'Watt,Joule,Newton,Volt'),
(133, 'Kinetic Energy,Momentum,Both,Neither'),
(134, 'Spring force,Gravitational force,Frictional force,Electrical force'),
(135, 'Elastic Potential,Kinetic,Thermal,Chemical'),
(136, 'True,False'),
(137, 'True,False'),
(138, 'True,False'),
(139, 'True,False'),
(140, 'True,False'),

-- Linear Algebra Questions (Course 15)
(141, 'Matrix C(m×p),Matrix C(n×p),Matrix C(m×n),Matrix C(p×m)'),
(142, 'Linear Independence,Orthogonality,Same dimension,Equal magnitude'),
(143, '1,0,Undefined,Depends on size'),
(144, 'Gaussian Elimination,Cramer''s Rule,Matrix Inversion,All of the above'),
(145, 'Number of linearly independent rows,Number of columns,Determinant value,Trace'),
(146, 'True,False'),
(147, 'True,False'),
(148, 'True,False'),
(149, 'True,False'),
(150, 'True,False'),

-- Project Management Questions (Course 16)
(151, 'Initiating,Planning,Executing,Monitoring'),
(152, 'Scope, Time, Cost,Quality, Risk, Resources,Stakeholders, Communication, Quality,Scope, Budget, Schedule'),
(153, 'Gantt Chart,PERT Chart,Network Diagram,Histogram'),
(154, 'Break down project scope,Assign resources,Schedule tasks,Estimate costs'),
(155, 'Avoidance,Mitigation,Transfer,Acceptance'),
(156, 'True,False'),
(157, 'True,False'),
(158, 'True,False'),
(159, 'True,False'),
(160, 'True,False'),

-- Engineering Mechanics Questions (Course 17)
(161, 'Kinematics,Kinetics,Statics,Dynamics'),
(162, 'Nm,Joule,Watt,Pascal'),
(163, 'Work-Energy Theorem,Conservation of Energy,Newton''s Second Law,Hooke''s Law'),
(164, 'Resistance to sliding,Surface hardness,Weight,Area of contact'),
(165, 'ΣF=0 and ΣM=0,ΣF=0,ΣM=0,None'),
(166, 'True,False'),
(167, 'True,False'),
(168, 'True,False'),
(169, 'True,False'),
(170, 'True,False'),

-- Statics Questions (Course 18)
(171, 'ΣF=0 and ΣM=0,ΣF=0,ΣM=0,None'),
(172, 'Fixed,Pinned,Roller,Simple'),
(173, 'Force × perpendicular distance,Force × distance,Mass × acceleration,Mass × velocity'),
(174, 'Pappus-Guldinus,Pythagorean,Green''s,Stokes'''),
(175, 'No tangential force,No normal force,Perfect smoothness,Infinite friction'),
(176, 'True,False'),
(177, 'True,False'),
(178, 'True,False'),
(179, 'True,False'),
(180, 'True,False'),

-- Architectural Design Questions (Course 19)
(181, 'Balance,Proportion,Rhythm,Emphasis'),
(182, '1.618,3.14,2.718,1.414'),
(183, '1:50,1:100,1:200,1:500'),
(184, 'Building Information Modeling,Building Integrated Modeling,Business Information Management,Building Inspection Method'),
(185, 'Steel,Concrete,Wood,Glass'),
(186, 'True,False'),
(187, 'True,False'),
(188, 'True,False'),
(189, 'True,False'),
(190, 'True,False'),

-- Clinical Psychology Questions (Course 20)
(191, 'Bipolar Disorder,Major Depressive Disorder,Schizophrenia,Anxiety Disorder'),
(192, 'Generalized Anxiety Disorder,Panic Disorder,Social Anxiety Disorder,OCD'),
(193, 'Cognitive Behavioral Therapy,Psychoanalysis,Humanistic Therapy,Behavioral Therapy'),
(194, 'Mental Disorders,Physical Diseases,Personality Types,Learning Styles'),
(195, 'Serotonin,Dopamine,GABA,Acetylcholine'),
(196, 'True,False'),
(197, 'True,False'),
(198, 'True,False'),
(199, 'True,False'),
(200, 'True,False');
GO

-- 8. Insert Student_Course Data (depends on Student and Course)
INSERT INTO Student_Course (StudentId, CourseId, Grade) VALUES
-- Student 1 (4 courses)
(1, 1, 85.5), (1, 5, 78.2), (1, 10, 92.0), (1, 15, 88.3),
-- Student 2 (4 courses)
(2, 2, 76.3), (2, 7, 88.1), (2, 12, 81.5), (2, 17, 79.8),
-- Student 3 (4 courses)
(3, 3, 90.2), (3, 8, 85.7), (3, 13, 77.4), (3, 18, 83.6),
-- Student 4 (3 courses)
(4, 4, 82.6), (4, 9, 79.3), (4, 14, 88.9),
-- Student 5 (5 courses)
(5, 5, 84.1), (5, 10, 76.8), (5, 15, 89.5), (5, 20, 91.2), (5, 2, 83.7),
-- Student 6 (4 courses)
(6, 6, 87.4), (6, 11, 82.9), (6, 16, 90.1), (6, 1, 85.0),
-- Student 7 (3 courses)
(7, 7, 79.5), (7, 12, 84.2), (7, 17, 88.7),
-- Student 8 (4 courses)
(8, 8, 91.3), (8, 13, 83.8), (8, 18, 86.4), (8, 3, 82.1),
-- Student 9 (5 courses)
(9, 9, 80.6), (9, 14, 92.3), (9, 19, 87.9), (9, 4, 84.5), (9, 10, 89.1),
-- Student 10 (3 courses)
(10, 10, 93.2), (10, 15, 85.7), (10, 20, 90.4),
-- Students 11-20
(11, 1, 86.5), (11, 6, 81.2), (11, 11, 89.3),
(12, 2, 84.7), (12, 7, 87.9), (12, 12, 82.4), (12, 17, 90.6),
(13, 3, 88.1), (13, 8, 83.5), (13, 13, 86.9),
(14, 4, 91.8), (14, 9, 84.3), (14, 14, 89.7),
(15, 5, 82.9), (15, 10, 90.2), (15, 15, 87.5), (15, 20, 93.1), (15, 1, 85.8),
-- Students 21-30
(16, 6, 88.4), (16, 11, 83.7), (16, 16, 91.0), (16, 2, 86.2),
(17, 7, 89.3), (17, 12, 84.8), (17, 17, 92.5),
(18, 8, 85.9), (18, 13, 90.4), (18, 18, 87.1), (18, 3, 83.6),
(19, 9, 92.7), (19, 14, 86.3), (19, 19, 89.8), (19, 5, 84.9),
(20, 10, 87.2), (20, 15, 93.5), (20, 20, 88.6),
-- Students 31-40
(21, 1, 89.4), (21, 6, 84.1), (21, 11, 90.7), (21, 16, 85.3),
(22, 2, 92.8), (22, 7, 87.5), (22, 12, 83.9),
(23, 3, 90.5), (23, 8, 85.8), (23, 13, 88.2), (23, 18, 84.7),
(24, 4, 91.9), (24, 9, 86.4), (24, 14, 89.1),
(25, 5, 88.3), (25, 10, 93.6), (25, 15, 87.8), (25, 20, 84.2), (25, 1, 90.9),
-- Students 41-50
(26, 6, 85.6), (26, 11, 92.3), (26, 16, 88.7), (26, 2, 83.4),
(27, 7, 90.1), (27, 12, 85.7), (27, 17, 89.4),
(28, 8, 86.9), (28, 13, 91.5), (28, 18, 87.2), (28, 3, 84.8),
(29, 9, 92.6), (29, 14, 88.3), (29, 19, 85.9), (29, 5, 90.4),
(30, 10, 87.1), (30, 15, 93.8), (30, 20, 89.5),
-- Students 51-60
(31, 1, 90.2), (31, 6, 85.4), (31, 11, 88.9),
(32, 2, 93.7), (32, 7, 89.1), (32, 12, 84.6), (32, 17, 91.3),
(33, 3, 87.5), (33, 8, 92.8), (33, 13, 88.4),
(34, 4, 90.6), (34, 9, 86.1), (34, 14, 89.7),
(35, 5, 88.2), (35, 10, 93.9), (35, 15, 87.6), (35, 20, 84.3), (35, 1, 91.0),
-- Students 61-70
(36, 6, 86.7), (36, 11, 92.4), (36, 16, 89.1), (36, 2, 85.8),
(37, 7, 91.2), (37, 12, 87.5), (37, 17, 84.9),
(38, 8, 89.3), (38, 13, 93.6), (38, 18, 88.2), (38, 3, 85.7),
(39, 9, 92.5), (39, 14, 89.8), (39, 19, 86.4), (39, 5, 91.1),
(40, 10, 88.6), (40, 15, 94.0), (40, 20, 90.3),
-- Students 71-80
(41, 1, 91.3), (41, 6, 87.6), (41, 11, 84.1), (41, 16, 89.8),
(42, 2, 93.2), (42, 7, 88.5), (42, 12, 85.9),
(43, 3, 90.7), (43, 8, 86.2), (43, 13, 89.5), (43, 18, 85.0),
(44, 4, 92.9), (44, 9, 88.4), (44, 14, 85.7),
(45, 5, 91.4), (45, 10, 87.9), (45, 15, 84.2), (45, 20, 89.7), (45, 1, 93.0),
-- Students 81-90
(46, 6, 88.1), (46, 11, 93.6), (46, 16, 90.2), (46, 2, 86.7),
(47, 7, 92.3), (47, 12, 89.8), (47, 17, 86.3),
(48, 8, 90.5), (48, 13, 87.0), (48, 18, 93.5), (48, 3, 89.2),
(49, 9, 94.1), (49, 14, 90.6), (49, 19, 87.3), (49, 5, 92.8),
(50, 10, 89.4), (50, 15, 85.9), (50, 20, 91.2),
-- Students 91-100
(51, 1, 92.7), (51, 6, 89.0), (51, 11, 85.5),
(52, 2, 94.2), (52, 7, 90.7), (52, 12, 87.2), (52, 17, 93.7),
(53, 3, 91.8), (53, 8, 88.3), (53, 13, 84.8),
(54, 4, 93.9), (54, 9, 90.4), (54, 14, 87.1),
(55, 5, 92.6), (55, 10, 89.1), (55, 15, 85.6), (55, 20, 91.3), (55, 1, 94.0),
(56, 6, 90.2), (56, 11, 86.7), (56, 16, 93.2), (56, 2, 89.7),
(57, 7, 94.3), (57, 12, 90.8), (57, 17, 87.5),
(58, 8, 92.9), (58, 13, 89.4), (58, 18, 86.1), (58, 3, 93.6),
(59, 9, 91.0), (59, 14, 87.7), (59, 19, 94.2), (59, 5, 90.9),
(60, 10, 88.4), (60, 15, 93.9), (60, 20, 90.6),
(61, 1, 94.1), (61, 6, 90.8), (61, 11, 87.3), (61, 16, 93.8),
(62, 2, 92.5), (62, 7, 89.0), (62, 12, 85.7),
(63, 3, 94.3), (63, 8, 90.6), (63, 13, 87.1), (63, 18, 93.6),
(64, 4, 91.9), (64, 9, 88.4), (64, 14, 85.1),
(65, 5, 94.2), (65, 10, 90.7), (65, 15, 87.2), (65, 20, 93.7), (65, 1, 90.0),
(66, 6, 88.3), (66, 11, 94.8), (66, 16, 91.3), (66, 2, 87.8),
(67, 7, 93.5), (67, 12, 90.0), (67, 17, 86.7),
(68, 8, 94.9), (68, 13, 91.4), (68, 18, 88.1), (68, 3, 94.6),
(69, 9, 92.1), (69, 14, 88.8), (69, 19, 85.3), (69, 5, 91.8),
(70, 10, 89.5), (70, 15, 94.0), (70, 20, 90.7),
(71, 1, 93.2), (71, 6, 89.9), (71, 11, 86.4), (71, 16, 92.9),
(72, 2, 94.7), (72, 7, 91.2), (72, 12, 87.9), (72, 17, 94.4),
(73, 3, 92.0), (73, 8, 88.7), (73, 13, 85.2),
(74, 4, 94.9), (74, 9, 91.6), (74, 14, 88.3),
(75, 5, 93.8), (75, 10, 90.1), (75, 15, 86.8), (75, 20, 93.3), (75, 1, 89.8),
(76, 6, 87.5), (76, 11, 94.0), (76, 16, 90.5), (76, 2, 87.2),
(77, 7, 93.7), (77, 12, 90.4), (77, 17, 87.1),
(78, 8, 94.2), (78, 13, 90.9), (78, 18, 87.6), (78, 3, 94.1),
(79, 9, 91.8), (79, 14, 88.5), (79, 19, 95.0), (79, 5, 91.5),
(80, 10, 88.2), (80, 15, 93.7), (80, 20, 90.4),
(81, 1, 94.3), (81, 6, 91.0), (81, 11, 87.7), (81, 16, 94.2),
(82, 2, 92.9), (82, 7, 89.6), (82, 12, 86.3), (82, 17, 92.8),
(83, 3, 94.5), (83, 8, 91.2), (83, 13, 87.9), (83, 18, 94.4),
(84, 4, 93.1), (84, 9, 89.8), (84, 14, 86.5),
(85, 5, 94.6), (85, 10, 91.3), (85, 15, 88.0), (85, 20, 94.5), (85, 1, 91.0),
(86, 6, 87.9), (86, 11, 94.4), (86, 16, 91.1), (86, 2, 87.8),
(87, 7, 93.9), (87, 12, 90.6), (87, 17, 87.3),
(88, 8, 94.8), (88, 13, 91.5), (88, 18, 88.2), (88, 3, 94.7),
(89, 9, 92.4), (89, 14, 89.1), (89, 19, 85.8), (89, 5, 92.3),
(90, 10, 88.9), (90, 15, 94.4), (90, 20, 91.1),
(91, 1, 93.6), (91, 6, 90.3), (91, 11, 87.0), (91, 16, 93.5),
(92, 2, 95.0), (92, 7, 91.7), (92, 12, 88.4), (92, 17, 94.9),
(93, 3, 92.8), (93, 8, 89.5), (93, 13, 86.2),
(94, 4, 94.1), (94, 9, 90.8), (94, 14, 87.7),
(95, 5, 93.4), (95, 10, 90.1), (95, 15, 86.8), (95, 20, 93.3), (95, 1, 90.0),
(96, 6, 86.9), (96, 11, 93.4), (96, 16, 90.1), (96, 2, 86.8),
(97, 7, 94.1), (97, 12, 90.8), (97, 17, 87.5),
(98, 8, 93.6), (98, 13, 90.3), (98, 18, 87.0), (98, 3, 93.5),
(99, 9, 90.2), (99, 14, 86.9), (99, 19, 93.4), (99, 5, 90.1),
(100, 10, 86.8), (100, 15, 93.3), (100, 20, 90.0);
GO

-- 9. Insert Exam Data (no dependencies)
INSERT INTO Exam (Titel) VALUES
('Midterm Exam - Spring 2023'),
('Final Exam - Spring 2023'),
('Midterm Exam - Fall 2023'),
('Final Exam - Fall 2023'),
('Makeup Exam - Spring 2023'),
('Makeup Exam - Fall 2023'),
('Quiz 1 - Spring 2023'),
('Quiz 2 - Spring 2023'),
('Quiz 1 - Fall 2023'),
('Quiz 2 - Fall 2023');
GO

-- 10. Insert Exam_Question Data (depends on Exam and Questions)
INSERT INTO Exam_Question (QuesionId, ExamId) VALUES
-- Exam 1 (50 questions)
(1,1),(3,1),(5,1),(7,1),(9,1),(11,1),(13,1),(15,1),(17,1),(19,1),
(21,1),(23,1),(25,1),(27,1),(29,1),(31,1),(33,1),(35,1),(37,1),(39,1),
(41,1),(43,1),(45,1),(47,1),(49,1),(51,1),(53,1),(55,1),(57,1),(59,1),
(61,1),(63,1),(65,1),(67,1),(69,1),(71,1),(73,1),(75,1),(77,1),(79,1),
(81,1),(83,1),(85,1),(87,1),(89,1),(91,1),(93,1),(95,1),(97,1),(99,1),

-- Exam 2 (50 questions)
(2,2),(4,2),(6,2),(8,2),(10,2),(12,2),(14,2),(16,2),(18,2),(20,2),
(22,2),(24,2),(26,2),(28,2),(30,2),(32,2),(34,2),(36,2),(38,2),(40,2),
(42,2),(44,2),(46,2),(48,2),(50,2),(52,2),(54,2),(56,2),(58,2),(60,2),
(62,2),(64,2),(66,2),(68,2),(70,2),(72,2),(74,2),(76,2),(78,2),(80,2),
(82,2),(84,2),(86,2),(88,2),(90,2),(92,2),(94,2),(96,2),(98,2),(100,2),

-- Exam 3 (50 questions)
(1,3),(3,3),(6,3),(8,3),(10,3),(11,3),(14,3),(16,3),(19,3),(20,3),
(21,3),(24,3),(26,3),(29,3),(30,3),(31,3),(34,3),(36,3),(39,3),(40,3),
(41,3),(44,3),(46,3),(49,3),(50,3),(51,3),(54,3),(56,3),(59,3),(60,3),
(61,3),(64,3),(66,3),(69,3),(70,3),(71,3),(74,3),(76,3),(79,3),(80,3),
(81,3),(84,3),(86,3),(89,3),(90,3),(91,3),(94,3),(96,3),(99,3),(100,3),

-- Exam 4 (50 questions)
(2,4),(4,4),(5,4),(7,4),(9,4),(12,4),(13,4),(15,4),(17,4),(18,4),
(22,4),(23,4),(25,4),(27,4),(28,4),(32,4),(33,4),(35,4),(37,4),(38,4),
(42,4),(43,4),(45,4),(47,4),(48,4),(52,4),(53,4),(55,4),(57,4),(58,4),
(62,4),(63,4),(65,4),(67,4),(68,4),(72,4),(73,4),(75,4),(77,4),(78,4),
(82,4),(83,4),(85,4),(87,4),(88,4),(92,4),(93,4),(95,4),(97,4),(98,4),

-- Exam 5 (50 questions)
(1,5),(2,5),(3,5),(4,5),(5,5),(11,5),(12,5),(13,5),(14,5),(15,5),
(21,5),(22,5),(23,5),(24,5),(25,5),(31,5),(32,5),(33,5),(34,5),(35,5),
(41,5),(42,5),(43,5),(44,5),(45,5),(51,5),(52,5),(53,5),(54,5),(55,5),
(61,5),(62,5),(63,5),(64,5),(65,5),(71,5),(72,5),(73,5),(74,5),(75,5),
(81,5),(82,5),(83,5),(84,5),(85,5),(91,5),(92,5),(93,5),(94,5),(95,5),

-- Exam 6 (50 questions)
(6,6),(7,6),(8,6),(9,6),(10,6),(16,6),(17,6),(18,6),(19,6),(20,6),
(26,6),(27,6),(28,6),(29,6),(30,6),(36,6),(37,6),(38,6),(39,6),(40,6),
(46,6),(47,6),(48,6),(49,6),(50,6),(56,6),(57,6),(58,6),(59,6),(60,6),
(66,6),(67,6),(68,6),(69,6),(70,6),(76,6),(77,6),(78,6),(79,6),(80,6),
(86,6),(87,6),(88,6),(89,6),(90,6),(96,6),(97,6),(98,6),(99,6),(100,6),

-- Exam 7 (50 questions)
(1,7),(4,7),(7,7),(10,7),(13,7),(16,7),(19,7),(22,7),(25,7),(28,7),
(31,7),(34,7),(37,7),(40,7),(43,7),(46,7),(49,7),(52,7),(55,7),(58,7),
(61,7),(64,7),(67,7),(70,7),(73,7),(76,7),(79,7),(82,7),(85,7),(88,7),
(91,7),(94,7),(97,7),(100,7),(2,7),(5,7),(8,7),(11,7),(14,7),(17,7),
(20,7),(23,7),(26,7),(29,7),(32,7),(35,7),(38,7),(41,7),(44,7),(47,7),

-- Exam 8 (50 questions)
(50,8),(49,8),(48,8),(47,8),(46,8),(45,8),(44,8),(43,8),(42,8),(41,8),
(40,8),(39,8),(38,8),(37,8),(36,8),(35,8),(34,8),(33,8),(32,8),(31,8),
(30,8),(29,8),(28,8),(27,8),(26,8),(25,8),(24,8),(23,8),(22,8),(21,8),
(20,8),(19,8),(18,8),(17,8),(16,8),(15,8),(14,8),(13,8),(12,8),(11,8),
(10,8),(9,8),(8,8),(7,8),(6,8),(5,8),(4,8),(3,8),(2,8),(1,8),

-- Exam 9 (50 questions)
(100,9),(99,9),(98,9),(97,9),(96,9),(95,9),(94,9),(93,9),(92,9),(91,9),
(90,9),(89,9),(88,9),(87,9),(86,9),(85,9),(84,9),(83,9),(82,9),(81,9),
(80,9),(79,9),(78,9),(77,9),(76,9),(75,9),(74,9),(73,9),(72,9),(71,9),
(70,9),(69,9),(68,9),(67,9),(66,9),(65,9),(64,9),(63,9),(62,9),(61,9),
(60,9),(59,9),(58,9),(57,9),(56,9),(55,9),(54,9),(53,9),(52,9),(51,9),

-- Exam 10 (50 questions)
(1,10),(10,10),(20,10),(30,10),(40,10),(50,10),(60,10),(70,10),(80,10),(90,10),
(100,10),(2,10),(11,10),(21,10),(31,10),(41,10),(51,10),(61,10),(71,10),(81,10),
(91,10),(3,10),(12,10),(22,10),(32,10),(42,10),(52,10),(62,10),(72,10),(82,10),
(92,10),(4,10),(13,10),(23,10),(33,10),(43,10),(53,10),(63,10),(73,10),(83,10),
(93,10),(5,10),(14,10),(24,10),(34,10),(44,10),(54,10),(64,10),(74,10),(84,10);
GO

-- 11. Insert Student_Exam Data (depends on Student and Exam)
INSERT INTO Student_Exam (StudentId, ExamId, Degree) VALUES
-- Student 1-10
(1, 2, 7.5), (1, 5, 8.2), (1, 8, 6.9),
(2, 1, 9.1), (2, 3, 7.8), (2, 7, 8.5),
(3, 4, 8.7), (3, 6, 7.2), (3, 9, 9.0),
(4, 2, 8.4), (4, 5, 7.1), (4, 10, 8.9),
(5, 1, 9.2), (5, 4, 7.5), (5, 7, 8.1),
(6, 3, 8.3), (6, 6, 7.6), (6, 9, 8.8),
(7, 2, 7.9), (7, 5, 8.6), (7, 8, 7.3),
(8, 1, 9.3), (8, 4, 8.0), (8, 7, 7.7),
(9, 3, 8.1), (9, 6, 7.4), (9, 10, 9.1),
(10, 2, 8.5), (10, 5, 7.8), (10, 8, 8.2),

-- Student 11-20
(11, 1, 8.7), (11, 4, 7.2), (11, 7, 8.9),
(12, 3, 9.0), (12, 6, 7.5), (12, 9, 8.4),
(13, 2, 8.1), (13, 5, 7.6), (13, 8, 9.2),
(14, 1, 8.8), (14, 4, 7.3), (14, 10, 8.5),
(15, 3, 9.1), (15, 6, 7.8), (15, 7, 8.6),
(16, 2, 8.3), (16, 5, 7.0), (16, 9, 8.7),
(17, 1, 9.2), (17, 4, 7.7), (17, 8, 8.4),
(18, 3, 8.5), (18, 6, 7.2), (18, 10, 9.0),
(19, 2, 8.6), (19, 5, 7.9), (19, 7, 8.3),
(20, 1, 9.3), (20, 4, 7.4), (20, 9, 8.8),

-- Student 21-30
(21, 3, 8.2), (21, 6, 7.5), (21, 8, 9.1),
(22, 2, 8.7), (22, 5, 7.8), (22, 10, 8.4),
(23, 1, 9.0), (23, 4, 7.3), (23, 7, 8.6),
(24, 3, 8.1), (24, 6, 7.4), (24, 9, 8.9),
(25, 2, 8.5), (25, 5, 7.7), (25, 8, 9.2),
(26, 1, 8.8), (26, 4, 7.6), (26, 10, 8.3),
(27, 3, 9.1), (27, 6, 7.9), (27, 7, 8.5),
(28, 2, 8.4), (28, 5, 7.2), (28, 9, 8.7),
(29, 1, 9.2), (29, 4, 7.5), (29, 8, 8.9),
(30, 3, 8.3), (30, 6, 7.6), (30, 10, 9.0),

-- Student 31-40
(31, 2, 8.6), (31, 5, 7.9), (31, 7, 8.4),
(32, 1, 9.1), (32, 4, 7.4), (32, 9, 8.7),
(33, 3, 8.2), (33, 6, 7.7), (33, 8, 9.0),
(34, 2, 8.5), (34, 5, 7.8), (34, 10, 8.3),
(35, 1, 9.2), (35, 4, 7.3), (35, 7, 8.6),
(36, 3, 8.1), (36, 6, 7.6), (36, 9, 8.9),
(37, 2, 8.4), (37, 5, 7.9), (37, 8, 9.1),
(38, 1, 8.7), (38, 4, 7.2), (38, 10, 8.5),
(39, 3, 9.0), (39, 6, 7.5), (39, 7, 8.8),
(40, 2, 8.3), (40, 5, 7.8), (40, 9, 8.6),

-- Student 41-50
(41, 1, 9.1), (41, 4, 7.4), (41, 8, 8.7),
(42, 3, 8.2), (42, 6, 7.7), (42, 10, 9.0),
(43, 2, 8.5), (43, 5, 7.6), (43, 7, 8.9),
(44, 1, 9.2), (44, 4, 7.3), (44, 9, 8.4),
(45, 3, 8.1), (45, 6, 7.8), (45, 8, 8.7),
(46, 2, 8.6), (46, 5, 7.5), (46, 10, 9.1),
(47, 1, 8.9), (47, 4, 7.2), (47, 7, 8.5),
(48, 3, 8.0), (48, 6, 7.9), (48, 9, 8.8),
(49, 2, 8.3), (49, 5, 7.4), (49, 8, 9.2),
(50, 1, 8.7), (50, 4, 7.6), (50, 10, 8.5),

-- Student 51-60
(51, 3, 8.2), (51, 6, 7.7), (51, 7, 9.0),
(52, 2, 8.5), (52, 5, 7.8), (52, 9, 8.3),
(53, 1, 9.1), (53, 4, 7.3), (53, 8, 8.6),
(54, 3, 8.4), (54, 6, 7.9), (54, 10, 8.7),
(55, 2, 8.1), (55, 5, 7.6), (55, 7, 9.2),
(56, 1, 8.8), (56, 4, 7.5), (56, 9, 8.4),
(57, 3, 9.0), (57, 6, 7.8), (57, 8, 8.5),
(58, 2, 8.3), (58, 5, 7.7), (58, 10, 8.9),
(59, 1, 9.2), (59, 4, 7.4), (59, 7, 8.6),
(60, 3, 8.1), (60, 6, 7.9), (60, 9, 8.7),

-- Student 61-70
(61, 2, 8.4), (61, 5, 7.6), (61, 8, 9.0),
(62, 1, 8.7), (62, 4, 7.3), (62, 10, 8.5),
(63, 3, 9.1), (63, 6, 7.8), (63, 7, 8.4),
(64, 2, 8.2), (64, 5, 7.5), (64, 9, 8.9),
(65, 1, 9.0), (65, 4, 7.6), (65, 8, 8.3),
(66, 3, 8.5), (66, 6, 7.9), (66, 10, 8.6),
(67, 2, 8.1), (67, 5, 7.4), (67, 7, 9.2),
(68, 1, 8.8), (68, 4, 7.7), (68, 9, 8.5),
(69, 3, 9.0), (69, 6, 7.2), (69, 8, 8.7),
(70, 2, 8.3), (70, 5, 7.8), (70, 10, 8.4),

-- Student 71-80
(71, 1, 9.1), (71, 4, 7.5), (71, 7, 8.6),
(72, 3, 8.2), (72, 6, 7.9), (72, 9, 8.9),
(73, 2, 8.4), (73, 5, 7.6), (73, 8, 9.0),
(74, 1, 8.7), (74, 4, 7.3), (74, 10, 8.5),
(75, 3, 9.2), (75, 6, 7.8), (75, 7, 8.3),
(76, 2, 8.1), (76, 5, 7.5), (76, 9, 8.7),
(77, 1, 9.0), (77, 4, 7.6), (77, 8, 8.4),
(78, 3, 8.5), (78, 6, 7.9), (78, 10, 8.6),
(79, 2, 8.2), (79, 5, 7.4), (79, 7, 9.1),
(80, 1, 8.9), (80, 4, 7.7), (80, 9, 8.3),

-- Student 81-90
(81, 3, 8.0), (81, 6, 7.8), (81, 8, 8.7),
(82, 2, 8.3), (82, 5, 7.5), (82, 10, 9.0),
(83, 1, 9.2), (83, 4, 7.6), (83, 7, 8.4),
(84, 3, 8.1), (84, 6, 7.9), (84, 9, 8.5),
(85, 2, 8.6), (85, 5, 7.4), (85, 8, 9.1),
(86, 1, 8.7), (86, 4, 7.3), (86, 10, 8.8),
(87, 3, 9.0), (87, 6, 7.8), (87, 7, 8.5),
(88, 2, 8.2), (88, 5, 7.5), (88, 9, 8.9),
(89, 1, 9.1), (89, 4, 7.6), (89, 8, 8.4),
(90, 3, 8.3), (90, 6, 7.9), (90, 10, 8.6),

-- Student 91-100
(91, 2, 8.0), (91, 5, 7.4), (91, 7, 9.2),
(92, 1, 8.7), (92, 4, 7.5), (92, 9, 8.3),
(93, 3, 9.0), (93, 6, 7.8), (93, 8, 8.5),
(94, 2, 8.1), (94, 5, 7.6), (94, 10, 8.9),
(95, 1, 9.2), (95, 4, 7.3), (95, 7, 8.6),
(96, 3, 8.4), (96, 6, 7.9), (96, 9, 8.7),
(97, 2, 8.5), (97, 5, 7.8), (97, 8, 9.0),
(98, 1, 8.2), (98, 4, 7.5), (98, 10, 8.4),
(99, 3, 9.1), (99, 6, 7.6), (99, 7, 8.8),
(100, 2, 8.3), (100, 5, 7.9), (100, 9, 8.6);
Go

-- 12. Insert Student_Question_Answer Data (depends on Student and Questions)
INSERT INTO Student_Question_Answer (StudentId, QuesionId, State) VALUES
-- Student 1 answers (20 questions)
(1, 1, 'Correct Answer'), (1, 3, 'Wrong Answer'), (1, 5, 'Correct Answer'), (1, 7, 'Wrong Answer'), (1, 9, 'Correct Answer'),
(1, 11, 'Wrong Answer'), (1, 13, 'Correct Answer'), (1, 15, 'Wrong Answer'), (1, 17, 'Correct Answer'), (1, 19, 'Wrong Answer'),
(1, 21, 'Correct Answer'), (1, 23, 'Wrong Answer'), (1, 25, 'Correct Answer'), (1, 27, 'Wrong Answer'), (1, 29, 'Correct Answer'),
(1, 31, 'Wrong Answer'), (1, 33, 'Correct Answer'), (1, 35, 'Wrong Answer'), (1, 37, 'Correct Answer'), (1, 39, 'Wrong Answer'),

-- Student 2 answers (20 questions)
(2, 2, 'Correct Answer'), (2, 4, 'Wrong Answer'), (2, 6, 'Correct Answer'), (2, 8, 'Wrong Answer'), (2, 10, 'Correct Answer'),
(2, 12, 'Wrong Answer'), (2, 14, 'Correct Answer'), (2, 16, 'Wrong Answer'), (2, 18, 'Correct Answer'), (2, 20, 'Wrong Answer'),
(2, 22, 'Correct Answer'), (2, 24, 'Wrong Answer'), (2, 26, 'Correct Answer'), (2, 28, 'Wrong Answer'), (2, 30, 'Correct Answer'),
(2, 32, 'Wrong Answer'), (2, 34, 'Correct Answer'), (2, 36, 'Wrong Answer'), (2, 38, 'Correct Answer'), (2, 40, 'Wrong Answer'),

-- Student 3 answers (20 questions)
(3, 41, 'Correct Answer'), (3, 43, 'Wrong Answer'), (3, 45, 'Correct Answer'), (3, 47, 'Wrong Answer'), (3, 49, 'Correct Answer'),
(3, 51, 'Wrong Answer'), (3, 53, 'Correct Answer'), (3, 55, 'Wrong Answer'), (3, 57, 'Correct Answer'), (3, 59, 'Wrong Answer'),
(3, 61, 'Correct Answer'), (3, 63, 'Wrong Answer'), (3, 65, 'Correct Answer'), (3, 67, 'Wrong Answer'), (3, 69, 'Correct Answer'),
(3, 71, 'Wrong Answer'), (3, 73, 'Correct Answer'), (3, 75, 'Wrong Answer'), (3, 77, 'Correct Answer'), (3, 79, 'Wrong Answer'),

-- Student 4 answers (20 questions)
(4, 81, 'Correct Answer'), (4, 83, 'Wrong Answer'), (4, 85, 'Correct Answer'), (4, 87, 'Wrong Answer'), (4, 89, 'Correct Answer'),
(4, 91, 'Wrong Answer'), (4, 93, 'Correct Answer'), (4, 95, 'Wrong Answer'), (4, 97, 'Correct Answer'), (4, 99, 'Wrong Answer'),
(4, 101, 'Correct Answer'), (4, 103, 'Wrong Answer'), (4, 105, 'Correct Answer'), (4, 107, 'Wrong Answer'), (4, 109, 'Correct Answer'),
(4, 111, 'Wrong Answer'), (4, 113, 'Correct Answer'), (4, 115, 'Wrong Answer'), (4, 117, 'Correct Answer'), (4, 119, 'Wrong Answer'),

-- Student 5 answers (20 questions)
(5, 121, 'Correct Answer'), (5, 123, 'Wrong Answer'), (5, 125, 'Correct Answer'), (5, 127, 'Wrong Answer'), (5, 129, 'Correct Answer'),
(5, 131, 'Wrong Answer'), (5, 133, 'Correct Answer'), (5, 135, 'Wrong Answer'), (5, 137, 'Correct Answer'), (5, 139, 'Wrong Answer'),
(5, 141, 'Correct Answer'), (5, 143, 'Wrong Answer'), (5, 145, 'Correct Answer'), (5, 147, 'Wrong Answer'), (5, 149, 'Correct Answer'),
(5, 151, 'Wrong Answer'), (5, 153, 'Correct Answer'), (5, 155, 'Wrong Answer'), (5, 157, 'Correct Answer'), (5, 159, 'Wrong Answer'),

-- Student 6 answers (20 questions)
(6, 161, 'Correct Answer'), (6, 163, 'Wrong Answer'), (6, 165, 'Correct Answer'), (6, 167, 'Wrong Answer'), (6, 169, 'Correct Answer'),
(6, 171, 'Wrong Answer'), (6, 173, 'Correct Answer'), (6, 175, 'Wrong Answer'), (6, 177, 'Correct Answer'), (6, 179, 'Wrong Answer'),
(6, 181, 'Correct Answer'), (6, 183, 'Wrong Answer'), (6, 185, 'Correct Answer'), (6, 187, 'Wrong Answer'), (6, 189, 'Correct Answer'),
(6, 191, 'Wrong Answer'), (6, 193, 'Correct Answer'), (6, 195, 'Wrong Answer'), (6, 197, 'Correct Answer'), (6, 199, 'Wrong Answer'),

-- Student 7 answers (20 questions)
(7, 2, 'Correct Answer'), (7, 4, 'Wrong Answer'), (7, 6, 'Correct Answer'), (7, 8, 'Wrong Answer'), (7, 10, 'Correct Answer'),
(7, 12, 'Wrong Answer'), (7, 14, 'Correct Answer'), (7, 16, 'Wrong Answer'), (7, 18, 'Correct Answer'), (7, 20, 'Wrong Answer'),
(7, 22, 'Correct Answer'), (7, 24, 'Wrong Answer'), (7, 26, 'Correct Answer'), (7, 28, 'Wrong Answer'), (7, 30, 'Correct Answer'),
(7, 32, 'Wrong Answer'), (7, 34, 'Correct Answer'), (7, 36, 'Wrong Answer'), (7, 38, 'Correct Answer'), (7, 40, 'Wrong Answer'),

-- Student 8 answers (20 questions)
(8, 42, 'Correct Answer'), (8, 44, 'Wrong Answer'), (8, 46, 'Correct Answer'), (8, 48, 'Wrong Answer'), (8, 50, 'Correct Answer'),
(8, 52, 'Wrong Answer'), (8, 54, 'Correct Answer'), (8, 56, 'Wrong Answer'), (8, 58, 'Correct Answer'), (8, 60, 'Wrong Answer'),
(8, 62, 'Correct Answer'), (8, 64, 'Wrong Answer'), (8, 66, 'Correct Answer'), (8, 68, 'Wrong Answer'), (8, 70, 'Correct Answer'),
(8, 72, 'Wrong Answer'), (8, 74, 'Correct Answer'), (8, 76, 'Wrong Answer'), (8, 78, 'Correct Answer'), (8, 80, 'Wrong Answer'),

-- Student 9 answers (20 questions)
(9, 82, 'Correct Answer'), (9, 84, 'Wrong Answer'), (9, 86, 'Correct Answer'), (9, 88, 'Wrong Answer'), (9, 90, 'Correct Answer'),
(9, 92, 'Wrong Answer'), (9, 94, 'Correct Answer'), (9, 96, 'Wrong Answer'), (9, 98, 'Correct Answer'), (9, 100, 'Wrong Answer'),
(9, 102, 'Correct Answer'), (9, 104, 'Wrong Answer'), (9, 106, 'Correct Answer'), (9, 108, 'Wrong Answer'), (9, 110, 'Correct Answer'),
(9, 112, 'Wrong Answer'), (9, 114, 'Correct Answer'), (9, 116, 'Wrong Answer'), (9, 118, 'Correct Answer'), (9, 120, 'Wrong Answer'),

-- Student 10 answers (20 questions)
(10, 122, 'Correct Answer'), (10, 124, 'Wrong Answer'), (10, 126, 'Correct Answer'), (10, 128, 'Wrong Answer'), (10, 130, 'Correct Answer'),
(10, 132, 'Wrong Answer'), (10, 134, 'Correct Answer'), (10, 136, 'Wrong Answer'), (10, 138, 'Correct Answer'), (10, 140, 'Wrong Answer'),
(10, 142, 'Correct Answer'), (10, 144, 'Wrong Answer'), (10, 146, 'Correct Answer'), (10, 148, 'Wrong Answer'), (10, 150, 'Correct Answer'),
(10, 152, 'Wrong Answer'), (10, 154, 'Correct Answer'), (10, 156, 'Wrong Answer'), (10, 158, 'Correct Answer'), (10, 160, 'Wrong Answer'),

-- Student 11 answers (20 questions)
(11, 1, 'Correct Answer'), (11, 3, 'Wrong Answer'), (11, 5, 'Correct Answer'), (11, 7, 'Wrong Answer'), (11, 9, 'Correct Answer'),
(11, 11, 'Wrong Answer'), (11, 13, 'Correct Answer'), (11, 15, 'Wrong Answer'), (11, 17, 'Correct Answer'), (11, 19, 'Wrong Answer'),
(11, 21, 'Correct Answer'), (11, 23, 'Wrong Answer'), (11, 25, 'Correct Answer'), (11, 27, 'Wrong Answer'), (11, 29, 'Correct Answer'),
(11, 31, 'Wrong Answer'), (11, 33, 'Correct Answer'), (11, 35, 'Wrong Answer'), (11, 37, 'Correct Answer'), (11, 39, 'Wrong Answer'),

-- Student 12 answers (20 questions)
(12, 41, 'Correct Answer'), (12, 43, 'Wrong Answer'), (12, 45, 'Correct Answer'), (12, 47, 'Wrong Answer'), (12, 49, 'Correct Answer'),
(12, 51, 'Wrong Answer'), (12, 53, 'Correct Answer'), (12, 55, 'Wrong Answer'), (12, 57, 'Correct Answer'), (12, 59, 'Wrong Answer'),
(12, 61, 'Correct Answer'), (12, 63, 'Wrong Answer'), (12, 65, 'Correct Answer'), (12, 67, 'Wrong Answer'), (12, 69, 'Correct Answer'),
(12, 71, 'Wrong Answer'), (12, 73, 'Correct Answer'), (12, 75, 'Wrong Answer'), (12, 77, 'Correct Answer'), (12, 79, 'Wrong Answer'),

-- Student 13 answers (20 questions)
(13, 81, 'Correct Answer'), (13, 83, 'Wrong Answer'), (13, 85, 'Correct Answer'), (13, 87, 'Wrong Answer'), (13, 89, 'Correct Answer'),
(13, 91, 'Wrong Answer'), (13, 93, 'Correct Answer'), (13, 95, 'Wrong Answer'), (13, 97, 'Correct Answer'), (13, 99, 'Wrong Answer'),
(13, 101, 'Correct Answer'), (13, 103, 'Wrong Answer'), (13, 105, 'Correct Answer'), (13, 107, 'Wrong Answer'), (13, 109, 'Correct Answer'),
(13, 111, 'Wrong Answer'), (13, 113, 'Correct Answer'), (13, 115, 'Wrong Answer'), (13, 117, 'Correct Answer'), (13, 119, 'Wrong Answer'),

-- Student 14 answers (20 questions)
(14, 121, 'Correct Answer'), (14, 123, 'Wrong Answer'), (14, 125, 'Correct Answer'), (14, 127, 'Wrong Answer'), (14, 129, 'Correct Answer'),
(14, 131, 'Wrong Answer'), (14, 133, 'Correct Answer'), (14, 135, 'Wrong Answer'), (14, 137, 'Correct Answer'), (14, 139, 'Wrong Answer'),
(14, 141, 'Correct Answer'), (14, 143, 'Wrong Answer'), (14, 145, 'Correct Answer'), (14, 147, 'Wrong Answer'), (14, 149, 'Correct Answer'),
(14, 151, 'Wrong Answer'), (14, 153, 'Correct Answer'), (14, 155, 'Wrong Answer'), (14, 157, 'Correct Answer'), (14, 159, 'Wrong Answer'),

-- Student 15 answers (20 questions)
(15, 161, 'Correct Answer'), (15, 163, 'Wrong Answer'), (15, 165, 'Correct Answer'), (15, 167, 'Wrong Answer'), (15, 169, 'Correct Answer'),
(15, 171, 'Wrong Answer'), (15, 173, 'Correct Answer'), (15, 175, 'Wrong Answer'), (15, 177, 'Correct Answer'), (15, 179, 'Wrong Answer'),
(15, 181, 'Correct Answer'), (15, 183, 'Wrong Answer'), (15, 185, 'Correct Answer'), (15, 187, 'Wrong Answer'), (15, 189, 'Correct Answer'),
(15, 191, 'Wrong Answer'), (15, 193, 'Correct Answer'), (15, 195, 'Wrong Answer'), (15, 197, 'Correct Answer'), (15, 199, 'Wrong Answer'),

-- Student 16 answers (20 questions)
(16, 2, 'Correct Answer'), (16, 4, 'Wrong Answer'), (16, 6, 'Correct Answer'), (16, 8, 'Wrong Answer'), (16, 10, 'Correct Answer'),
(16, 12, 'Wrong Answer'), (16, 14, 'Correct Answer'), (16, 16, 'Wrong Answer'), (16, 18, 'Correct Answer'), (16, 20, 'Wrong Answer'),
(16, 22, 'Correct Answer'), (16, 24, 'Wrong Answer'), (16, 26, 'Correct Answer'), (16, 28, 'Wrong Answer'), (16, 30, 'Correct Answer'),
(16, 32, 'Wrong Answer'), (16, 34, 'Correct Answer'), (16, 36, 'Wrong Answer'), (16, 38, 'Correct Answer'), (16, 40, 'Wrong Answer'),

-- Student 17 answers (20 questions)
(17, 42, 'Correct Answer'), (17, 44, 'Wrong Answer'), (17, 46, 'Correct Answer'), (17, 48, 'Wrong Answer'), (17, 50, 'Correct Answer'),
(17, 52, 'Wrong Answer'), (17, 54, 'Correct Answer'), (17, 56, 'Wrong Answer'), (17, 58, 'Correct Answer'), (17, 60, 'Wrong Answer'),
(17, 62, 'Correct Answer'), (17, 64, 'Wrong Answer'), (17, 66, 'Correct Answer'), (17, 68, 'Wrong Answer'), (17, 70, 'Correct Answer'),
(17, 72, 'Wrong Answer'), (17, 74, 'Correct Answer'), (17, 76, 'Wrong Answer'), (17, 78, 'Correct Answer'), (17, 80, 'Wrong Answer'),

-- Student 18 answers (20 questions)
(18, 82, 'Correct Answer'), (18, 84, 'Wrong Answer'), (18, 86, 'Correct Answer'), (18, 88, 'Wrong Answer'), (18, 90, 'Correct Answer'),
(18, 92, 'Wrong Answer'), (18, 94, 'Correct Answer'), (18, 96, 'Wrong Answer'), (18, 98, 'Correct Answer'), (18, 100, 'Wrong Answer'),
(18, 102, 'Correct Answer'), (18, 104, 'Wrong Answer'), (18, 106, 'Correct Answer'), (18, 108, 'Wrong Answer'), (18, 110, 'Correct Answer'),
(18, 112, 'Wrong Answer'), (18, 114, 'Correct Answer'), (18, 116, 'Wrong Answer'), (18, 118, 'Correct Answer'), (18, 120, 'Wrong Answer'),

-- Student 19 answers (20 questions)
(19, 122, 'Correct Answer'), (19, 124, 'Wrong Answer'), (19, 126, 'Correct Answer'), (19, 128, 'Wrong Answer'), (19, 130, 'Correct Answer'),
(19, 132, 'Wrong Answer'), (19, 134, 'Correct Answer'), (19, 136, 'Wrong Answer'), (19, 138, 'Correct Answer'), (19, 140, 'Wrong Answer'),
(19, 142, 'Correct Answer'), (19, 144, 'Wrong Answer'), (19, 146, 'Correct Answer'), (19, 148, 'Wrong Answer'), (19, 150, 'Correct Answer'),
(19, 152, 'Wrong Answer'), (19, 154, 'Correct Answer'), (19, 156, 'Wrong Answer'), (19, 158, 'Correct Answer'), (19, 160, 'Wrong Answer'),

-- Student 20 answers (20 questions)
(20, 1, 'Correct Answer'), (20, 3, 'Wrong Answer'), (20, 5, 'Correct Answer'), (20, 7, 'Wrong Answer'), (20, 9, 'Correct Answer'),
(20, 11, 'Wrong Answer'), (20, 13, 'Correct Answer'), (20, 15, 'Wrong Answer'), (20, 17, 'Correct Answer'), (20, 19, 'Wrong Answer'),
(20, 21, 'Correct Answer'), (20, 23, 'Wrong Answer'), (20, 25, 'Correct Answer'), (20, 27, 'Wrong Answer'), (20, 29, 'Correct Answer'),
(20, 31, 'Wrong Answer'), (20, 33, 'Correct Answer'), (20, 35, 'Wrong Answer'), (20, 37, 'Correct Answer'), (20, 39, 'Wrong Answer');
GO

-- 13. Insert Instructor_Exam_Course Data (depends on Instructor, Questions, and Exam)
INSERT INTO Instructor_Exam_Course (InstructorId, QuesionId, ExamId, Degree) VALUES
-- Instructor 1 (5 records)
(1, 1, 1, 2.0), (1, 3, 1, 3.0), (1, 5, 1, 3.0), (1, 7, 1, 1.0), (1, 9, 1, 2.0),

-- Instructor 2 (5 records)
(2, 11, 2, 2.0), (2, 13, 2, 3.0), (2, 15, 2, 3.0), (2, 17, 2, 1.0), (2, 19, 2, 2.0),

-- Instructor 3 (5 records)
(3, 21, 3, 2.0), (3, 23, 3, 3.0), (3, 25, 3, 2.0), (3, 27, 3, 1.0), (3, 29, 3, 1.0),

-- Instructor 4 (5 records)
(4, 31, 4, 2.0), (4, 33, 4, 3.0), (4, 35, 4, 2.0), (4, 37, 4, 1.0), (4, 39, 4, 1.0),

-- Instructor 5 (5 records)
(5, 41, 5, 2.0), (5, 43, 5, 3.0), (5, 45, 5, 2.0), (5, 47, 5, 1.0), (5, 49, 5, 1.0),

-- Instructor 6 (5 records)
(6, 51, 6, 2.0), (6, 53, 6, 3.0), (6, 55, 6, 2.0), (6, 57, 6, 1.0), (6, 59, 6, 1.0),

-- Instructor 7 (5 records)
(7, 61, 7, 2.0), (7, 63, 7, 3.0), (7, 65, 7, 2.0), (7, 67, 7, 1.0), (7, 69, 7, 1.0),

-- Instructor 8 (5 records)
(8, 71, 8, 2.0), (8, 73, 8, 3.0), (8, 75, 8, 2.0), (8, 77, 8, 1.0), (8, 79, 8, 1.0),

-- Instructor 9 (5 records)
(9, 81, 9, 2.0), (9, 83, 9, 3.0), (9, 85, 9, 2.0), (9, 87, 9, 1.0), (9, 89, 9, 1.0),

-- Instructor 10 (5 records)
(10, 91, 10, 2.0), (10, 93, 10, 3.0), (10, 95, 10, 2.0), (10, 97, 10, 1.0), (10, 99, 10, 1.0),

-- Instructor 11 (5 records)
(11, 101, 1, 2.0), (11, 103, 1, 3.0), (11, 105, 1, 2.0), (11, 107, 1, 1.0), (11, 109, 1, 1.0),

-- Instructor 12 (5 records)
(12, 111, 2, 2.0), (12, 113, 2, 3.0), (12, 115, 2, 2.0), (12, 117, 2, 1.0), (12, 119, 2, 1.0),

-- Instructor 13 (5 records)
(13, 121, 3, 2.0), (13, 123, 3, 3.0), (13, 125, 3, 2.0), (13, 127, 3, 1.0), (13, 129, 3, 1.0),

-- Instructor 14 (5 records)
(14, 131, 4, 2.0), (14, 133, 4, 3.0), (14, 135, 4, 2.0), (14, 137, 4, 1.0), (14, 139, 4, 1.0),

-- Instructor 15 (5 records)
(15, 141, 5, 2.0), (15, 143, 5, 3.0), (15, 145, 5, 2.0), (15, 147, 5, 1.0), (15, 149, 5, 1.0),

-- Instructor 16 (5 records)
(16, 151, 6, 2.0), (16, 153, 6, 3.0), (16, 155, 6, 2.0), (16, 157, 6, 1.0), (16, 159, 6, 1.0),

-- Instructor 17 (5 records)
(17, 161, 7, 2.0), (17, 163, 7, 3.0), (17, 165, 7, 2.0), (17, 167, 7, 1.0), (17, 169, 7, 1.0),

-- Instructor 18 (5 records)
(18, 171, 8, 2.0), (18, 173, 8, 3.0), (18, 175, 8, 2.0), (18, 177, 8, 1.0), (18, 179, 8, 1.0),

-- Instructor 19 (5 records)
(19, 181, 9, 2.0), (19, 183, 9, 3.0), (19, 185, 9, 2.0), (19, 187, 9, 1.0), (19, 189, 9, 1.0),

-- Instructor 20 (5 records)
(20, 191, 10, 2.0), (20, 193, 10, 3.0), (20, 195, 10, 2.0), (20, 197, 10, 1.0), (20, 199, 10, 1.0),

-- Instructor 21 (5 records)
(21, 2, 1, 2.0), (21, 4, 1, 2.0), (21, 6, 1, 1.0), (21, 8, 1, 2.0), (21, 10, 1, 1.0),

-- Instructor 22 (5 records)
(22, 12, 2, 2.0), (22, 14, 2, 3.0), (22, 16, 2, 1.0), (22, 18, 2, 2.0), (22, 20, 2, 1.0),

-- Instructor 23 (5 records)
(23, 22, 3, 2.0), (23, 24, 3, 2.0), (23, 26, 3, 2.0), (23, 28, 3, 1.0), (23, 30, 3, 1.0),

-- Instructor 24 (5 records)
(24, 32, 4, 2.0), (24, 34, 4, 3.0), (24, 36, 4, 1.0), (24, 38, 4, 2.0), (24, 40, 4, 1.0),

-- Instructor 25 (5 records)
(25, 42, 5, 2.0), (25, 44, 5, 3.0), (25, 46, 5, 2.0), (25, 48, 5, 1.0), (25, 50, 5, 1.0),

-- Instructor 26 (5 records)
(26, 52, 6, 2.0), (26, 54, 6, 3.0), (26, 56, 6, 2.0), (26, 58, 6, 1.0), (26, 60, 6, 1.0),

-- Instructor 27 (5 records)
(27, 62, 7, 2.0), (27, 64, 7, 3.0), (27, 66, 7, 2.0), (27, 68, 7, 1.0), (27, 70, 7, 1.0),

-- Instructor 28 (5 records)
(28, 72, 8, 2.0), (28, 74, 8, 3.0), (28, 76, 8, 2.0), (28, 78, 8, 1.0), (28, 80, 8, 1.0),

-- Instructor 29 (5 records)
(29, 82, 9, 2.0), (29, 84, 9, 3.0), (29, 86, 9, 2.0), (29, 88, 9, 1.0), (29, 90, 9, 1.0),

-- Instructor 30 (5 records)
(30, 92, 10, 2.0), (30, 94, 10, 3.0), (30, 96, 10, 2.0), (30, 98, 10, 1.0), (30, 100, 10, 1.0);
