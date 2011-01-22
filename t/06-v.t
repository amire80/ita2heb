#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 6;
use Lingua::IT::Ita2heb;
use charnames ':full';
use English '-no_match_vars';
use open ':encoding(utf8)';

our $VERSION = '0.01';

my $log_filename = __FILE__ . '.log';
open my $log, '>', $log_filename    ## no critic InputOutput::RequireBriefOpen
    or croak("Couldn't open $log_filename for writing: $OS_ERROR");

say {$log} 'Vocca ' . Lingua::IT::Ita2heb::ita_to_heb('Vocca');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Vocca') eq "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}"
        . "\N{HEBREW LETTER QOF}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'Vocca'
);

say {$log} 'Carovigno ' . Lingua::IT::Ita2heb::ita_to_heb('Carovigno');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Carovigno') eq "\N{HEBREW LETTER QOF}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER RESH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT HIRIQ}"
        . "\N{HEBREW LETTER YOD}"
        . "\N{HEBREW LETTER NUN}"
        . "\N{HEBREW POINT SHEVA}"
        . "\N{HEBREW LETTER YOD}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Carovigno'
);

say {$log} 'Mantova ' . Lingua::IT::Ita2heb::ita_to_heb('Mantova');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Mantova') eq "\N{HEBREW LETTER MEM}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW LETTER NUN}"
        . "\N{HEBREW POINT SHEVA}"
        . "\N{HEBREW LETTER TET}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'Mantova'
);

say {$log} 'Suvereto ' . Lingua::IT::Ita2heb::ita_to_heb('Suvereto');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Suvereto') eq "\N{HEBREW LETTER SAMEKH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT SEGOL}" # XXX Should be tsere
        . "\N{HEBREW LETTER RESH}"
        . "\N{HEBREW POINT SEGOL}"
        . "\N{HEBREW LETTER TET}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Suvereto'
);

say {$log} 'Fornovo ' . Lingua::IT::Ita2heb::ita_to_heb('Fornovo');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Fornovo') eq "\N{HEBREW LETTER PE}"
        . "\N{HEBREW POINT RAFE}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}"
        . "\N{HEBREW LETTER RESH}"
        . "\N{HEBREW POINT SHEVA}"
        . "\N{HEBREW LETTER NUN}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Fornovo'
);

say {$log} 'Pavullo ' . Lingua::IT::Ita2heb::ita_to_heb('Pavullo');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Pavullo') eq "\N{HEBREW LETTER PE}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER LAMED}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Pavullo'
);

close $log
    or croak("Couldn't close $log_filename after writing: $OS_ERROR");

