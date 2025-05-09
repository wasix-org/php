<?php

function test_ssl_over_fopen()
{
    $file = fopen("https://winter-tests.wasmer.app/", "r");
    $result = fread($file, 100);
    assert($result == "GET request successful");
}