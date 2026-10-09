mysql> CREATE DATABASE CompanyDB;
Query OK, 1 row affected (0.01 sec)

mysql> USE CompanyDB;
Database changed
mysql> CREATE TABLE Employees (
    ->     EmpID INT PRIMARY KEY,
    ->     FirstName VARCHAR(30),
    ->     LastName VARCHAR(30),
    ->     Salary DECIMAL(10,2),
    ->     Department VARCHAR(30)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE TABLE Attendance (
    ->     AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    ->     EmpID INT,
    ->     Date DATE,
    ->     Status ENUM('Present', 'Absent'),
    ->     FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> 
mysql> INSERT INTO Employees VALUES
    -> (1, 'Alice', 'Thomas', 55000.00, 'HR'),
    -> (2, 'Bob', 'Williams', 62000.00, 'IT'),
    -> (3, 'Charlie', 'Smith', 47000.00, 'Finance'),
    -> (4, 'Daisy', 'Johnson', 50000.00, 'IT');
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Attendance (EmpID, Date, Status) VALUES
    -> (1, '2025-08-01', 'Present'),
    -> (2, '2025-08-01', 'Absent'),
    -> (3, '2025-08-01', 'Present'),
    -> (4, '2025-08-01', 'Present'),
    -> (2, '2025-08-02', 'Present');
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> 
mysql> CREATE VIEW IT_Employees AS
    -> SELECT EmpID,
    ->        CONCAT(FirstName, ' ', LastName) AS FullName,
    ->        Salary
    -> FROM Employees
    -> WHERE Department = 'IT';
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT * FROM IT_Employees;
+-------+---------------+----------+
| EmpID | FullName      | Salary   |
+-------+---------------+----------+
|     2 | Bob Williams  | 62000.00 |
|     4 | Daisy Johnson | 50000.00 |
+-------+---------------+----------+
2 rows in set (0.00 sec)

mysql> UPDATE IT_Employees
    -> SET Salary = Salary + 5000
    -> WHERE FullName = 'Bob Williams';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> 
mysql> SELECT * FROM IT_Employees;
+-------+---------------+----------+
| EmpID | FullName      | Salary   |
+-------+---------------+----------+
|     2 | Bob Williams  | 67000.00 |
|     4 | Daisy Johnson | 50000.00 |
+-------+---------------+----------+
2 rows in set (0.00 sec)

mysql> DELIMITER //
mysql> 
mysql> CREATE PROCEDURE GetSalaryRange(
    ->     IN minSal DECIMAL(10,2),
    ->     IN maxSal DECIMAL(10,2)
    -> )
    -> BEGIN
    ->     SELECT EmpID,
    ->            CONCAT(FirstName, ' ', LastName) AS FullName,
    ->            Salary
    ->     FROM Employees
    ->     WHERE Salary BETWEEN minSal AND maxSal;
    -> END //
Query OK, 0 rows affected (0.01 sec)

mysql> 
mysql> DELIMITER ;
mysql> CREATE VIEW NameDetails AS
    -> SELECT EmpID,
    ->        CONCAT(FirstName, ' ', LastName) AS FullName,
    ->        LENGTH(CONCAT(FirstName, ' ', LastName)) AS NameLength
    -> FROM Employees;
Query OK, 0 rows affected (0.02 sec)

mysql> 
mysql> CALL GetSalaryRange(48000.00, 60000.00);
+-------+---------------+----------+
| EmpID | FullName      | Salary   |
+-------+---------------+----------+
|     1 | Alice Thomas  | 55000.00 |
|     4 | Daisy Johnson | 50000.00 |
+-------+---------------+----------+
2 rows in set (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

mysql> CREATE PROCEDURE CheckAboveAverageSalary(IN emp_id INT)
    -> BEGIN
    ->     DECLARE empSal DECIMAL(10,2);
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '' at line 3
mysql>     DECLARE avgSal DECIMAL(10,2);
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'DECLARE avgSal DECIMAL(10,2)' at line 1
mysql>  SELECT Salary INTO empSal
    ->     FROM Employees
    ->     WHERE EmpID = emp_id;
ERROR 1327 (42000): Undeclared variable: empSal
mysql>   SELECT AVG(Salary) INTO avgSal
    ->     FROM Employees;
ERROR 1327 (42000): Undeclared variable: avgSal
mysql> 
mysql>     IF empSal > avgSal THEN
    ->         SELECT CONCAT(
    ->             'Employee ', emp_id,
    ->             ' has salary above average.'
    ->         ) AS Message;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'IF empSal > avgSal THEN
        SELECT CONCAT(
            'Employee ', emp_id,
' at line 1
mysql>     ELSE
    ->         SELECT CONCAT(
    ->             'Employee ', emp_id,
    ->             ' has salary below average.'
    ->         ) AS Message;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'ELSE
        SELECT CONCAT(
            'Employee ', emp_id,
            ' has s' at line 1
mysql>     END IF;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'END IF' at line 1
mysql> END //
    -> 
    -> DELIMITER ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'END //

DELIMITER' at line 1
mysql> 
mysql> CALL CheckAboveAverageSalary(2);
ERROR 1305 (42000): PROCEDURE CompanyDB.CheckAboveAverageSalary does not exist
mysql> 
mysql> DELIMITER //
mysql> 
mysql> CREATE FUNCTION AttendanceDays(emp_id INT)
    -> RETURNS INT
    -> DETERMINISTIC
    -> BEGIN
    ->     DECLARE countDays INT;
    -> 
    ->     SELECT COUNT(*)
    ->     INTO countDays
    ->     FROM Attendance
    ->     WHERE EmpID = emp_id
    ->       AND Status = 'Present';
    -> 
    ->     RETURN countDays;
    -> END //
Query OK, 0 rows affected (0.02 sec)

mysql> 
mysql> DELIMITER ;
mysql> 
mysql> SELECT EmpID, AttendanceDays(EmpID) AS PresentDays FROM Employees;
+-------+-------------+
| EmpID | PresentDays |
+-------+-------------+
|     1 |           1 |
|     2 |           1 |
|     3 |           1 |
|     4 |           1 |
+-------+-------------+
4 rows in set (0.00 sec)

mysql> ^C
mysql> 
