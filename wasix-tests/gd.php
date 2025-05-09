<?php

function assert_image_same($im1, $im2)
{
    $x = imagesx($im1);
    $y = imagesy($im1);
    assert($x == imagesx($im2));
    assert($y == imagesy($im2));

    for ($i = 0; $i < $x; $i++) {
        for ($j = 0; $j < $y; $j++) {
            assert(imagecolorat($im1, $i, $j) == imagecolorat($im2, $i, $j));
        }
    }
}

function test_freetype()
{
    $im = imagecreatetruecolor(200, 40);
    $red = imagecolorallocate($im, 0xFF, 0x00, 0x00);
    $black = imagecolorallocate($im, 0x00, 0x00, 0x00);
    imagefilledrectangle($im, 0, 0, 299, 99, $red);
    $font_file = './resources/FiraCode.ttf';
    imagefttext($im, 13, 0, 5, 25, $black, $font_file, 'Testing FreeType');
    assert_image_same($im, imagecreatefrompng("./resources/freetype-expected.png"));
}

function rgb($color, &$r, &$g, &$b)
{
    $r = $color >> 16 & 0xff;
    $r = $color >> 8 & 0xff;
    $b = $color & 0xff;
}

// This function allows some discrepancy between the input images, accounting
// for different compression algorithms in different formats.
function assert_image_similar($im1, $im2)
{
    $x = imagesx($im1);
    $y = imagesy($im1);
    assert($x == imagesx($im2));
    assert($y == imagesy($im2));
    $dissimilar = 0;

    for ($i = 0; $i < $x; $i++) {
        for ($j = 0; $j < $y; $j++) {
            rgb(imagecolorat($im1, $i, $j), $r1, $g1, $b1);
            rgb(imagecolorat($im2, $i, $j), $r2, $g2, $b2);
            if (abs($r1 - $r2) > 16 || abs($g1 - $g2) > 16 || abs($b1 - $b2) > 16) {
                $dissimilar++;
            }
        }
    }

    // Less than a third of pixels should be different
    assert($dissimilar * 3 <= $x * $y);
}

function test_image_formats()
{
    $bmp = imagecreatefrombmp("./resources/image.bmp");
    $jpg = imagecreatefromjpeg("./resources/image.jpg");
    $png = imagecreatefrompng("./resources/image.png");
    $webp = imagecreatefromwebp("./resources/image.webp");

    assert_image_similar($bmp, $png);
    assert_image_similar($jpg, $png);
    assert_image_similar($png, $webp);
}

function test_gd()
{
    // Assuming if the formats work, everything else works as well...
    test_image_formats();
    test_freetype();
}