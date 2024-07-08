<?php

require ("./curl.php");
require ("./gd.php");
require ("./sqlite.php");
require ("./ssl-over-fopen.php");

switch ($_GET["test"]) {
    case "sqlite-pdo":
        test_sqlite_db_pdo();
        break;
    case "sqlite":
        test_sqlite_db();
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