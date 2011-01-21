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

ok(Lingua::IT::Ita2heb::ita_to_heb('a') eq $result_for_a, 'a');
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER A WITH GRAVE}") eq
        $result_for_a,
    'a with grave'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER A WITH ACUTE}") eq
        q{?},
    'a with acute'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb('b') eq
        "\N{HEBREW LETTER BET}\N{HEBREW POINT DAGESH OR MAPIQ}",
    'b'
);
ok(Lingua::IT::Ita2heb::ita_to_heb('c') eq "\N{HEBREW LETTER QOF}",   'c');
ok(Lingua::IT::Ita2heb::ita_to_heb('d') eq "\N{HEBREW LETTER DALET}", 'd');
ok(Lingua::IT::Ita2heb::ita_to_heb('e') eq $result_for_e,             'e');
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER E WITH GRAVE}") eq
        $result_for_e,
    'e with grave'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER E WITH ACUTE}") eq
        $result_for_e,
    'e with acute'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb('f') eq
        "\N{HEBREW LETTER PE}\N{HEBREW POINT RAFE}",
    'f'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb('f', disable_rafe => 1) eq
        "\N{HEBREW LETTER PE}",
    'f without rafe'
);
ok(Lingua::IT::Ita2heb::ita_to_heb('i') eq $result_for_i, 'i');
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER I WITH GRAVE}") eq
        $result_for_i,
    'i with grave'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER I WITH ACUTE}") eq
        $result_for_i,
    'i with acute'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb(
        "\N{LATIN SMALL LETTER I WITH CIRCUMFLEX}") eq $result_for_i,
    'i with circumflex'
);
ok(Lingua::IT::Ita2heb::ita_to_heb('k') eq "\N{HEBREW LETTER QOF}",   'k');
ok(Lingua::IT::Ita2heb::ita_to_heb('l') eq "\N{HEBREW LETTER LAMED}", 'l');
ok(Lingua::IT::Ita2heb::ita_to_heb('m') eq "\N{HEBREW LETTER MEM}",   'm')
    ;    # XXX sofit?
ok(Lingua::IT::Ita2heb::ita_to_heb('n') eq "\N{HEBREW LETTER NUN}", 'n')
    ;    # XXX sofit?
ok(Lingua::IT::Ita2heb::ita_to_heb('o') eq $result_for_o, 'o');
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER O WITH GRAVE}") eq
        $result_for_o,
    'o with grave'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER O WITH ACUTE}") eq
        $result_for_o,
    'o with acute'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb('p') eq
        "\N{HEBREW LETTER PE}\N{HEBREW POINT DAGESH OR MAPIQ}",
    'p'
);    # not sofit!
ok(Lingua::IT::Ita2heb::ita_to_heb('r') eq "\N{HEBREW LETTER RESH}",   'r');
ok(Lingua::IT::Ita2heb::ita_to_heb('s') eq "\N{HEBREW LETTER SAMEKH}", 's');
ok(Lingua::IT::Ita2heb::ita_to_heb('t') eq "\N{HEBREW LETTER TET}",    't');
ok(Lingua::IT::Ita2heb::ita_to_heb('u') eq $result_for_u,              'u');
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER U WITH GRAVE}") eq
        $result_for_u,
    'u with grave'
);
ok(
    Lingua::IT::Ita2heb::ita_to_heb("\N{LATIN SMALL LETTER U WITH ACUTE}") eq
        $result_for_u,
    'u with acute'
);

diag("Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X"
);
