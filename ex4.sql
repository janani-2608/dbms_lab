MariaDB [(none)]> 
MariaDB [(none)]> CREATE DATABASE LibraryDB;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> USE LibraryDB;
Database changed
MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> CREATE TABLE Authors (
    ->     AuthorID INT PRIMARY KEY,
    ->     Name VARCHAR(100)
    -> );
Query OK, 0 rows affected (0.022 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> CREATE TABLE Books (
    ->     BookID INT PRIMARY KEY,
    ->     Title VARCHAR(150),
    ->     AuthorID INT,
    ->     FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
    -> );
Query OK, 0 rows affected (0.019 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> CREATE TABLE Borrowers (
    ->     BorrowerID INT PRIMARY KEY,
    ->     Name VARCHAR(100)
    -> );
Query OK, 0 rows affected (0.015 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> CREATE TABLE BookBorrowing (
    ->     BookID INT,
    ->     BorrowerID INT,
    ->     BorrowedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->     FOREIGN KEY (BookID) REFERENCES Books(BookID),
    ->     FOREIGN KEY (BorrowerID) REFERENCES Borrowers(BorrowerID)
    -> );
Query OK, 0 rows affected (0.025 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> INSERT INTO Authors (AuthorID, Name)
    -> VALUES
    -> (1, 'J.K. Rowling'),
    -> (2, 'George Orwell'),
    -> (3, 'J.R.R. Tolkien');
Query OK, 3 rows affected (0.004 sec)
Records: 3  Duplicates: 0  Warnings: 0

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> INSERT INTO Books (BookID, Title, AuthorID)
    -> VALUES
    -> (101, 'Harry Potter and the Philosopher\'s Stone', 1),
    -> (102, '1984', 2),
    -> (103, 'The Hobbit', 3),
    -> (104, 'Harry Potter and the Chamber of Secrets', 1);
Query OK, 4 rows affected (0.003 sec)
Records: 4  Duplicates: 0  Warnings: 0

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> INSERT INTO Borrowers (BorrowerID, Name)
    -> VALUES
    -> (1, 'John Doe'),
    -> (2, 'Jane Smith'),
    -> (3, 'Alice Johnson');
Query OK, 3 rows affected (0.004 sec)
Records: 3  Duplicates: 0  Warnings: 0

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> INSERT INTO BookBorrowing (BookID, BorrowerID)
    -> VALUES
    -> (101, 1),
    -> (102, 2),
    -> (103, 3),
    -> (104, 1);
Query OK, 4 rows affected (0.004 sec)
Records: 4  Duplicates: 0  Warnings: 0

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> SELECT * FROM Authors;
+----------+----------------+
| AuthorID | Name           |
+----------+----------------+
|        1 | J.K. Rowling   |
|        2 | George Orwell  |
|        3 | J.R.R. Tolkien |
+----------+----------------+
3 rows in set (0.000 sec)

MariaDB [LibraryDB]> SELECT * FROM Books;
+--------+------------------------------------------+----------+
| BookID | Title                                    | AuthorID |
+--------+------------------------------------------+----------+
|    101 | Harry Potter and the Philosopher's Stone |        1 |
|    102 | 1984                                     |        2 |
|    103 | The Hobbit                               |        3 |
|    104 | Harry Potter and the Chamber of Secrets  |        1 |
+--------+------------------------------------------+----------+
4 rows in set (0.000 sec)

MariaDB [LibraryDB]> SELECT * FROM Borrowers;
+------------+---------------+
| BorrowerID | Name          |
+------------+---------------+
|          1 | John Doe      |
|          2 | Jane Smith    |
|          3 | Alice Johnson |
+------------+---------------+
3 rows in set (0.000 sec)

MariaDB [LibraryDB]> SELECT * FROM BookBorrowing;
+--------+------------+---------------------+
| BookID | BorrowerID | BorrowedDate        |
+--------+------------+---------------------+
|    101 |          1 | 2026-08-16 13:12:52 |
|    102 |          2 | 2026-08-16 13:12:52 |
|    103 |          3 | 2026-08-16 13:12:52 |
|    104 |          1 | 2026-08-16 13:12:52 |
+--------+------------+---------------------+
4 rows in set (0.000 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> SELECT UPPER(b.Title) AS Title, a.Name AS Author
    -> FROM Books b
    -> INNER JOIN Authors a ON b.AuthorID = a.AuthorID;
+------------------------------------------+----------------+
| Title                                    | Author         |
+------------------------------------------+----------------+
| HARRY POTTER AND THE PHILOSOPHER'S STONE | J.K. Rowling   |
| 1984                                     | George Orwell  |
| THE HOBBIT                               | J.R.R. Tolkien |
| HARRY POTTER AND THE CHAMBER OF SECRETS  | J.K. Rowling   |
+------------------------------------------+----------------+
4 rows in set (0.000 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> SELECT Name,
    ->        (SELECT COUNT(*)
    ->         FROM Books
    ->         WHERE Books.AuthorID = Authors.AuthorID) AS NumberOfBooks
    -> FROM Authors;
+----------------+---------------+
| Name           | NumberOfBooks |
+----------------+---------------+
| J.K. Rowling   |             2 |
| George Orwell  |             1 |
| J.R.R. Tolkien |             1 |
+----------------+---------------+
3 rows in set (0.000 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> SELECT Title
    -> FROM Books
    -> WHERE BookID IN (
    ->     SELECT BookID
    ->     FROM BookBorrowing
    ->     WHERE BorrowerID = (
    ->         SELECT BorrowerID
    ->         FROM Borrowers
    ->         WHERE Name = 'John Doe'
    ->     )
    -> );
+------------------------------------------+
| Title                                    |
+------------------------------------------+
| Harry Potter and the Philosopher's Stone |
| Harry Potter and the Chamber of Secrets  |
+------------------------------------------+
2 rows in set (0.000 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> SELECT b.Title,
    ->        COALESCE(bb_data.Name, 'Not Borrowed') AS Borrower
    -> FROM Books b
    -> LEFT JOIN (
    ->     SELECT bb.BookID, br.Name
    ->     FROM BookBorrowing bb
    ->     JOIN Borrowers br ON bb.BorrowerID = br.BorrowerID
    -> ) AS bb_data ON b.BookID = bb_data.BookID;
+------------------------------------------+---------------+
| Title                                    | Borrower      |
+------------------------------------------+---------------+
| Harry Potter and the Philosopher's Stone | John Doe      |
| 1984                                     | Jane Smith    |
| The Hobbit                               | Alice Johnson |
| Harry Potter and the Chamber of Secrets  | John Doe      |
+------------------------------------------+---------------+
4 rows in set (0.000 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> SELECT DISTINCT br.Name
    -> FROM Borrowers br
    -> WHERE EXISTS (
    ->     SELECT 1
    ->     FROM BookBorrowing bb
    ->     JOIN Books b ON bb.BookID = b.BookID
    ->     WHERE b.AuthorID = (
    ->         SELECT AuthorID
    ->         FROM Authors
    ->         WHERE Name = 'J.K. Rowling'
    ->     )
    ->     AND bb.BorrowerID = br.BorrowerID
    -> );
+----------+
| Name     |
+----------+
| John Doe |
+----------+
1 row in set (0.000 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> SELECT Title
    -> FROM Books
    -> WHERE EXISTS (
    ->     SELECT 1
    ->     FROM BookBorrowing bb
    ->     WHERE bb.BookID = Books.BookID
    -> );
+------------------------------------------+
| Title                                    |
+------------------------------------------+
| Harry Potter and the Philosopher's Stone |
| 1984                                     |
| The Hobbit                               |
| Harry Potter and the Chamber of Secrets  |
+------------------------------------------+
4 rows in set (0.000 sec)

MariaDB [LibraryDB]> 
MariaDB [LibraryDB]> SELECT Title
    -> FROM Books
    -> WHERE NOT EXISTS (
    ->     SELECT 1
    ->     FROM BookBorrowing bb
    ->     WHERE bb.BookID = Books.BookID
    -> );
