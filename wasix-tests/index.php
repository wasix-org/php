<?php

require ("./curl.php");
require ("./gd.php");
require ("./mysql.php");
require ("./pgsql.php");
require ("./sqlite.php");
require ("./ssl-over-fopen.php");

switch ($_GET["test"]) {
    case "sqlite-pdo":
        test_sqlite_db_pdo();
        break;
    case "sqlite":
        test_sqlite_db();
        break;
    case "mysql-pdo":
        test_mysql_db_pdo();
        break;
    case "mysql":
        test_mysql_db();
        break;
    case "pgsql-pdo":
        test_pgsql_db_pdo();
        break;
    case "pgsql":
        test_pgsql_db();
        break;
    case "ssl-over-fopen":
        test_ssl_over_fopen();
        break;
    case "curl":
        test_curl();
        break;
    case "gd":
        test_gd();
        break;
    default:
        echo "Unknown test\n";
        exit;
}

echo ("Success\n");