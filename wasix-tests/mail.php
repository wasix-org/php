<?php
function test_mail()
{
    // We just need to verify invoking mail with the default credentials works
    mail("someone@example.com", "subject", "hello, someone!");
}