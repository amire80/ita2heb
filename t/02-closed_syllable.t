#!perl -T

use strict;
use warnings;

use Test::More tests => 4;
use Lingua::IT::Ita2heb;

our $VERSION = '0.01';

ok(!Lingua::IT::Ita2heb::closed_syllable([qw( a d a m m )], 2),
    'too close to the end');    # irrelevant
ok(!Lingua::IT::Ita2heb::closed_syllable([qw( a d a m m )], 0),
    'vowel, consonant, vowel');    #
ok(!Lingua::IT::Ita2heb::closed_syllable([qw( a a d a m )], 0),
    'vowel, vowel, consonant');    #
ok(Lingua::IT::Ita2heb::closed_syllable([qw( a d a m m o )], 2),
    'vowel, consonant, consonant');

diag("Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X"
);
