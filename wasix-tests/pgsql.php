<?php

require_once "util.php";

class PgSqlConnectionInfo
{
    public $host;
    public $port;
    public $username;
    public $password;

    public static function read_from_env()
    {
        $result = new PgSqlConnectionInfo();
        $result->host = get_env_or_fail("PGSQL_HOST");
        $result->port = get_env_or_default("PGSQL_PORT", 5432);
        $result->username = get_env_or_fail("PGSQL_USERNAME");
        $result->password = get_env_or_fail("PGSQL_PASSWORD");
        return $result;
    }
}

function test_pgsql_db_pdo()
{
    $conn_info = PgSqlConnectionInfo::read_from_env();
    $pdo = new \PDO("pgsql:host=$conn_info->host:$conn_info->port", $conn_info->username, $conn_info->password);
    if ($pdo == null) {
        throw new Exception("Failed to connect to PgSql DB", 1);
    }

    $dbname = "php_test_" . random_int(0, PHP_INT_MAX);
    $pdo->exec("CREATE DATABASE $dbname");

    $pdo = new \PDO("pgsql:host=$conn_info->host:$conn_info->port;dbname=$dbname", $conn_info->username, $conn_info->password);
    if ($pdo == null) {
        throw new Exception("Failed to connect to PgSql DB", 1);
    }

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

function test_pgsql_db()
{
    $conn_info = PgSqlConnectionInfo::read_from_env();

    $db = pg_connect("host=$conn_info->host:$conn_info->port user=$conn_info->username password=$conn_info->password")
        or die('Could not connect to PgSql database: ' . pg_last_error());

    $dbname = "php_test_" . random_int(0, PHP_INT_MAX);
    pg_exec($db, "CREATE DATABASE $dbname");
    pg_close($db);

    $db = pg_connect("host=$conn_info->host:$conn_info->port dbname=$dbname user=$conn_info->username password=$conn_info->password")
        or die('Could not connect to PgSql database: ' . pg_last_error());


    pg_exec($db, 'CREATE TABLE T (
                  id INTEGER PRIMARY KEY,
                  txt TEXT NOT NULL);');

    pg_exec($db, "INSERT INTO T VALUES (1, 'foo');");
    pg_exec($db, "INSERT INTO T VALUES (2, 'bar');");

    $result = pg_query($db, 'SELECT * from T');

    $row = pg_fetch_assoc($result);
    assert($row['id'] == 1);
    assert($row['txt'] == 'foo');

    $row = pg_fetch_assoc($result);
    assert($row['id'] == 2);
    assert($row['txt'] == 'bar');

    assert(!$row = pg_fetch_assoc($result));

}