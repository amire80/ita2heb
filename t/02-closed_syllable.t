#!perl -T

use strict;
use warnings;

use Test::More tests => 5;
use Lingua::IT::Ita2heb;
use charnames ':full';

our $VERSION = '0.01';

ok(!Lingua::IT::Ita2heb::closed_syllable([qw( a d a m m )], 2),
    'too close to the end');
ok(!Lingua::IT::Ita2heb::closed_syllable([qw( a d a m m )], 0),
    'vowel, consonant, vowel');
ok(!Lingua::IT::Ita2heb::closed_syllable([qw( a a d a m )], 0),
    'vowel, vowel, consonant');
ok(
    !Lingua::IT::Ita2heb::closed_syllable(
        [ 'a', "\N{LATIN SMALL LETTER A WITH GRAVE}", 'd', 'a', 'm' ], 0
    ),
    'vowel, vowel with diacritic, consonant'
);
ok(Lingua::IT::Ita2heb::closed_syllable([qw( a d a m m o )], 2),
    'vowel, consonant, consonant');

diag("Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X"
);
