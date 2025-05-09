<?php

function exec_request($curl)
{
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    $result = curl_exec($curl);
    if (curl_error($curl)) {
        throw new Exception("cURL request failed: " . curl_strerror(curl_errno($curl)), 1);
    }
    curl_close($curl);
    return $result;
}

function test_curl()
{
    $url = "https://winter-tests.wasmer.app/";

    $curl = curl_init($url);
    $result = exec_request($curl);
    assert($result == "GET request successful");

    $curl = curl_init($url);
    $payload = json_encode(array("name" => "PHP"));
    curl_setopt($curl, CURLOPT_POSTFIELDS, $payload);
    curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type:application/json'));
    $result = exec_request($curl);
    // decode and re-encode to make sure we have the same formatting
    assert(json_encode(json_decode($result)) == $payload);
}