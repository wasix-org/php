<?php

function test_sqlite_db_pdo()
{
    $pdo = new \PDO("sqlite:/tmp/db-pdo.sqlite");
    if ($pdo == null) {
        throw new Exception("Failed to connect to sqlite DB", 1);
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

    assert($table[1] == 'foo');
    assert($table[2] == 'bar');
}

function test_sqlite_db()
{
    $db = new SQLite3('/tmp/db.sqlite', SQLITE3_OPEN_CREATE | SQLITE3_OPEN_READWRITE);
    $db->enableExceptions(true);
    $db->exec('CREATE TABLE T (
               id INTEGER PRIMARY KEY,
               txt TEXT NOT NULL);');

    $db->exec("INSERT INTO T VALUES (1, 'foo');");
    $db->exec("INSERT INTO T VALUES (2, 'bar');");

    $result = $db->query('SELECT * from T');

    $row = $result->fetchArray(SQLITE3_ASSOC);
    assert($row['id'] == 1);
    assert($row['txt'] == 'foo');

    $row = $result->fetchArray(SQLITE3_ASSOC);
    assert($row['id'] == 2);
    assert($row['txt'] == 'bar');
}