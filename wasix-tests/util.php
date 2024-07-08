<?php

function get_env_or_fail($name)
{
    $result = getenv($name);

    if ($result === false) {
        throw new Exception("Failed to read " . $name . " env var, make sure it is provided to the PHP server", 1);
    }

    return $result;
}

function get_env_or_default($name, $default)
{
    $result = getenv($name);

    return $result == false ? $default : $result;
}