package Lingua::IT::Ita2heb;

use 5.010;

use strict;
use warnings;
use utf8;
use charnames ':full';

use Carp;

use Readonly;

our $VERSION = '0.01';

my $ALEF         = "\N{HEBREW LETTER ALEF}";
my $BET          = "\N{HEBREW LETTER BET}";
my $GIMEL        = "\N{HEBREW LETTER GIMEL}";
my $DALET        = "\N{HEBREW LETTER DALET}";
my $HE           = "\N{HEBREW LETTER HE}";
my $VAV          = "\N{HEBREW LETTER VAV}";
my $ZAYIN        = "\N{HEBREW LETTER ZAYIN}";
my $HET          = "\N{HEBREW LETTER HET}";
my $TET          = "\N{HEBREW LETTER TET}";
my $YOD          = "\N{HEBREW LETTER YOD}";
my $KAF          = "\N{HEBREW LETTER KAF}";
my $FINAL_KAF    = "\N{HEBREW LETTER FINAL KAF}";
my $LAMED        = "\N{HEBREW LETTER LAMED}";
my $MEM          = "\N{HEBREW LETTER MEM}";
my $FINAL_MEM    = "\N{HEBREW LETTER FINAL MEM}";
my $NUN          = "\N{HEBREW LETTER NUN}";
my $FINAL_NUN    = "\N{HEBREW LETTER FINAL NUN}";
my $SAMEKH       = "\N{HEBREW LETTER SAMEKH}";
my $AYIN         = "\N{HEBREW LETTER AYIN}";
my $PE           = "\N{HEBREW LETTER PE}";
my $FINAL_PE     = "\N{HEBREW LETTER FINAL PE}";
my $TSADI        = "\N{HEBREW LETTER TSADI}";
my $FINAL_TSADI  = "\N{HEBREW LETTER FINAL TSADI}";
my $QOF          = "\N{HEBREW LETTER QOF}";
my $RESH         = "\N{HEBREW LETTER RESH}";
my $SHIN         = "\N{HEBREW LETTER SHIN}";
my $TAV          = "\N{HEBREW LETTER TAV}";
my $QAMATS       = "\N{HEBREW POINT QAMATS}";
my $HATAF_QAMATS = "\N{HEBREW POINT HATAF QAMATS}";
my $PATAH        = "\N{HEBREW POINT PATAH}";
my $HATAF_PATAH  = "\N{HEBREW POINT HATAF PATAH}";
my $TSERE        = "\N{HEBREW POINT TSERE}";
my $SEGOL        = "\N{HEBREW POINT SEGOL}";
my $HATAF_SEGOL  = "\N{HEBREW POINT HATAF SEGOL}";
my $HIRIQ        = "\N{HEBREW POINT HIRIQ}";
my $HOLAM        = "\N{HEBREW POINT HOLAM}";
my $QUBUTS       = "\N{HEBREW POINT QUBUTS}";
my $SHEVA        = "\N{HEBREW POINT SHEVA}";
my $RAFE         = "\N{HEBREW POINT RAFE}";
my $DAGESH       = my $MAPIQ = "\N{HEBREW POINT DAGESH OR MAPIQ}";
my $HOLAM_MALE   = $VAV . $HOLAM;
my $SHURUK       = $VAV . $DAGESH;
my $HIRIQ_MALE   = $HIRIQ . $YOD;
my $TRUE_GERESH  = "\N{HEBREW PUNCTUATION GERESH}";

my @ALL_HEBREW_VOWELS = (
    $QAMATS,     $HATAF_QAMATS, $PATAH, $HATAF_PATAH, $TSERE,
    $SEGOL,      $HATAF_SEGOL,  $HIRIQ, $HIRIQ_MALE,  $HOLAM,
    $HOLAM_MALE, $QUBUTS,       $SHURUK,
);

my @TYPES_OF_A = ('a', "\N{LATIN SMALL LETTER A WITH GRAVE}");
my @TYPES_OF_E = (
    'e',
    "\N{LATIN SMALL LETTER E WITH GRAVE}",
    "\N{LATIN SMALL LETTER E WITH ACUTE}",
);
my @TYPES_OF_I = (
    'i',
    "\N{LATIN SMALL LETTER I WITH GRAVE}",
    "\N{LATIN SMALL LETTER I WITH ACUTE}",
    "\N{LATIN SMALL LETTER I WITH CIRCUMFLEX}",
);
my @TYPES_OF_O = (
    'o',
    "\N{LATIN SMALL LETTER O WITH GRAVE}",
    "\N{LATIN SMALL LETTER O WITH ACUTE}",
);
my @TYPES_OF_U = (
    'u',
    "\N{LATIN SMALL LETTER U WITH GRAVE}",
    "\N{LATIN SMALL LETTER U WITH ACUTE}",
);
my @ALL_LATIN_VOWELS =
    (@TYPES_OF_A, @TYPES_OF_E, @TYPES_OF_I, @TYPES_OF_O, @TYPES_OF_U);
my @CG_MODIFIER = (@TYPES_OF_E, @TYPES_OF_I);
my @REQUIRES_DAGESH = qw(b p);

my @VOWEL_BEFORE_GERESH = ($QAMATS, $PATAH, $TSERE, $SEGOL, $HIRIQ);
my @VOWEL_AFTER_GERESH = ($HOLAM_MALE, $SHURUK);

Readonly my $NO_CLOSED_PAST_THIS => 3;

sub ita_to_heb {    ## no critic ProhibitExcessComplexity
    my ($ita, %option) = @_;

    my $GERESH = $option{ascii_geresh} ? q{'} : $TRUE_GERESH;

    my $heb = q{};

    my @ita_letters = split qr//xms, lc $ita;

    my $add_geresh  = 0;
    my $wrote_vowel = 0;
    my $geminated   = 0;

    ITA_LETTER:
    foreach my $ita_letter_index (0 .. $#ita_letters) {
        my $ita_letter = $ita_letters[$ita_letter_index];

        if (
            $ita_letter ~~ @ALL_LATIN_VOWELS
            and (  $ita_letter_index == 0
                or $wrote_vowel)
            )
        {
            $heb .= $ALEF;
        }

        my $hebrew_to_add = q{};

        if (    $ita_letter_index > 0
            and $ita_letter_index < $#ita_letters
            and not $ita_letter ~~ @ALL_LATIN_VOWELS
            and $ita_letter eq $ita_letters[ $ita_letter_index + 1 ])
        {
            $geminated = 1;
            next ITA_LETTER;
        }
        elsif (not $geminated) {
            $geminated = 0;
        }

        $wrote_vowel = 0;

        given ($ita_letter) {
            when (@TYPES_OF_A) {
                if (closed_syllable(\@ita_letters, $ita_letter_index)) {
                    $hebrew_to_add .= $PATAH;
                }
                else {
                    $hebrew_to_add .= $QAMATS;
                }
            }
            when ('b') {
                $hebrew_to_add .= $BET;
            }
            when ('c') {
                if (
                    (
                            $ita_letter_index < $#ita_letters
                        and $ita_letters[ $ita_letter_index + 1 ] ~~
                        @CG_MODIFIER
                    )
                    or (    $ita_letter_index < ($#ita_letters - 1)
                        and $ita_letters[ $ita_letter_index + 1 ] eq 'c'
                        and $ita_letters[ $ita_letter_index + 2 ] ~~
                        @CG_MODIFIER)
                    )
                {
                    $hebrew_to_add .= $TSADI;
                    $add_geresh = 1;
                }
                else {
                    $hebrew_to_add .= $QOF;
                }
            }
            when ('d') {
                $hebrew_to_add .= $DALET;
            }
            when (@TYPES_OF_E) {
                $hebrew_to_add .= $SEGOL;
            }
            when ('f') {
                $hebrew_to_add .= $PE;

                if ($ita_letter_index == 0
                    and not $option{'disable_rafe'})
                {
                    $hebrew_to_add .= $RAFE;
                }
            }
            when ('g') {
                if (
                    $ita_letters[ $ita_letter_index + 1 ] ~~ @CG_MODIFIER
                    or (    $ita_letters[ $ita_letter_index + 1 ] eq 'g'
                        and $ita_letters[ $ita_letter_index + 2 ] ~~
                        @CG_MODIFIER)
                    )
                {
                    $add_geresh = 1;
                }

                $hebrew_to_add .= $GIMEL;
            }
            when ('h') {    # Niente.
            }
            when (@TYPES_OF_I) {
                if ($add_geresh) {
                    if (
                        not $ita_letters[ $ita_letter_index + 1 ] ~~
                        @ALL_LATIN_VOWELS)
                    {
                        $hebrew_to_add .= $HIRIQ;
                    }
                }
                else {
                    $hebrew_to_add .= $HIRIQ_MALE;
                }
            }
            when ('k') {
                $hebrew_to_add .= $QOF;
            }
            when ('l') {
                $hebrew_to_add .= $LAMED;
            }
            when ('m') {
                $hebrew_to_add .= $MEM;
            }
            when ('n') {
                $hebrew_to_add .= $NUN;
            }
            when (@TYPES_OF_O) {
                $hebrew_to_add .= $HOLAM_MALE;
            }
            when ('p') {
                $hebrew_to_add .= $PE;
            }
            when ('r') {
                $hebrew_to_add .= $RESH;
            }
            when ('s') {
                $hebrew_to_add .= $SAMEKH;
            }
            when ('t') {
                $hebrew_to_add .= $TET;
            }
            when (@TYPES_OF_U) {
                $hebrew_to_add .= $SHURUK;
            }
            default {
                $hebrew_to_add .= q{?};
                carp("Unknown letter $ita_letter in the source.");
            }
        }

        if ($ita_letter ~~ @REQUIRES_DAGESH
            or ($geminated and not $option{disable_dagesh}))
        {
            $hebrew_to_add .= $DAGESH;
            $geminated = 0;
        }

        if ($add_geresh and $hebrew_to_add ~~ [@VOWEL_AFTER_GERESH]) {
            $heb .= $GERESH;
            $add_geresh = 0;
        }

        $heb .= $hebrew_to_add;

        if (    $ita_letter_index > 0
            and not $ita_letter ~~ @ALL_LATIN_VOWELS
            and defined $ita_letters[ $ita_letter_index + 1 ]
            and not $ita_letters[ $ita_letter_index + 1 ] ~~ [ @ALL_LATIN_VOWELS, 'h' ]
            and $ita_letter ne $ita_letters[ $ita_letter_index + 1 ])
        {
            $heb .= $SHEVA;
        }

        if ($add_geresh and $hebrew_to_add ~~ @VOWEL_BEFORE_GERESH) {
            $heb .= $GERESH;

            if ($hebrew_to_add eq $HIRIQ) {
                $heb .= $YOD;
            }

            $add_geresh = 0;
        }

        if ($ita_letter_index == $#ita_letters) {
            if ($hebrew_to_add ~~ [ $QAMATS, $SEGOL ]) {
                $heb .= $HE;
            }
        }

        if ($hebrew_to_add ~~ @ALL_HEBREW_VOWELS) {
            $wrote_vowel = 1;
        }
    }

    return $heb;
}

sub closed_syllable {
    my ($letters_ref, $letter_index) = @_;

    if (($#{$letters_ref} - $letter_index) < $NO_CLOSED_PAST_THIS) {
        return 0;
    }

    for my $offset (1, 2) {
        if ($letters_ref->[ $letter_index + $offset ] ~~ @ALL_LATIN_VOWELS) {
            return 0;
        }
    }

    return 1;
}

1;    # End of Lingua::IT::Ita2heb

__END__

=head1 NAME

Lingua::IT::Ita2heb

=head1 DESCRIPTION

Transliterate words in Italian into vocalized Hebrew.

=head1 VERSION

Version 0.01

=head1 AUTHOR

Amir E. Aharoni, C<< <amir.aharoni at mail.huji.ac.il> >>

=head1 SYNOPSIS

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

* ascii_geresh: by default, Unicode HEBREW PUNCTUATION GERESH is used to indicate
the sounds of ci and gi. If you want to use the ASCII apostrophe, run it like this:

    my $hebrew_word = Lingua::IT::Ita2heb::ita_to_heb('Cicerone', ascii_geresh => 1);

=head2 closed_syllable

Checks that the vowel is in a closed syllable.

Arguments: a reference to a list of characters and
the index of the vowel to check.

=head1 DIAGNOSTICS

* "Unknown letter LETTER in the source" - the LETTER doesn't look a part of the Italian orthography.

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to C<< <amir.aharoni at mail.huji.ac.il> >>.

=head1 DEPENDENCIES

Readonly.pm.

=head1 CONFIGURATION AND ENVIRONMENT

Nothing special.

=head1 INCOMPATIBILITIES

This program doesn't woth with Perl earlier than 5.10 and with non-Unicode strings.

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

I thank each and every of teachers thanks to whom i know Italian and Hebrew.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Amir E. Aharoni.

* the GNU General Public License version 3 as published
by the Free Software Foundation.

* or the Artistic License version 2.0.

See http://dev.perl.org/licenses/ for more information.

=cut
