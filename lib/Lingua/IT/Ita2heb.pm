package Lingua::IT::Ita2heb;

use 5.010;

use strict;
use warnings;
use utf8;
use charnames ':full';

use Carp;

use Readonly;

use List::MoreUtils ();

use Lingua::IT::Ita2heb::LettersSeq::IT;

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
my $TRUE_MAQAF   = "\N{HEBREW PUNCTUATION MAQAF}";

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
    'y',    # XXX
    'j',    # XXX
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

my @REQUIRES_DAGESH_PHONETIC = qw(b p);

# Dagesh qal.
# BET and PE must not change according to these rules in transliterated
# Italian and KAF and TAV are not needed in Italian at all.
# Dagesh qal in GIMEL and DALET is totally artificial, but it's part
# of the standard...
my @REQUIRES_DAGESH_LENE = ($GIMEL, $DALET);

my @VOWEL_BEFORE_GERESH = ($QAMATS, $PATAH, $TSERE, $SEGOL, $HIRIQ);
my @VOWEL_AFTER_GERESH = ($HOLAM_MALE, $SHURUK);

Readonly my $NO_CLOSED_PAST_THIS => 3;
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
    'x' => $SHIN, # This isn't right, of course
);

sub ita_to_heb {    ## no critic (Subroutines::ProhibitExcessComplexity)
    my ($ita, %option) = @_;

    my $GERESH = $option{ascii_geresh} ? q{'} : $TRUE_GERESH;
    my $MAQAF  = $option{ascii_maqaf}  ? q{-} : $TRUE_MAQAF;

    my $heb = q{};

    my %PUNCTUATION_REPLACEMENTS = (q{ }, q{ }, q{-}, $MAQAF, q{'}, q{'},);

    # Recursion on punctuation marks
    foreach my $punctuation_mark (q{ }, q{-}, q{'}) {    # order is important
        ## no critic (RegularExpressions::RequireExtendedFormatting)
        my $punctuation_re = qr/$punctuation_mark/ms;
        if ($ita =~ $punctuation_re) {
            return join $PUNCTUATION_REPLACEMENTS{$punctuation_mark},
                map { ita_to_heb($_) } split $punctuation_re, $ita;
        }
    }

    my @ita_letters = split qr//xms, lc $ita;

    my $add_geresh  = 0;

    my $seq = Lingua::IT::Ita2heb::LettersSeq::IT->new(
        {
            ita_letters => \@ita_letters,
        }
    );

    ITA_LETTER:
    while (defined($seq->next_index)) {

        my $ita_letter = $seq->current;

        if ($seq->should_add_alef)
        {
            $heb .= $ALEF;
        }

        if ($seq->try_geminated)
        {
            next ITA_LETTER;
        }

        $seq->unset_wrote_vowel;

        given ($ita_letter) {
            when (%SIMPLE_TRANSLITERATIONS) {
                $seq->add( $SIMPLE_TRANSLITERATIONS{$_} );
            }
            when (@TYPES_OF_A) {
                if ($seq->closed_syllable()) {
                    $seq->add( $PATAH );
                }
                else {
                    $seq->add( $QAMATS );
                }
            }
            when ('c') {
                if (
                    not(    $seq->match_before([['s']]) 
                        and $seq->match_cg_mod_after([]))
                )
                {
                    if (
                        $seq->match_optional_cg([['c']])
                    )
                    {
                        $seq->add( $TSADI );
                        $add_geresh = 1;
                    }
                    else {
                        $seq->add( $QOF );
                    }
                }
            }
            when ('f') {
                if (! $seq->add_final($PE, $FINAL_PE)) {
                    if ($seq->at_start and not $option{'disable_rafe'})
                    {
                        $seq->add( $RAFE );
                    }
                }
            }
            when ('g') {
                if ( $seq->match_optional_cg([['g']]) )
                {
                    $add_geresh = 1;
                }

                if ($seq->match_after([['n']]))
                {
                    $seq->add( $NUN . $SHEVA . $YOD );
                }
                elsif (
                    not(
                        $seq->after_start
                        and $seq->match_after([['l']])
                    )
                )
                {
                    $seq->add( $GIMEL );
                }
            }
            when ('h') {    # Niente.
            }
            when (@TYPES_OF_I) {
                if ( # No [i] in sci, except end of word
                    not(
                        $seq->before_end
                        and $seq->match_before([['s'],['c']])
                    )
                )
                {
                    if ($add_geresh) {
                        if (not $seq->match_vowel_after )
                        {
                            $seq->add( $HIRIQ );
                        }
                    }
                    elsif ($seq->match_vowel_after)
                    {
                        if (   $seq->at_start
                            or $seq->match_vowel_before) {
                            $seq->add( $YOD );
                        }
                        else {
                            $seq->add( $SHEVA . $YOD );
                        }
                    }
                    else {
                        $seq->add( $HIRIQ_MALE );
                    }
                }
            }
            when ('m') {
                $seq->add_final($MEM, $FINAL_MEM);
            }
            when ('n') {
                if ( $seq->match_before([['g']]) )
                {
                    next ITA_LETTER;
                }

                $seq->add_final($NUN, $FINAL_NUN);
            }
            when ('q') {
                if ( $seq->match_before([['c']]) )
                {
                    if (not $option{disable_dagesh}) {
                        $seq->add( $DAGESH );
                    }
                }
                else {
                    $seq->add( $QOF );
                }

                $seq->add( $SHEVA . $VAV );
            }
            when ('s') {
                if (    $seq->match_vowel_before
                    and $seq->match_vowel_after
                )
                {
                    $seq->add( $ZAYIN );
                }
                elsif ($seq->match_cg_mod_after([['c']]))
                {
                    $seq->add( $SHIN );
                }
                else {
                    $seq->add( $SAMEKH );
                }
            }
            when (@TYPES_OF_U) {
                if ($seq->match_before([['q']]))
                {
                    next;
                }
                else {
                    $seq->add( $SHURUK );
                }
            }
            when ('v') {
                if ($seq->does_v_require_bet)
                {
                    $seq->add( $BET );
                }
                else {
                    $seq->add( $VAV );
                }
            }
            when ('z') {
                if ($seq->at_start) {
                    $seq->add( $DALET . $DAGESH . $SHEVA . $ZAYIN );
                }
                else {
                    $seq->add_final($TSADI, $FINAL_TSADI);
                }
            }
            default {
                $seq->add(q{?});
                carp("Unknown letter $ita_letter in the source.");
            }
        }

        if (
            $ita_letter ~~ @REQUIRES_DAGESH_PHONETIC  # Dagesh phonetic (b, p)
            or
            ($seq->geminated and not $option{disable_dagesh})   # Dagesh geminating
            or (
                (not $seq->match_vowel_before)
                and $seq->text_to_add ~~ @REQUIRES_DAGESH_LENE
                and not($ita_letter ~~ @REQUIRES_DAGESH_PHONETIC)
            )
            )
        {
            if ($seq->text_to_add ne $RESH) {
                $seq->add($DAGESH);
            }

            $seq->unset_geminated;
        }

        if ($add_geresh and $seq->text_to_add ~~ [@VOWEL_AFTER_GERESH]) {
            $heb .= $GERESH;
            $add_geresh = 0;
        }

        $heb .= $seq->text_to_add;

        if ($seq->should_add_sheva)
        {
            $heb .= $SHEVA;
        }

        if ($add_geresh and $seq->text_to_add ~~ @VOWEL_BEFORE_GERESH) {
            $heb .= $GERESH;

            if ($seq->text_to_add eq $HIRIQ) {
                $heb .= $YOD;
            }

            $add_geresh = 0;
        }

        if ($seq->at_end) {
            if ($seq->text_to_add ~~ [ $QAMATS, $SEGOL ]) {
                $heb .= $HE;
            }
        }

        if ($seq->text_to_add ~~ @ALL_HEBREW_VOWELS) {
            $seq->set_wrote_vowel;
        }
    }

    return $heb;
}

sub closed_syllable {
    my ($letters_ref, $letter_index) = @_;

    my $seq = Lingua::IT::Ita2heb::LettersSeq::IT->new(
        {
            ita_letters => $letters_ref,
            idx => $letter_index,
        },
    );

    return $seq->closed_syllable();
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

=item * ascii_maqaf

By default, Unicode HEBREW PUNCTUATION MAQAF is used to indicate
the hyphen. This is the true Hebrew hyphen at the top of the line.
If you prefer to use the ASCII hyphen (minus), run it like this:

    my $hebrew_word = Lingua::IT::Ita2heb::ita_to_heb('Emilia-Romagna', ascii_maqaf => 1);

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
