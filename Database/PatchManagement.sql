-- Table to store updates
CREATE TABLE Updates (
    Id INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(255),
    Description NVARCHAR(255),
    InstallDate DATETIME,
    Status NVARCHAR(50)
);

CREATE TABLE Logs (
    Id INT PRIMARY KEY IDENTITY,
    Timestamp DATETIME NOT NULL,
    LogType NVARCHAR(50),
    LogLevel NVARCHAR(20),
    Message NVARCHAR(MAX)
);


-- Table for compliance reporting
CREATE TABLE ComplianceReports (
    Id INT PRIMARY KEY IDENTITY,
    UpdateId INT NOT NULL,
    ComplianceStatus NVARCHAR(50),
    ReportDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UpdateId) REFERENCES Updates(Id)
);

-- Table for rollback actions
CREATE TABLE RollbackLogs (
    Id INT PRIMARY KEY IDENTITY,
    UpdateId INT NOT NULL,
    RollbackDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50),
    FOREIGN KEY (UpdateId) REFERENCES Updates(Id)
);

-- Index for faster queries
CREATE INDEX idx_UpdateTitle ON Updates (Title);
CREATE INDEX idx_RollbackDate ON RollbackLogs (RollbackDate);