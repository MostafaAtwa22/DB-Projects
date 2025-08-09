CREATE PROC Exam_Generation_SP @Course_Name VARCHAR(30), @Questions int, @TrueFalse INT, @MCQ INT
WITH ENCRYPTION 
AS
BEGIN
    DECLARE @CourseId INT;
    DECLARE @ExamId INT;
    
    -- Validate input parameters
    IF @Questions <= 0 OR @TrueFalse < 0 OR @MCQ < 0 OR (@TrueFalse + @MCQ) <> @Questions
    BEGIN
        RAISERROR('Invalid question distribution. Total questions must equal sum of True/False and MCQ questions.', 16, 1);
        RETURN;
    END
    
    -- Get CourseId for the given course name
    SELECT @CourseId = CourseId 
    FROM Course 
    WHERE Title = @Course_Name;
    
    IF @CourseId IS NULL
    BEGIN
        RAISERROR('Course not found.', 16, 1);
        RETURN;
    END
    
    -- Check if there are enough questions of each type in the database
    DECLARE @AvailableTF INT, @AvailableMCQ INT;
    
    SELECT @AvailableTF = COUNT(*) 
    FROM Questions 
    WHERE CourseId = @CourseId AND Type = 'True/False';
    
    SELECT @AvailableMCQ = COUNT(*) 
    FROM Questions 
    WHERE CourseId = @CourseId AND Type = 'MCQ';
    
    IF @TrueFalse > @AvailableTF OR @MCQ > @AvailableMCQ
    BEGIN
        RAISERROR('Not enough questions of the requested types in the database.', 16, 1);
        RETURN;
    END
    
    -- Create a new exam
    INSERT INTO Exam (Titel)
    VALUES ('Random Exam - ' + @Course_Name + ' - ' + CONVERT(VARCHAR, GETDATE(), 120));
    
    SET @ExamId = SCOPE_IDENTITY();
    
    -- Insert True/False questions
    INSERT INTO Exam_Question (QuesionId, ExamId)
    SELECT TOP (@TrueFalse) QuesionId, @ExamId
    FROM Questions
    WHERE CourseId = @CourseId AND Type = 'True/False'
    ORDER BY NEWID(); -- Random order
    
    -- Insert MCQ questions
    INSERT INTO Exam_Question (QuesionId, ExamId)
    SELECT TOP (@MCQ) QuesionId, @ExamId
    FROM Questions
    WHERE CourseId = @CourseId AND Type = 'MCQ'
    ORDER BY NEWID(); -- Random order
    
    -- Return the generated exam details
    SELECT 
        e.ExamId,
        e.Titel AS ExamTitle,
        COUNT(eq.QuesionId) AS TotalQuestions,
        SUM(CASE WHEN q.Type = 'True/False' THEN 1 ELSE 0 END) AS TrueFalseQuestions,
        SUM(CASE WHEN q.Type = 'MCQ' THEN 1 ELSE 0 END) AS MCQQuestions
    FROM Exam e
    JOIN Exam_Question eq ON e.ExamId = eq.ExamId
    JOIN Questions q ON eq.QuesionId = q.QuesionId
    WHERE e.ExamId = @ExamId
    GROUP BY e.ExamId, e.Titel;
    
    -- Return the actual questions with choices
    SELECT 
        q.QuesionId,
        q.Title AS QuestionText,
        q.Type,
        q.Grade,
        c.Choices
    FROM Questions q
    JOIN Exam_Question eq ON q.QuesionId = eq.QuesionId
    LEFT JOIN Choices c ON q.QuesionId = c.QuesionId
    WHERE eq.ExamId = @ExamId
    ORDER BY q.Type DESC; -- True/False first, then MCQ
    
    PRINT 'Exam generated successfully.';
END

CREATE PROC Store_Exam_Answers_SP 
    @ExamId INT,
    @StudentId INT,
    @QuestionAnswers XML
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validate student exists
        IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentId = @StudentId)
        BEGIN
            RAISERROR('Student not found.', 16, 1);
            RETURN;
        END
        
        -- Validate exam exists
        IF NOT EXISTS (SELECT 1 FROM Exam WHERE ExamId = @ExamId)
        BEGIN
            RAISERROR('Exam not found.', 16, 1);
            RETURN;
        END
        
        -- Delete existing answers if any (to allow updates)
        DELETE FROM Student_Question_Answer 
        WHERE StudentId = @StudentId 
        AND QuesionId IN (
            SELECT QuesionId FROM Exam_Question WHERE ExamId = @ExamId
        );
        
        -- Insert new answers
        INSERT INTO Student_Question_Answer (StudentId, QuesionId, State)
        SELECT 
            @StudentId,
            x.q.value('@qid', 'INT') AS QuesionId,
            CASE 
                WHEN x.q.value('@answer', 'VARCHAR(MAX)') = q.[Correct answer] THEN 'Correct Answer'
                ELSE 'Wrong Answer'
            END AS State
        FROM 
            @QuestionAnswers.nodes('/answers/answer') AS x(q)
        JOIN Questions q ON x.q.value('@qid', 'INT') = q.QuesionId
        WHERE 
            q.QuesionId IN (SELECT QuesionId FROM Exam_Question WHERE ExamId = @ExamId);
        
        -- Store exam attempt
        IF NOT EXISTS (SELECT 1 FROM Student_Exam WHERE StudentId = @StudentId AND ExamId = @ExamId)
        BEGIN
            INSERT INTO Student_Exam (StudentId, ExamId, Degree)
            VALUES (@StudentId, @ExamId, 0); -- Initial degree is 0, will be updated by correction
        END
        
        COMMIT TRANSACTION;
        
        SELECT 'Answers stored successfully' AS Result;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

CREATE PROC Correct_Exam_SP
    @ExamId INT,
    @StudentId INT
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRY
        DECLARE @TotalScore DECIMAL(5,2) = 0;
        DECLARE @MaxPossibleScore DECIMAL(5,2) = 0;
        DECLARE @Percentage DECIMAL(5,2);
        DECLARE @CourseId INT;
        
        -- Validate student and exam
        IF NOT EXISTS (SELECT 1 FROM Student_Exam WHERE StudentId = @StudentId AND ExamId = @ExamId)
        BEGIN
            RAISERROR('Student exam attempt not found.', 16, 1);
            RETURN;
        END
        
        -- Get course ID from the exam questions
        SELECT TOP 1 @CourseId = q.CourseId
        FROM Exam_Question eq
        JOIN Questions q ON eq.QuesionId = q.QuesionId
        WHERE eq.ExamId = @ExamId;
        
        -- Calculate total score and max possible score
        SELECT 
            @TotalScore = SUM(q.Grade),
            @MaxPossibleScore = SUM(q.Grade)
        FROM Student_Question_Answer sqa
        JOIN Questions q ON sqa.QuesionId = q.QuesionId
        JOIN Exam_Question eq ON q.QuesionId = eq.QuesionId
        WHERE sqa.StudentId = @StudentId 
        AND eq.ExamId = @ExamId
        AND sqa.State = 'Correct Answer';
        
        -- Calculate percentage (handle division by zero)
        IF @MaxPossibleScore > 0
            SET @Percentage = (@TotalScore / @MaxPossibleScore) * 100;
        ELSE
            SET @Percentage = 0;
        
        -- Update student exam record with the calculated degree (percentage)
        UPDATE Student_Exam
        SET Degree = @Percentage
        WHERE StudentId = @StudentId AND ExamId = @ExamId;
        
        -- Return results with proper student information
        SELECT 
            @ExamId AS ExamNo,
            (SELECT Name FROM Student WHERE StudentId = @StudentId) AS StudentName,
            @StudentId AS StudentId,
            @TotalScore AS TotalScore,
            @MaxPossibleScore AS MaxPossibleScore,
            @Percentage AS Percentage,
            CASE 
                WHEN @Percentage >= 70 THEN 'Pass'
                ELSE 'Fail'
            END AS Result;
            
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END