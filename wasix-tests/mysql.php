<?php

require_once "util.php";

class MySqlConnectionInfo
{
    public $host;
    public $port;
    public $username;
    public $password;

    public static function read_from_env()
    {
        $result = new MySqlConnectionInfo();
        $result->host = get_env_or_fail("MYSQL_HOST");
        $result->port = get_env_or_default("MYSQL_PORT", 3306);
        $result->username = get_env_or_fail("MYSQL_USERNAME");
        $result->password = get_env_or_fail("MYSQL_PASSWORD");
        return $result;
    }
}

function test_mysql_db_pdo()
{
    $conn_info = MySqlConnectionInfo::read_from_env();
    $pdo = new \PDO("mysql:host=$conn_info->host:$conn_info->port", $conn_info->username, $conn_info->password);
    if ($pdo == null) {
        throw new Exception("Failed to connect to MySQL DB", 1);
    }

    $dbname = "php_test_" . random_int(0, PHP_INT_MAX);
    $pdo->exec("CREATE DATABASE $dbname");
    $pdo->exec("USE $dbname");

    $pdo->exec('CREATE TABLE T (
                id INTEGER PRIMARY KEY,
                txt TEXT NOT NULL);');

    $pdo->exec("INSERT INTO T VALUES (1, 'foo');");
    $pdo->exec("INSERT INTO T VALUES (2, 'bar');");

    $result = $pdo->query('SELECT * from T');

    $table = [];
    while ($row = $result->fetch()) {
        $table[$row['id']] = $row['txt'];
    }

    assert(count($table) == 2);
    assert($table[1] == 'foo');
    assert($table[2] == 'bar');
}

function test_mysql_db()
{
    $conn_info = MySqlConnectionInfo::read_from_env();
    $mysqli = mysqli_connect($conn_info->host, $conn_info->username, $conn_info->password, null, $conn_info->port);

    $dbname = "php_test_" . random_int(0, PHP_INT_MAX);
    $mysqli->execute_query("CREATE DATABASE $dbname");
    $mysqli->select_db($dbname);

    $mysqli->execute_query('CREATE TABLE T (
                            id INTEGER PRIMARY KEY,
                            txt TEXT NOT NULL);');

    $mysqli->execute_query("INSERT INTO T VALUES (1, 'foo');");
    $mysqli->execute_query("INSERT INTO T VALUES (2, 'bar');");

    $result = $mysqli->query('SELECT * from T');

    $row = $result->fetch_assoc();
    assert($row['id'] == 1);
    assert($row['txt'] == 'foo');

    $row = $result->fetch_assoc();
    assert($row['id'] == 2);
    assert($row['txt'] == 'bar');

    assert(!$result->fetch_assoc());
}