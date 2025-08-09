# MharaTech Project - Educational Management System Database

## Overview
MharaTech is a comprehensive educational management system database designed to handle academic institutions' core operations. The system manages departments, instructors, students, courses, examinations, and academic performance tracking with automated exam generation capabilities.

## Database Structure

### Core Entities
- **Department**: Academic departments with locations and management hierarchy
- **Instructor**: Faculty members with salary and department assignments
- **Student**: Student records with age calculation and department enrollment
- **Course**: Academic courses with credit hours and grading parameters
- **Questions**: Examination questions with various types (MCQ, True/False, etc.)
- **Exam**: Examination sessions with automated generation
- **StudentAnswer**: Student responses and performance tracking
- **InstructorEvaluation**: Course and instructor evaluation system

### Key Features
- ✅ **Multi-location Support**: Departments across Alex, Cairo, Mansora, and Zagazig
- ✅ **Automated Exam Generation**: Dynamic exam creation with question type distribution
- ✅ **Secure Answer Submission**: Stored procedures for student answer processing
- ✅ **Flexible Course Management**: Configurable credit hours (20-100) and grading scales
- ✅ **Performance Analytics**: Student grades and instructor evaluations
- ✅ **Data Integrity**: Extensive foreign key relationships and constraints
- ✅ **Age Validation**: Automatic age calculation with 18+ enrollment requirement

## Files Description

| File | Description |
|------|-------------|
| `Database Creation.sql` | Complete database schema with tables, constraints, and sample data |
| `Database Stored Procedures.sql` | Automated exam generation and answer submission procedures |
| `Database Triggers.sql` | Business logic triggers for data validation |
| `EERD.drawio` | Enhanced Entity-Relationship Diagram (editable) |
| `EERD.png` | Enhanced Entity-Relationship Diagram (image) |
| `Mapping.drawio` | Database mapping diagram (editable) |
| `Mapping.png` | Database mapping diagram (image) |

## Stored Procedures

### Exam_Generation_SP
Automatically generates exams with specified question distribution:
```sql
EXEC Exam_Generation_SP 
    @Course_Name = 'Database Systems',
    @Questions = 10,
    @TrueFalse = 5,
    @MCQ = 5;
```

### Student_Answer_SP
Handles secure student answer submission and grading:
```sql
EXEC Student_Answer_SP 
    @StudentId = 1,
    @ExamId = 1,
    @Answers = 'A,B,True,False,C';
```

## Database Schema

### Main Tables
```sql
Department (DepartmentId, Name, Location, ManagerId)
Instructor (InstructorId, Name, Salary, DepartmentId)
Student (StudentId, Name, DateOfBirth, DepartmentId, Age)
Course (CourseId, Title, Hours, MinDegree, MaxDegree, DepartmentId, InstructorId)
Questions (QuestionId, Title, Grade, Type, CorrectAnswer, CourseId)
Exam (ExamId, CourseId, QuestionId)
StudentAnswer (StudentId, QuestionId, ExamId, Grade)
InstructorEvaluation (InstructorId, StudentId, CourseId, Grade)
```

### Business Rules
- Students must be at least 18 years old (enforced by trigger)
- Course hours must be between 20-100
- Maximum degree cannot exceed 150
- Exam generation validates question availability
- Answer submission includes automatic grading

## Installation & Setup

### Prerequisites
- Microsoft SQL Server 2016 or later
- SQL Server Management Studio (SSMS) recommended

### Installation Steps
1. **Create Database Schema**
   ```sql
   sqlcmd -S your_server -i "Database Creation.sql"
   ```

2. **Install Stored Procedures**
   ```sql
   sqlcmd -S your_server -i "Database Stored Procedures.sql"
   ```

3. **Apply Triggers**
   ```sql
   sqlcmd -S your_server -i "Database Triggers.sql"
   ```

4. **Verify Installation**
   ```sql
   USE MaharaProject;
   SELECT COUNT(*) FROM Student;
   ```

## Usage Examples

### Generate Random Exam
```sql
-- Create exam with 15 questions (10 MCQ, 5 True/False)
EXEC Exam_Generation_SP 
    @Course_Name = 'Computer Science',
    @Questions = 15,
    @TrueFalse = 5,
    @MCQ = 10;
```

### Submit Student Answers
```sql
-- Submit answers for a student
EXEC Student_Answer_SP 
    @StudentId = 25,
    @ExamId = 3,
    @Answers = 'A,True,B,False,C,True,A,B,False,C';
```

### Query Performance Analytics
```sql
-- Get student performance summary
SELECT s.Name, AVG(sa.Grade) as AverageGrade
FROM Student s
JOIN StudentAnswer sa ON s.StudentId = sa.StudentId
GROUP BY s.Name, s.StudentId
ORDER BY AverageGrade DESC;
```

### Department Statistics
```sql
-- Department enrollment and performance
SELECT d.Name, 
       COUNT(DISTINCT s.StudentId) as Students,
       AVG(sa.Grade) as AvgPerformance
FROM Department d
LEFT JOIN Student s ON d.DepartmentId = s.DepartmentId
LEFT JOIN StudentAnswer sa ON s.StudentId = sa.StudentId
GROUP BY d.Name, d.DepartmentId;
```

## Sample Data
The database includes:
- 15 Departments across multiple locations
- 20 Instructors with varying specializations
- 100+ Students with demographic data
- 20 Courses covering diverse subjects
- 200+ Questions (MCQ, True/False, Essay types)
- Complete examination and performance records

## Security Features
- Encrypted stored procedures
- Parameter validation and sanitization
- Transaction-based operations
- Error handling and rollback mechanisms

## Contributing
1. Fork the repository
2. Create a feature branch
3. Test stored procedures with sample data
4. Validate trigger functionality
5. Submit a pull request

## License
Educational project for database design and development coursework.

## Support
For technical support or questions about the MharaTech system, refer to the documentation or contact the development team.

---
*Database Version: 1.0 | Last Updated: August 2025*
