USE MaharaProject
GO

-- 1. Trigger: Students must be at least 18
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