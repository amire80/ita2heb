#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 4;
use Lingua::IT::Ita2heb;
use utf8;
use charnames ':full';

our $VERSION = '0.01';

ok(
    Lingua::IT::Ita2heb::ita_to_heb('aba') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'aba'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('abba') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'abba'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('ama') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER MEM}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'ama'
);

ok(
    Lingua::IT::Ita2heb::ita_to_heb('amma') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW LETTER MEM}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'amma'
);

diag("Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X"
);
