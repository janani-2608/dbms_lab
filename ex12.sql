mysql> CREATE DATABASE role_based_demo;
Query OK, 1 row affected (0.01 sec)

mysql> CREATE DATABASE analytics_db;
Query OK, 1 row affected (0.07 sec)

mysql> USE role_based_demo;
Database changed

mysql> CREATE TABLE users (
    ->     id INT PRIMARY KEY,
    ->     name VARCHAR(50),
    ->     role VARCHAR(30)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> USE analytics_db;
Database changed

mysql> CREATE TABLE reports (
    ->     report_id INT PRIMARY KEY,
    ->     report_name VARCHAR(100),
    ->     created_on DATE
    -> );
Query OK, 0 rows affected (0.09 sec)

mysql> CREATE ROLE 'system_admin';
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE ROLE 'data_analyst_role';
Query OK, 0 rows affected (0.00 sec)

mysql> CREATE ROLE 'read_only_user';
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE USER 'sysadmin'@'localhost' IDENTIFIED BY 'password123';
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'password123';
Query OK, 0 rows affected (0.02 sec)

mysql> CREATE USER 'readonly1'@'localhost' IDENTIFIED BY 'password123';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT ALL PRIVILEGES ON role_based_demo.* TO 'system_admin';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT ALL PRIVILEGES ON analytics_db.* TO 'system_admin';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT SELECT, UPDATE ON role_based_demo.users TO 'data_analyst_role';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT SELECT ON analytics_db.reports TO 'data_analyst_role';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT SELECT ON role_based_demo.users TO 'read_only_user';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT 'system_admin' TO 'sysadmin'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT 'data_analyst_role' TO 'data_analyst'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT 'read_only_user' TO 'readonly1'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql> SET DEFAULT ROLE ALL TO 'sysadmin'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> SET DEFAULT ROLE 'data_analyst_role' TO 'data_analyst'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> SET DEFAULT ROLE 'read_only_user' TO 'readonly1'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql> USE role_based_demo;
Database changed

mysql> CREATE VIEW analyst_view AS
    -> SELECT id, name
    -> FROM users
    -> WHERE role = 'Analyst';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT SELECT ON role_based_demo.analyst_view TO 'data_analyst_role';
Query OK, 0 rows affected (0.00 sec)

mysql> DELIMITER //
mysql> CREATE PROCEDURE add_user(
    ->     IN uid INT,
    ->     IN uname VARCHAR(50),
    ->     IN urole VARCHAR(30)
    -> )
    -> BEGIN
    ->     INSERT INTO role_based_demo.users
    ->     VALUES (uid, uname, urole);
    -> END //
Query OK, 0 rows affected (0.01 sec)

mysql> DELIMITER ;
mysql> GRANT EXECUTE ON PROCEDURE role_based_demo.add_user TO 'system_admin';
Query OK, 0 rows affected (0.01 sec)

mysql> REVOKE UPDATE ON role_based_demo.users FROM 'data_analyst_role';
Query OK, 0 rows affected (0.00 sec)

mysql> CREATE TABLE audit_log (
    ->     action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->     user_name VARCHAR(50),
    ->     action_performed VARCHAR(100)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> DELIMITER //
mysql> CREATE TRIGGER log_insert
    -> AFTER INSERT ON users
    -> FOR EACH ROW
    -> BEGIN
    ->     INSERT INTO audit_log (user_name, action_performed)
    ->     VALUES (
    ->         CURRENT_USER(),
    ->         CONCAT('Inserted user: ', NEW.name)
    ->     );
    -> END //
Query OK, 0 rows affected (0.01 sec)

mysql> DELIMITER ;
mysql> CALL add_user(1, 'John Doe', 'Admin');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO analytics_db.reports VALUES (1, 'Monthly Report', CURDATE());
Query OK, 1 row affected (0.01 sec)

mysql> SELECT * FROM analyst_view;
Empty set (0.00 sec)

mysql> UPDATE role_based_demo.users SET name = 'Updated Analyst' WHERE id = 1;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> DELETE FROM role_based_demo.users WHERE id = 1;
Query OK, 1 row affected (0.00 sec)

mysql> SELECT * FROM role_based_demo.users;
Empty set (0.00 sec)

mysql> INSERT INTO role_based_demo.users VALUES (2, 'Test', 'User');
Query OK, 1 row affected (0.01 sec)

mysql> exit
Bye
