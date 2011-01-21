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

