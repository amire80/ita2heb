#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 11;
use Lingua::IT::Ita2heb;
use charnames ':full';
use English '-no_match_vars';
use open ':encoding(utf8)';

our $VERSION = '0.01';

my $log_filename = __FILE__ . '.log';
open my $log, '>', $log_filename    ## no critic InputOutput::RequireBriefOpen
    or croak("Couldn't open $log_filename for writing: $OS_ERROR");

ok(
    Lingua::IT::Ita2heb::ita_to_heb('eco') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT SEGOL}"
        . "\N{HEBREW LETTER QOF}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'eco'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('ecco') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT SEGOL}"
        . "\N{HEBREW LETTER QOF}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'ecco'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('capo') eq "\N{HEBREW LETTER QOF}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER PE}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'capo'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('cibo') eq "\N{HEBREW LETTER TSADI}"
        . "\N{HEBREW POINT HIRIQ}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER YOD}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'cibo'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('cibo', ascii_geresh => 1) eq
        "\N{HEBREW LETTER TSADI}"
        . "\N{HEBREW POINT HIRIQ}"
        . "\N{APOSTROPHE}"
        . "\N{HEBREW LETTER YOD}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'cibo, ascii geresh'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('ciabatta') eq "\N{HEBREW LETTER TSADI}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW LETTER TET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'ciabatta'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('cieco') eq "\N{HEBREW LETTER TSADI}"
        . "\N{HEBREW POINT SEGOL}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER QOF}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'cieco'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb(
        'cio' . "\N{LATIN SMALL LETTER E WITH GRAVE}"
        ) eq "\N{HEBREW LETTER TSADI}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}"
        . "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT SEGOL}"
        . "\N{HEBREW LETTER HE}",
    q(cioe')
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('ciuco') eq "\N{HEBREW LETTER TSADI}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"    # shuruk
        . "\N{HEBREW LETTER QOF}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'ciuco'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('Cicciano') eq "\N{HEBREW LETTER TSADI}"
        . "\N{HEBREW POINT HIRIQ}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER YOD}"
        . "\N{HEBREW LETTER TSADI}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER NUN}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Cicciano'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('Rocchetta') eq "\N{HEBREW LETTER RESH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}"
        . "\N{HEBREW LETTER QOF}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT SEGOL}"
        . "\N{HEBREW LETTER TET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'Rocchetta'
);

close $log
    or croak("Couldn't close $log_filename after writing: $OS_ERROR");

diag("Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X"
);
