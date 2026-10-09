mysql> CREATE DATABASE SecurityDB1;
Query OK, 1 row affected (0.02 sec)

mysql> CREATE DATABASE SecurityDB2;
Query OK, 1 row affected (0.01 sec)

mysql> USE SecurityDB1;
Database changed

mysql> CREATE TABLE Users (
    ->     user_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     username VARCHAR(100),
    ->     password_encrypted VARBINARY(255),
    ->     secret_key VARCHAR(50)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> USE SecurityDB2;
Database changed

mysql> CREATE TABLE Messages (
    ->     msg_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     original_message VARCHAR(255),
    ->     encrypted_message VARBINARY(255),
    ->     decrypted_message VARCHAR(255),
    ->     hash_value VARCHAR(255),
    ->     base64_encoded TEXT
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> USE SecurityDB1;
Database changed

mysql> INSERT INTO Users (
    ->     username,
    ->     password_encrypted,
    ->     secret_key
    -> ) VALUES (
    ->     'Allen',
    ->     AES_ENCRYPT('mySecretPass123', 'encryption_key_123'),
    ->     'encryption_key_123'
    -> );
Query OK, 1 row affected (0.01 sec)

mysql> SELECT
    ->     user_id,
    ->     username,
    ->     HEX(password_encrypted) AS Encrypted_Password
    -> FROM Users;
+---------+----------+----------------------------------+
| user_id | username | Encrypted_Password               |
+---------+----------+----------------------------------+
|       1 | Allen    | 18239F770FC516B8072F489A2AC391D4 |
+---------+----------+----------------------------------+
1 row in set (0.00 sec)

mysql> SELECT
    ->     username,
    ->     CAST(AES_DECRYPT(password_encrypted, secret_key) AS CHAR) AS Decrypted_Password
    -> FROM Users;
+----------+--------------------+
| username | Decrypted_Password |
+----------+--------------------+
| Allen    | mySecretPass123    |
+----------+--------------------+
1 row in set (0.00 sec)

mysql> USE SecurityDB2;
Database changed

mysql> INSERT INTO Messages (
    ->     original_message,
    ->     encrypted_message,
    ->     decrypted_message,
    ->     hash_value,
    ->     base64_encoded
    -> ) VALUES (
    ->     'Secret Message',
    ->     AES_ENCRYPT('Secret Message', 'key123'),
    ->     CAST(AES_DECRYPT(
    ->         AES_ENCRYPT('Secret Message', 'key123'),
    ->         'key123'
    ->     ) AS CHAR),
    ->     SHA2('Secret Message', 256),
    ->     TO_BASE64('Secret Message')
    -> );
Query OK, 1 row affected (0.01 sec)

mysql> SELECT
    ->     msg_id,
    ->     original_message,
    ->     HEX(encrypted_message) AS Encrypted_Hex,
    ->     decrypted_message,
    ->     hash_value,
    ->     base64_encoded,
    ->     CAST(FROM_BASE64(base64_encoded) AS CHAR) AS Base64_Decoded
    -> FROM Messages;
+--------+------------------+----------------------------------+-------------------+------------------------------------------------------------------+----------------------+----------------+
| msg_id | original_message | Encrypted_Hex                    | decrypted_message | hash_value                                                       | base64_encoded       | Base64_Decoded |
+--------+------------------+----------------------------------+-------------------+------------------------------------------------------------------+----------------------+----------------+
|      1 | Secret Message   | 9E5050843695055524E47AFFDDF26766 | Secret Message    | 0c48bdfc98b783b5d8e0f550c8296b3dcc685096109f4cbaf42bf9f3d815de21 | U2VjcmV0IE1lc3NhZ2U= | Secret Message |
+--------+------------------+----------------------------------+-------------------+------------------------------------------------------------------+----------------------+----------------+
1 row in set (0.00 sec)

mysql> SELECT MD5('Secret Message') AS MD5_Hash;
+----------------------------------+
| MD5_Hash                         |
+----------------------------------+
| 54b0581b96c2e04197a9f4f50f1e64da |
+----------------------------------+
1 row in set (0.00 sec)

mysql> SELECT SHA2('Secret Message', 512) AS SHA512_Hash;
+--------------------------------------------------------------------------------------------------------------------------------+
| SHA512_Hash                                                                                                                    |
+--------------------------------------------------------------------------------------------------------------------------------+
| 0c36e2f06209dd15596988e2269397f4e6272f08b792ed6bf7ae3196fe766d65d0474264c6da2614f27f3be3671ad32bc5e5b656a73d984316e59c49eed07ba8 |
+--------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT
    ->     TO_BASE64('Confidential Data') AS Encoded,
    ->     CAST(FROM_BASE64(
    ->         TO_BASE64('Confidential Data')
    ->     ) AS CHAR) AS Decoded;
+--------------------------+-------------------+
| Encoded                  | Decoded           |
+--------------------------+-------------------+
| Q29uZmlkZW50aWFsIERhdGE= | Confidential Data |
+--------------------------+-------------------+
1 row in set (0.00 sec)

mysql> exit
Bye
