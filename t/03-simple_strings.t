#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 7;
use Lingua::IT::Ita2heb;
use charnames ':full';
use English '-no_match_vars';
use open ':encoding(utf8)';

our $VERSION = '0.01';

my $log_filename = __FILE__ . '.log';
open my $log, '>', $log_filename    ## no critic InputOutput::RequireBriefOpen
    or croak("Couldn't open $log_filename for writing: $OS_ERROR");

say {$log} 'aba ' . Lingua::IT::Ita2heb::ita_to_heb('aba');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('aba') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'aba'
);

say {$log} 'abba ' . Lingua::IT::Ita2heb::ita_to_heb('abba');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('abba') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW LETTER BET}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'abba'
);

say {$log} 'abba, disable dagesh ' . Lingua::IT::Ita2heb::ita_to_heb('aba', disable_dagesh => 1);
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

say {$log} 'ama ' . Lingua::IT::Ita2heb::ita_to_heb('ama');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('ama') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER MEM}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'ama'
);

say {$log} 'amma ' . Lingua::IT::Ita2heb::ita_to_heb('amma');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('amma') eq "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW LETTER MEM}"
        . "\N{HEBREW POINT DAGESH OR MAPIQ}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'amma'
);

say {$log} 'amma, disable dagesh ' . Lingua::IT::Ita2heb::ita_to_heb('amma', disable_dagesh => 1);
ok(
    Lingua::IT::Ita2heb::ita_to_heb('amma', disable_dagesh => 1) eq
        "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT PATAH}"
        . "\N{HEBREW LETTER MEM}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    'amma, disable dagesh'
);

say {$log} 'monte ' . Lingua::IT::Ita2heb::ita_to_heb('monte');
ok(
    Lingua::IT::Ita2heb::ita_to_heb('monte', disable_dagesh => 1) eq
        "\N{HEBREW LETTER MEM}"
        . "\N{HEBREW LETTER VAV}"
        . "\N{HEBREW POINT HOLAM}"
        . "\N{HEBREW LETTER NUN}"
        . "\N{HEBREW POINT SHEVA}"
        . "\N{HEBREW LETTER TET}"
        . "\N{HEBREW POINT SEGOL}"
        . "\N{HEBREW LETTER HE}",
    'amma, disable dagesh'
);

close $log
    or croak("Couldn't close $log_filename after writing: $OS_ERROR");

diag("Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X"
);
