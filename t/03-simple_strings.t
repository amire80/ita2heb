#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 12;
use Lingua::IT::Ita2heb;
use utf8;
use charnames ':full';
use English '-no_match_vars';
use open ':encoding(utf8)';

our $VERSION = '0.01';

my $log_filename = '03-simple_strings.log';
open my $log, '>', $log_filename
    or croak("Couldn't open $log_filename for writing: $OS_ERROR");

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
    Lingua::IT::Ita2heb::ita_to_heb('abba', disable_dagesh => 1) eq
        "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'abba, disable dagesh'
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

ok(
    Lingua::IT::Ita2heb::ita_to_heb('amma', disable_dagesh => 1) eq
        "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW LETTER MEM}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'amma, disable dagesh'
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
        . "\N{HEBREW POINT HIRIQ}" . q{'}
        . "\N{HEBREW LETTER YOD}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'cibo, ascii geresh'
);

say $log "ciabatta " . Lingua::IT::Ita2heb::ita_to_heb('ciabatta');
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
    'ciuco'
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
    'ciuco'
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

close $log;

diag("Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X"
);
