#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 29;
use Lingua::IT::Ita2heb;
use charnames ':full';
use English '-no_match_vars';
use open ':encoding(utf8)';

our $VERSION = '0.01';

my $log_filename = __FILE__ . '.log';
open my $log, '>', $log_filename    ## no critic InputOutput::RequireBriefOpen
    or croak("Couldn't open $log_filename for writing: $OS_ERROR");

my $result_for_a =
      "\N{HEBREW LETTER ALEF}"
    . "\N{HEBREW POINT QAMATS}"
    . "\N{HEBREW LETTER HE}";

my $result_for_e =
      "\N{HEBREW LETTER ALEF}"
    . "\N{HEBREW POINT SEGOL}"
    . "\N{HEBREW LETTER HE}";

my $result_for_i =
      "\N{HEBREW LETTER ALEF}"
    . "\N{HEBREW POINT HIRIQ}"
    . "\N{HEBREW LETTER YOD}";

my $result_for_o =
      "\N{HEBREW LETTER ALEF}"
    . "\N{HEBREW LETTER VAV}"
    . "\N{HEBREW POINT HOLAM}";

my $result_for_u =
      "\N{HEBREW LETTER ALEF}"
    . "\N{HEBREW LETTER VAV}"
    . "\N{HEBREW POINT DAGESH OR MAPIQ}";    # shuruk

sub check_ita_transliteration
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my ($ita, $hebrew_transliteration, $blurb) = @_;

    return is (
        Lingua::IT::Ita2heb::ita_to_heb(ref($ita) eq 'ARRAY' ? (@$ita) : $ita),
        $hebrew_transliteration,
        $blurb
    );
}

check_ita_transliteration('a', $result_for_a, 'a');

check_ita_transliteration(
    "\N{LATIN SMALL LETTER A WITH GRAVE}",
    $result_for_a,
    'a with grave'
);

check_ita_transliteration(
    "\N{LATIN SMALL LETTER A WITH ACUTE}",
    q{?},
    'a with acute'
);

check_ita_transliteration(
    'b',
        "\N{HEBREW LETTER BET}\N{HEBREW POINT DAGESH OR MAPIQ}",
    'b'
);

check_ita_transliteration('c',  "\N{HEBREW LETTER QOF}", 'c');

check_ita_transliteration('d', "\N{HEBREW LETTER DALET}", 'd');

check_ita_transliteration('e', $result_for_e, 'e');

check_ita_transliteration(
    "\N{LATIN SMALL LETTER E WITH GRAVE}",
    $result_for_e,
    'e with grave'
);

check_ita_transliteration(
    "\N{LATIN SMALL LETTER E WITH ACUTE}",
    $result_for_e,
    'e with acute'
);

check_ita_transliteration(
    'f',
    "\N{HEBREW LETTER PE}\N{HEBREW POINT RAFE}",
    'f'
);

check_ita_transliteration(
    ['f', disable_rafe => 1, ],
    "\N{HEBREW LETTER PE}",
    'f without rafe'
);

check_ita_transliteration('i', $result_for_i, 'i');
check_ita_transliteration(
    "\N{LATIN SMALL LETTER I WITH GRAVE}",
    $result_for_i,
    'i with grave'
);

check_ita_transliteration(
    "\N{LATIN SMALL LETTER I WITH ACUTE}",
    $result_for_i,
    'i with acute'
);


check_ita_transliteration(
    "\N{LATIN SMALL LETTER I WITH CIRCUMFLEX}",
    $result_for_i,
    'i with circumflex'
);


check_ita_transliteration(
    'k',
    "\N{HEBREW LETTER QOF}",   
    'k'
);


check_ita_transliteration(
    'l',
    "\N{HEBREW LETTER LAMED}",
    'l'
);


check_ita_transliteration(
    'm',
    "\N{HEBREW LETTER MEM}",
    'm'
);    # XXX sofit?

check_ita_transliteration('n',
 "\N{HEBREW LETTER NUN}", 
 'n');    # XXX sofit?
check_ita_transliteration(
    'o',
    $result_for_o,
    'o'
);
check_ita_transliteration(
    "\N{LATIN SMALL LETTER O WITH GRAVE}",
    $result_for_o,
    'o with grave'
);

check_ita_transliteration(
    "\N{LATIN SMALL LETTER O WITH ACUTE}",
    $result_for_o,
    'o with acute'
);

check_ita_transliteration(
    'p',
    "\N{HEBREW LETTER PE}\N{HEBREW POINT DAGESH OR MAPIQ}",
    'p'
);    # not sofit!

check_ita_transliteration(
    'r',
    "\N{HEBREW LETTER RESH}",
    'r'
);

check_ita_transliteration(
    's',
    "\N{HEBREW LETTER SAMEKH}",
    's'
);

check_ita_transliteration(
    't',
    "\N{HEBREW LETTER TET}",
    't'
);

check_ita_transliteration(
    'u',
    $result_for_u,
    'u'
);

check_ita_transliteration(
    "\N{LATIN SMALL LETTER U WITH GRAVE}",
    $result_for_u,
    'u with grave'
);

check_ita_transliteration(
    "\N{LATIN SMALL LETTER U WITH ACUTE}",
    $result_for_u,
    'u with acute'
);

