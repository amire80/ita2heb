package Lingua::IT::Ita2heb;

use 5.010;

use strict;
use warnings;
use utf8;
use charnames ':full';

use Carp;

use Readonly;

use List::MoreUtils ();

use Lingua::IT::Ita2heb::LettersSeq;

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
my $SHIN         = "\N{HEBREW LETTER SHIN}\N{HEBREW POINT SHIN DOT}";
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
my @CG_MODIFIER              = (@TYPES_OF_E, @TYPES_OF_I);
my @REQUIRES_DAGESH_PHONETIC = qw(b p);
my @G_SILENCERS              = qw(l n);
my @REQUIRES_BET_FOR_V       = (@TYPES_OF_O, @TYPES_OF_U);

# Dagesh qal.
# BET and PE must not change according to these rules in transliterated
# Italian and KAF and TAV are not needed in Italian at all.
# Dagesh qal in GIMEL and DALET is totally artificial, but it's part
# of the standard...
my @REQUIRES_DAGESH_LENE = ($GIMEL, $DALET);

my @VOWEL_BEFORE_GERESH = ($QAMATS, $PATAH, $TSERE, $SEGOL, $HIRIQ);
my @VOWEL_AFTER_GERESH = ($HOLAM_MALE, $SHURUK);

Readonly my $NO_CLOSED_PAST_THIS => 3;

Readonly my @SHEVA_SPECS => (
    [ 0  => [ [@ALL_LATIN_VOWELS] ] ],
    [ 1  => [ [ @ALL_LATIN_VOWELS, 'h' ] ] ],
    [ 0  => [ ['g'], \@G_SILENCERS ] ],
    [ 0  => [ ['s'], ['c'], \@CG_MODIFIER ] ],
    [ -1 => [ ['s'], ['c'], \@CG_MODIFIER ] ],
    [ 0 => [ ['c'], ['q'] ] ],
);

Readonly my %SIMPLE_TRANSLITERATIONS => (
    'b' => $BET,
    'd' => $DALET,
    (map { $_ => $SEGOL } @TYPES_OF_E),
    'k' => $QOF,
    'l' => $LAMED,
    (map { $_ => $HOLAM_MALE } @TYPES_OF_O),
    'p' => $PE,
    'r' => $RESH,
    't' => $TET,
);

sub ita_to_heb {    ## no critic (Subroutines::ProhibitExcessComplexity)
    my ($ita, %option) = @_;

    my $GERESH = $option{ascii_geresh} ? q{'} : $TRUE_GERESH;

    my $heb = q{};

    my @ita_letters = split qr//xms, lc $ita;

    my $add_geresh  = 0;
    my $geminated   = 0;

    my $seq = Lingua::IT::Ita2heb::LettersSeq->new(
        {
            ita_letters => \@ita_letters,
        }
    );

    ITA_LETTER:
    while (defined(my $ita_letter_index = $seq->next_index)) {

        my $ita_letter = $seq->current;

        if (
            $ita_letter ~~ @ALL_LATIN_VOWELS
            and ($seq->at_start or $seq->wrote_vowel)
        )
        {
            $heb .= $ALEF;
        }

        my $hebrew_to_add = q{};

        if (    $seq->after_start
            and $seq->before_end
            and not $ita_letter ~~ @ALL_LATIN_VOWELS
            and $ita_letter eq $ita_letters[ $ita_letter_index + 1 ])
        {
            $geminated = 1;
            next ITA_LETTER;
        }
        elsif (not $geminated) {
            $geminated = 0;
        }

        $seq->unset_wrote_vowel;

        given ($ita_letter) {
            when (%SIMPLE_TRANSLITERATIONS) {
                $hebrew_to_add .= $SIMPLE_TRANSLITERATIONS{$_};
            }
            when (@TYPES_OF_A) {
                if (closed_syllable(\@ita_letters, $ita_letter_index)) {
                    $hebrew_to_add .= $PATAH;
                }
                else {
                    $hebrew_to_add .= $QAMATS;
                }
            }
            when ('c') {
                if (
                    not(    $seq->after_start
                        and $seq->before_end
                        and $ita_letters[ $ita_letter_index - 1 ] eq 's'
                        and $ita_letters[ $ita_letter_index + 1 ] ~~
                        @CG_MODIFIER)
                    )
                {
                    if (
                        (
                                $seq->before_end
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
            }
            when ('f') {
                if ($seq->after_start and $ita_letter_index == $#ita_letters)
                {
                    $hebrew_to_add .= $FINAL_PE;
                }
                else {
                    $hebrew_to_add .= $PE;

                    if ($seq->at_start and not $option{'disable_rafe'})
                    {
                        $hebrew_to_add .= $RAFE;
                    }
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

                if (    $seq->before_end
                    and $ita_letters[ $ita_letter_index + 1 ] eq 'n')
                {
                    $hebrew_to_add .= $NUN . $SHEVA . $YOD;
                }
                elsif (
                    not(    $ita_letter_index
                        and $ita_letters[ $ita_letter_index + 1 ] eq 'l')
                    )
                {
                    $hebrew_to_add .= $GIMEL;
                }
            }
            when ('h') {    # Niente.
            }
            when (@TYPES_OF_I) {

                # No [i] in sci, except end of word
                if (
                    not($seq->idx > 1
                        and $seq->before_end
                        and $ita_letters[ $ita_letter_index - 2 ] eq 's'
                        and $ita_letters[ $ita_letter_index - 1 ] eq 'c')
                    )
                {
                    if ($add_geresh) {
                        if (
                            not $ita_letters[ $ita_letter_index + 1 ] ~~
                            @ALL_LATIN_VOWELS)
                        {
                            $hebrew_to_add .= $HIRIQ;
                        }
                    }
                    elsif ($ita_letters[ $ita_letter_index + 1 ] ~~
                        @ALL_LATIN_VOWELS)
                    {
                        $hebrew_to_add .= $SHEVA . $YOD;
                    }
                    else {
                        $hebrew_to_add .= $HIRIQ_MALE;
                    }
                }
            }
            when ('m') {
                $hebrew_to_add .=
                    ($seq->after_start and $ita_letter_index == $#ita_letters)
                    ? $FINAL_MEM
                    : $MEM;
            }
            when ('n') {
                if (    $seq->after_start
                    and $ita_letters[ $ita_letter_index - 1 ] eq 'g')
                {
                    next ITA_LETTER;
                }

                $hebrew_to_add .=
                    ($seq->after_start and $ita_letter_index == $#ita_letters)
                    ? $FINAL_NUN
                    : $NUN;
            }
            when ('q') {
                if (    $seq->after_start
                    and $ita_letters[ $ita_letter_index - 1 ] eq 'c')
                {
                    if (not $option{disable_dagesh}) {
                        $hebrew_to_add .= $DAGESH;
                    }
                }
                else {
                    $hebrew_to_add .= $QOF;
                }

                $hebrew_to_add .= $SHEVA . $VAV;
            }
            when ('s') {
                if (    $seq->after_start
                    and $seq->before_end
                    and $ita_letters[ $ita_letter_index - 1 ] ~~
                    @ALL_LATIN_VOWELS
                    and $ita_letters[ $ita_letter_index + 1 ] ~~
                    @ALL_LATIN_VOWELS)
                {
                    $hebrew_to_add .= $ZAYIN;
                }
                elsif ( ($#ita_letters - $ita_letter_index > 1)
                    and $ita_letters[ $ita_letter_index + 1 ] eq 'c'
                    and $ita_letters[ $ita_letter_index + 2 ] ~~ @CG_MODIFIER)
                {
                    $hebrew_to_add .= $SHIN;
                }
                else {
                    $hebrew_to_add .= $SAMEKH;
                }
            }
            when (@TYPES_OF_U) {
                if (    $seq->after_start
                    and $ita_letters[ $ita_letter_index - 1 ] eq 'q')
                {
                    next;
                }
                else {
                    $hebrew_to_add .= $SHURUK;
                }
            }
            when ('v') {
                if (
                    $seq->after_start
                    and ($ita_letters[ $ita_letter_index - 1 ] ~~
                           @REQUIRES_BET_FOR_V
                        or $ita_letters[ $ita_letter_index + 1 ] ~~
                        @REQUIRES_BET_FOR_V
                        or $ita_letter_index == $#ita_letters)
                    )
                {
                    $hebrew_to_add .= $BET;
                }
                else {
                    $hebrew_to_add .= $VAV;
                }
            }
            when ('z') {
                if ($seq->at_start) {
                    $hebrew_to_add .= $DALET . $DAGESH . $SHEVA . $ZAYIN;
                }
                else {
                    $hebrew_to_add .=
                        (       $seq->after_start
                            and $ita_letter_index == $#ita_letters)
                        ? $FINAL_TSADI
                        : $TSADI;
                }
            }
            default {
                $hebrew_to_add .= q{?};
                carp("Unknown letter $ita_letter in the source.");
            }
        }

        if (
            $ita_letter ~~ @REQUIRES_DAGESH_PHONETIC  # Dagesh phonetic (b, p)
            or
            ($geminated and not $option{disable_dagesh})   # Dagesh geminating
            or (
                (
                    $seq->at_start   # Dagesh lene (bgdkft) XXX
                    or not $ita_letters[ $ita_letter_index - 1 ] ~~
                    @ALL_LATIN_VOWELS
                )
                and $hebrew_to_add ~~ @REQUIRES_DAGESH_LENE
                and not($ita_letter ~~ @REQUIRES_DAGESH_PHONETIC)
            )
            )
        {
            if ($hebrew_to_add ne $RESH) {
                $hebrew_to_add .= $DAGESH;
            }

            $geminated = 0;
        }

        if ($add_geresh and $hebrew_to_add ~~ [@VOWEL_AFTER_GERESH]) {
            $heb .= $GERESH;
            $add_geresh = 0;
        }

        $heb .= $hebrew_to_add;

        my $match_places = sub {
            my ($start_offset, $sets_seq) = @_;

            foreach my $i (0 .. $#{$sets_seq}) {
                if (
                    not $ita_letters[ $i + $ita_letter_index + $start_offset ]
                    ~~ @{ $sets_seq->[$i] })
                {
                    return;
                }
            }

            return 1;
        };

        if (    defined $ita_letters[ $ita_letter_index + 1 ]
            and $ita_letter ne $ita_letters[ $ita_letter_index + 1 ]
            and
            (List::MoreUtils::none { $match_places->(@{$_}) } @SHEVA_SPECS))
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
            $seq->set_wrote_vowel;
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

Lingua::IT::Ita2heb - transliterate Italian words into vocalized Hebrew.

=head1 DESCRIPTION

Transliterate words in Italian into vocalized Hebrew.

=head1 VERSION

Version 0.01

=head1 AUTHOR

Amir E. Aharoni, C<< <amir.aharoni at mail.huji.ac.il> >>

=head1 SYNOPSIS

    use Lingua::IT::Ita2heb;

    my $hebrew_word = Lingua::IT::Ita2heb::ita_to_heb('Castelmezzano');

=head1 SUBROUTINES/METHODS

=head2 ita_to_heb

Given an Italian word, returns a vocalized Hebrew string.

Additional options:

=over

=item * disable_rafe

By default, the rafe sign will be added to the initial petter pe
if it represents an [f] sound. If you don't want it, run it like this:

    my $hebrew_word = Lingua::IT::Ita2heb::ita_to_heb('Firenze', disable_rafe => 1);

=item * disable_dagesh

By default, dagesh will be used wherever possible to
represent consonant gemination. If you don't want it, run it like this:

    my $hebrew_word = Lingua::IT::Ita2heb::ita_to_heb('Palazzo', disable_dagesh => 1);

=item * ascii_geresh

By default, Unicode HEBREW PUNCTUATION GERESH is used to indicate
the sounds of ci and gi. If you want to use the ASCII apostrophe, run it like this:

    my $hebrew_word = Lingua::IT::Ita2heb::ita_to_heb('Cicerone', ascii_geresh => 1);

=back

=head2 closed_syllable

Checks that the vowel is in a closed syllable.

Arguments: a reference to a list of characters and
the index of the vowel to check.

=head1 DIAGNOSTICS

=over

=item * Unknown letter LETTER in the source

The LETTER doesn't look like a part of the Italian orthography.

=back

=head1 BUGS AND LIMITATIONS

This program has several known limitations because Italian pronunciation is
sometimes unpredictable and because of the quirks of Hebrew spelling. Do
not assume that transliterations that this program makes are correct
and always check a reliable dictionary to be sure. Look out especially for
the following cases:

=over

=item * Words with of z

The letter z is assumed to have the sound of [dz] in the beginning of
the word and [ts] elsewhere. This is right most of the time, but there are
also many words where it is wrong.

=item * Words with ia, ie, io, iu

The letter i is assumed to be a semi-vowel before most of the time,
but there are also many words where it is wrong.

=item * Words with accented vowels

This program treats all accented vowels equally. Accents are usually
relevant only for indicating stress, which is hardly ever marked in Hebrew,
but in some words they may affect pronunciation.

=item * Segol is always used for the sound of e

One day this program may become more clever one day and use tsere and segol
in a way that is closer to standard Hebrew vocalization. Until then... well,
very few people will notice anyway :)

=back

Please report any words that this program transliterates incorrectly
as well as any other bugs or feature requests as issues at
L<https://github.com/amire80/ita2heb>.

=head1 DEPENDENCIES

=over

=item * Readonly.pm.

=item * List::MoreUtils

=back

=head1 CONFIGURATION AND ENVIRONMENT

Nothing special.

=head1 INCOMPATIBILITIES

This program doesn't work with Perl earlier than 5.10 and with non-Unicode strings.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lingua::IT::Ita2heb

You can also look for information at:

=over

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

I thank all my Italian and Hebrew teachers.

I thank Shlomi Fish for important technical support
and refactoring the tests.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Amir E. Aharoni.

This program is free software; you can redistribute it and
modify it under the terms of either:

=over

=item * the GNU General Public License version 3 as published
by the Free Software Foundation.

=item * or the Artistic License version 2.0.

=back

See http://dev.perl.org/licenses/ for more information.

=cut
