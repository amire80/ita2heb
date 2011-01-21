#!perl -T

use strict;
use warnings;

use Test::More tests => 1;
use Lingua::IT::Ita2heb;
use utf8;
use charnames ':full';

our $VERSION = '0.01';

ok(Lingua::IT::Ita2heb::ita_to_heb('ama') eq
      "\N{HEBREW LETTER ALEF}"
    . "\N{HEBREW POINT QAMATS}"
    . "\N{HEBREW LETTER MEM}"
    . "\N{HEBREW POINT QAMATS}"
    . "\N{HEBREW LETTER HE}",
    'ama');

diag("Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X"
);
