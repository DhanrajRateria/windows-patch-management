-- Create a table to store updates
CREATE TABLE Updates (
    Id INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(255),
    Description NVARCHAR(255),
    InstallDate DATETIME,
    Status NVARCHAR(50)
);

-- Create a table for compliance reporting
CREATE TABLE ComplianceReports (
    Id INT PRIMARY KEY IDENTITY,
    UpdateId INT,
    ComplianceStatus NVARCHAR(50),
    ReportDate DATETIME,
    FOREIGN KEY (UpdateId) REFERENCES Updates(Id)
);

-- Create a table for rollback actions
CREATE TABLE RollbackLogs (
    Id INT PRIMARY KEY IDENTITY,
    UpdateId INT,
    RollbackDate DATETIME,
    Status NVARCHAR(50),
    FOREIGN KEY (UpdateId) REFERENCES Updates(Id)
);
