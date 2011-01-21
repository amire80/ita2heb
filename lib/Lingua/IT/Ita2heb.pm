package Lingua::IT::Ita2heb;

use 5.010;

use strict;
use warnings;
use utf8;
use charnames ':full';

use Carp;

use Readonly;

=head1 NAME

Lingua::IT::Ita2heb - Transliterate words in Italian into vocalized Hebrew.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

my $ALEF            = "\N{HEBREW LETTER ALEF}";
my $BET             = "\N{HEBREW LETTER BET}";
my $GIMEL           = "\N{HEBREW LETTER GIMEL}";
my $DALET           = "\N{HEBREW LETTER DALET}";
my $HE              = "\N{HEBREW LETTER HE}";
my $VAV             = "\N{HEBREW LETTER VAV}";
my $ZAYIN           = "\N{HEBREW LETTER ZAYIN}";
my $KHET            = "\N{HEBREW LETTER HET}";
my $TET             = "\N{HEBREW LETTER TET}";
my $YOD             = "\N{HEBREW LETTER YOD}";
my $KAF             = "\N{HEBREW LETTER KAF}";;
my $KAF_SOFIT       = "\N{HEBREW LETTER FINAL KAF}";
my $LAMED           = "\N{HEBREW LETTER LAMED}";
my $MEM             = "\N{HEBREW LETTER MEM}";
my $MEM_SOFIT       = "\N{HEBREW LETTER FINAL MEM}";
my $NUN             = "\N{HEBREW LETTER NUN}";
my $NUN_SOFIT       = "\N{HEBREW LETTER FINAL NUN}";
my $SAMEKH          = "\N{HEBREW LETTER SAMEKH}";
my $AYIN            = "\N{HEBREW LETTER AYIN}";
my $PE              = "\N{HEBREW LETTER PE}";
my $PE_SOFIT        = "\N{HEBREW LETTER FINAL PE}";
my $TSADE           = "\N{HEBREW LETTER TSADI}";
my $TSADE_SOFIT     = "\N{HEBREW LETTER FINAL TSADI}";
my $KOF             = "\N{HEBREW LETTER QOF}";
my $RESH            = "\N{HEBREW LETTER RESH}";
my $SHIN            = "\N{HEBREW LETTER SHIN}";
my $TAV             = "\N{HEBREW LETTER TAV}";
my $KAMATS          = "\N{HEBREW POINT QAMATS}";
my $KHATAF_KAMATS   = "\N{HEBREW POINT HATAF QAMATS}";
my $PATAKH          = "\N{HEBREW POINT PATAH}";
my $KHATAF_PATAKH   = "\N{HEBREW POINT HATAF PATAH}";
my $TSERE           = "\N{HEBREW POINT TSERE}";
my $SEGOL           = "\N{HEBREW POINT SEGOL}";
my $KHATAF_SEGOL    = "\N{HEBREW POINT HATAF SEGOL}";
my $KHIRIK          = "\N{HEBREW POINT HIRIQ}";
my $KHOLAM          = "\N{HEBREW POINT HOLAM}";
my $KUBUTS          = "\N{HEBREW POINT QUBUTS}";
my $RAFE            = "\N{HEBREW POINT RAFE}";

my $DAGESH = my $MAPIK = "\N{HEBREW POINT DAGESH OR MAPIQ}";
my $KHOLAM_MALE = $VAV . $KHOLAM;
my $SHURUK      = $VAV . $DAGESH;
my $KHIRIK_MALE = $KHIRIK . $YOD;

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Lingua::IT::Ita2heb;

    my $hebrew_word = Lingua::IT::Ita2heb::ita_to_heb('Castelmezzano');

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 ita_to_heb

Given an Italian word, returns a vocalized Hebrew string.

Additional options:

* disable_rafe: by default, the rafe sign will be used to the initial petter pe
if it represents an [f] sound. If you don't want it, run it like this:

    my $hebrew_word = Lingua::IT::Ita2heb::ita_to_heb('Firenze', disable_rafe => 1);

* disable_dagesh: by default, dagesh will be used whereber possible to
represent consonant gemination. If you don't want it, run it like this:

    my $hebrew_word = Lingua::IT::Ita2heb::ita_to_heb('Palazzo', disable_dagesh => 1);

=cut

my @TYPES_OF_A = ('a', "\N{LATIN SMALL LETTER A WITH GRAVE}");
my @TYPES_OF_E = ('e', "\N{LATIN SMALL LETTER E WITH GRAVE}", "\N{LATIN SMALL LETTER E WITH ACUTE}");
my @TYPES_OF_I = ('i', "\N{LATIN SMALL LETTER I WITH GRAVE}", "\N{LATIN SMALL LETTER I WITH ACUTE}", "\N{LATIN SMALL LETTER I WITH CIRCUMFLEX}");
my @TYPES_OF_O = ('o', "\N{LATIN SMALL LETTER O WITH GRAVE}", "\N{LATIN SMALL LETTER U WITH ACUTE}");
my @TYPES_OF_U = ('u', "\N{LATIN SMALL LETTER U WITH GRAVE}", "\N{LATIN SMALL LETTER U WITH ACUTE}");
my @ALL_VOWELS = (@TYPES_OF_A, @TYPES_OF_E, @TYPES_OF_I, @TYPES_OF_O, @TYPES_OF_U);

sub ita_to_heb {
    # options:
    # disable_rafe
    # disable_dagesh
    my ($ita, %options) = @_;

    my $heb = q{};
    my $word_init = 1;

    my @ita_letters = split qr//xms, lc $ita;

    foreach my $ita_letter_index (0 .. $#ita_letters) {
        my $ita_letter = $ita_letters[$ita_letter_index];

        if ($word_init and $ita_letter ~~ @ALL_VOWELS) {
            $heb .= $ALEF;
        }

        my $hebrew_to_add;

        given ($ita_letter) {
            when (@TYPES_OF_A) {
                $hebrew_to_add = $KAMATS;
            }
            when ('b') {
                $hebrew_to_add = $BET . $DAGESH;
            }
            when ('d') {
                $hebrew_to_add = $DALET;
            }
            when (@TYPES_OF_E) {
                $hebrew_to_add = $SEGOL;
            }
            when ('f') {
                $hebrew_to_add = $PE;

                if ($word_init and not $options{'disable_rafe'}) {
                    $hebrew_to_add .= $RAFE;
                }
            }
            when (@TYPES_OF_I) {
                $hebrew_to_add = $KHIRIK_MALE;
            }
            when ('k') {
                $hebrew_to_add = $KOF;
            }
            when ('l') {
                $hebrew_to_add = $LAMED;
            }
            when ('m') {
                $hebrew_to_add = $MEM;
            }
            when ('n') {
                $hebrew_to_add = $NUN;
            }
            when (@TYPES_OF_O) {
                $hebrew_to_add = $KHOLAM_MALE;
            }
            when ('p') {
                $hebrew_to_add = $PE . $DAGESH;
            }
            when ('r') {
                $hebrew_to_add = $RESH;
            }
            when ('s') {
                $hebrew_to_add = $SAMEKH;
            }
            when ('t') {
                $hebrew_to_add = $TET;
            }
            when (@TYPES_OF_U) {
                $hebrew_to_add = $SHURUK;
            }
            default {
                $hebrew_to_add = q{?};
                carp("Unknown letter $ita_letter in the source.");
            }
        }

        $heb .= $hebrew_to_add;

        if ($ita_letter_index == $#ita_letters) {
            if ($hebrew_to_add ~~ [ $KAMATS, $SEGOL ]) {
                $heb .= $HE;
            }
        }

        if ($word_init) {
            $word_init = 0;
        }
    }

    return $heb;
}

=head2 closed_syllable

Checks that the vowel is in a closed syllable.

Arguments: a reference to a list of characters and
the index of the vowel to check.

=cut

Readonly my $NO_CLOSED_PAST_THIS => 3;
sub closed_syllable {
    my ($letters_ref, $letter_index) = @_;

    if (($#{$letters_ref} - $letter_index) < $NO_CLOSED_PAST_THIS) {
        return 0;
    }

    for my $offset (1, 2) {
        if ($letters_ref->[$letter_index + $offset] ~~ @ALL_VOWELS) {
            return 0;
        }
    }

    return 1;
}

=head1 AUTHOR

Amir E. Aharoni, C<< <amir.aharoni at mail.huji.ac.il> >>

=head1 BUGS

Please report any bugs or feature requests to C<< <amir.aharoni at mail.huji.ac.il> >>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lingua::IT::Ita2heb

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Lingua-IT-Ita2heb>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Lingua-IT-Ita2heb>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Lingua-IT-Ita2heb>

=item * Search CPAN

L<http://search.cpan.org/dist/Lingua-IT-Ita2heb/>

=back

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Amir E. Aharoni.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Lingua::IT::Ita2heb
