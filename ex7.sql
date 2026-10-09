mysql> CREATE DATABASE CollegeDB;
Query OK, 1 row affected (0.01 sec)

mysql> USE CollegeDB;
Database changed
mysql> CREATE TABLE Departments (
    ->     DeptID INT PRIMARY KEY,
    ->     DeptName VARCHAR(100),
    ->     StudentCount INT,
    ->     TeacherCount INT,
    ->     Classrooms INT,
    ->     Email VARCHAR(100)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> INSERT INTO Departments VALUES
    -> (1, 'Computer Science', 200, 15, 5, 'cs@college.edu');
Query OK, 1 row affected (0.00 sec)

mysql> 
mysql> SAVEPOINT sp1;
Query OK, 0 rows affected (0.00 sec)

mysql> 
mysql> INSERT INTO Departments VALUES
    -> (2, 'Information Technology', 180, 12, 4, 'it@college.edu');
Query OK, 1 row affected (0.00 sec)

mysql> 
mysql> SAVEPOINT sp2;
Query OK, 0 rows affected (0.00 sec)

mysql> INSERT INTO Departments VALUES
    -> (3, 'Cyber Security', 150, 10, 6, 'cyber@college.edu');
Query OK, 1 row affected (0.00 sec)

mysql> SAVEPOINT sp3;
Query OK, 0 rows affected (0.01 sec)

mysql> INSERT INTO Departments VALUES
    -> (4, 'Electronics', 150, 10, 6, 'ece@college.edu');
Query OK, 1 row affected (0.00 sec)

mysql> SELECT * FROM Departments;
+--------+------------------------+--------------+--------------+------------+-------------------+
| DeptID | DeptName               | StudentCount | TeacherCount | Classrooms | Email             |
+--------+------------------------+--------------+--------------+------------+-------------------+
|      1 | Computer Science       |          200 |           15 |          5 | cs@college.edu    |
|      2 | Information Technology |          180 |           12 |          4 | it@college.edu    |
|      3 | Cyber Security         |          150 |           10 |          6 | cyber@college.edu |
|      4 | Electronics            |          150 |           10 |          6 | ece@college.edu   |
+--------+------------------------+--------------+--------------+------------+-------------------+
4 rows in set (0.00 sec)

mysql> UPDATE Departments
    -> SET StudentCount = 220
    -> WHERE DeptID = 1;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> UPDATE Departments
    -> SET StudentCount = 190
    -> WHERE DeptID = 2;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SAVEPOINT sp4;
Query OK, 0 rows affected (0.00 sec)

mysql> ROLLBACK TO sp2;
Query OK, 0 rows affected (0.00 sec)

mysql> 
mysql> SELECT * FROM Departments;
+--------+------------------------+--------------+--------------+------------+----------------+
| DeptID | DeptName               | StudentCount | TeacherCount | Classrooms | Email          |
+--------+------------------------+--------------+--------------+------------+----------------+
|      1 | Computer Science       |          200 |           15 |          5 | cs@college.edu |
|      2 | Information Technology |          180 |           12 |          4 | it@college.edu |
+--------+------------------------+--------------+--------------+------------+----------------+
2 rows in set (0.00 sec)

mysql> 
mysql> 
mysql> INSERT INTO Departments VALUES
    -> (5, 'Mechanical', 160, 11, 7, 'mech@college.edu');
Query OK, 1 row affected (0.00 sec)

mysql> 
mysql> 
mysql> DELETE FROM Departments
    -> WHERE DeptID = 2;
Query OK, 1 row affected (0.00 sec)

mysql> 
mysql> COMMIT;
Query OK, 0 rows affected (0.00 sec)

mysql> CREATE USER 'dept_user'@'localhost'
    -> IDENTIFIED BY 'pass123';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT SELECT, INSERT
    -> ON CollegeDB.Departments
    -> TO 'dept_user'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> USE CollegeDB;
Database changed
mysql> 
mysql> SELECT * FROM Departments;
+--------+------------------+--------------+--------------+------------+------------------+
| DeptID | DeptName         | StudentCount | TeacherCount | Classrooms | Email            |
+--------+------------------+--------------+--------------+------------+------------------+
|      1 | Computer Science |          200 |           15 |          5 | cs@college.edu   |
|      5 | Mechanical       |          160 |           11 |          7 | mech@college.edu |
+--------+------------------+--------------+--------------+------------+------------------+
2 rows in set (0.00 sec)

mysql> 
mysql> 
mysql> INSERT INTO Departments VALUES
    -> (6, 'Artificial Intelligence', 140, 9, 4, 'ai@college.edu');
Query OK, 1 row affected (0.01 sec)

mysql> 
mysql> DELETE FROM Departments
    -> WHERE DeptID = 1;
Query OK, 1 row affected (0.01 sec)

mysql> 
mysql> GRANT DELETE, UPDATE
    -> ON CollegeDB.Departments
    -> TO 'dept_user'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> REVOKE DELETE, INSERT, UPDATE
    -> ON CollegeDB.Departments
    -> FROM 'dept_user'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> 
mysql> DROP USER 'dept_user'@'localhost';
Query OK, 0 rows affected (0.01 sec)
