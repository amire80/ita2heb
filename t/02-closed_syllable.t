#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 5;
use Lingua::IT::Ita2heb;
use charnames ':full';
use English '-no_match_vars';
use open ':encoding(utf8)';

# TEST
ok(!Lingua::IT::Ita2heb::closed_syllable([qw( a d a m m )], 2),
    'too close to the end');

# TEST
ok(!Lingua::IT::Ita2heb::closed_syllable([qw( a d a m m )], 0),
    'vowel, consonant, vowel');

# TEST
ok(!Lingua::IT::Ita2heb::closed_syllable([qw( a a d a m )], 0),
    'vowel, vowel, consonant');

# TEST
ok(
    !Lingua::IT::Ita2heb::closed_syllable(
        [ 'a', "\N{LATIN SMALL LETTER A WITH GRAVE}", 'd', 'a', 'm' ], 0
    ),
    'vowel, vowel with diacritic, consonant'
);

# TEST
ok(Lingua::IT::Ita2heb::closed_syllable([qw( a d a m m o )], 2),
    'vowel, consonant, consonant');

