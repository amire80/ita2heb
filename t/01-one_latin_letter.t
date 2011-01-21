#!perl -T

use strict;
use warnings;

use Test::More tests => 29;
use Lingua::IT::Ita2heb;
use utf8;
use charnames ':full';

our $VERSION = '0.01';

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

sub check_ita_translation
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my ($ita, $hebrew_translation, $blurb) = @_;

    return is (
        Lingua::IT::Ita2heb::ita_to_heb(ref($ita) eq 'ARRAY' ? (@$ita) : $ita),
        $hebrew_translation,
        $blurb
    );
}

check_ita_translation('a', $result_for_a, 'a');

check_ita_translation(
    "\N{LATIN SMALL LETTER A WITH GRAVE}",
    $result_for_a,
    'a with grave'
);

check_ita_translation(
    "\N{LATIN SMALL LETTER A WITH ACUTE}",
    q{?},
    'a with acute'
);

check_ita_translation(
    'b',
        "\N{HEBREW LETTER BET}\N{HEBREW POINT DAGESH OR MAPIQ}",
    'b'
);

check_ita_translation('c',  "\N{HEBREW LETTER QOF}", 'c');

check_ita_translation('d', "\N{HEBREW LETTER DALET}", 'd');

check_ita_translation('e', $result_for_e, 'e');

check_ita_translation(
    "\N{LATIN SMALL LETTER E WITH GRAVE}",
    $result_for_e,
    'e with grave'
);

check_ita_translation(
    "\N{LATIN SMALL LETTER E WITH ACUTE}",
    $result_for_e,
    'e with acute'
);

check_ita_translation(
    'f',
    "\N{HEBREW LETTER PE}\N{HEBREW POINT RAFE}",
    'f'
);

check_ita_translation(
    ['f', disable_rafe => 1, ],
    "\N{HEBREW LETTER PE}",
    'f without rafe'
);

check_ita_translation('i', $result_for_i, 'i');
check_ita_translation(
    "\N{LATIN SMALL LETTER I WITH GRAVE}",
    $result_for_i,
    'i with grave'
);

check_ita_translation(
    "\N{LATIN SMALL LETTER I WITH ACUTE}",
    $result_for_i,
    'i with acute'
);


check_ita_translation(
    "\N{LATIN SMALL LETTER I WITH CIRCUMFLEX}",
    $result_for_i,
    'i with circumflex'
);


check_ita_translation(
    'k',
    "\N{HEBREW LETTER QOF}",   
    'k'
);


check_ita_translation(
    'l',
    "\N{HEBREW LETTER LAMED}",
    'l'
);


check_ita_translation(
    'm',
    "\N{HEBREW LETTER MEM}",
    'm'
);    # XXX sofit?

check_ita_translation('n',
 "\N{HEBREW LETTER NUN}", 
 'n');    # XXX sofit?
check_ita_translation(
    'o',
    $result_for_o,
    'o'
);
check_ita_translation(
    "\N{LATIN SMALL LETTER O WITH GRAVE}",
    $result_for_o,
    'o with grave'
);

check_ita_translation(
    "\N{LATIN SMALL LETTER O WITH ACUTE}",
    $result_for_o,
    'o with acute'
);

check_ita_translation(
    'p',
    "\N{HEBREW LETTER PE}\N{HEBREW POINT DAGESH OR MAPIQ}",
    'p'
);    # not sofit!

check_ita_translation(
    'r',
    "\N{HEBREW LETTER RESH}",
    'r'
);

check_ita_translation(
    's',
    "\N{HEBREW LETTER SAMEKH}",
    's'
);

check_ita_translation(
    't',
    "\N{HEBREW LETTER TET}",
    't'
);

check_ita_translation(
    'u',
    $result_for_u,
    'u'
);

check_ita_translation(
    "\N{LATIN SMALL LETTER U WITH GRAVE}",
    $result_for_u,
    'u with grave'
);

check_ita_translation(
    "\N{LATIN SMALL LETTER U WITH ACUTE}",
    $result_for_u,
    'u with acute'
);

diag("Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X"
);
