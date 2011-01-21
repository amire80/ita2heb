#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 5;
use Lingua::IT::Ita2heb;
use charnames ':full';
use English '-no_match_vars';
use open ':encoding(utf8)';

our $VERSION = '0.01';

my $log_filename = __FILE__ . '.log';
open my $log, '>', $log_filename    ## no critic InputOutput::RequireBriefOpen
    or croak("Couldn't open $log_filename for writing: $OS_ERROR");

say {$log} 'Pago ' . Lingua::IT::Ita2heb::ita_to_heb('Pago');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Pago') eq "\N{HEBREW LETTER PE}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER GIMEL}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Pago'
);

say {$log} 'Giardinello ' . Lingua::IT::Ita2heb::ita_to_heb('Giardinello');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Giardinello') eq "\N{HEBREW LETTER GIMEL}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER RESH}"
        . "\N{HEBREW POINT SHEVA}"
        . "\N{HEBREW LETTER DALET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT HIRIQ}"
        . "\N{HEBREW LETTER YOD}"
        . "\N{HEBREW LETTER NUN}"
        . "\N{HEBREW POINT SEGOL}"
        . "\N{HEBREW LETTER LAMED}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Giardinello'
);

say {$log} 'Ruggiero ' . Lingua::IT::Ita2heb::ita_to_heb('Ruggiero');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Ruggiero') eq "\N{HEBREW LETTER RESH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER GIMEL}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT SEGOL}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER RESH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Ruggiero'
);

say {$log} 'Giorgio ' . Lingua::IT::Ita2heb::ita_to_heb('Giorgio');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Giorgio') eq "\N{HEBREW LETTER GIMEL}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}"
        . "\N{HEBREW LETTER RESH}"
        . "\N{HEBREW POINT SHEVA}"
        . "\N{HEBREW LETTER GIMEL}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Giorgio'
);

say {$log} 'Giussano ' . Lingua::IT::Ita2heb::ita_to_heb('Giussano');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('Giussano') eq "\N{HEBREW LETTER GIMEL}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW PUNCTUATION GERESH}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW LETTER SAMEKH}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER NUN}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}",
    'Giussano'
);

close $log
    or croak("Couldn't close $log_filename after writing: $OS_ERROR");

