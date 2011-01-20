package Lingua::IT::Ita2heb;

use 5.10.0;

use strict;
use warnings;
use utf8;

use Carp;

=head1 NAME

Lingua::IT::Ita2heb - Transliterate words in Italian into vocalized Hebrew.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

my $ALEPH           = 'א';
my $BET             = 'ב';
my $GIMEL           = 'ג';
my $DALET           = 'ד';
my $HE              = 'ה';
my $VAV             = 'ו';
my $ZAYIN           = 'ז';
my $KHET            = 'ח';
my $TET             = 'ט';
my $YOD             = 'י';
my $KAF             = 'כ';
my $KAF_SOFIT       = 'ך';
my $LAMED           = 'ל';
my $MEM             = 'מ';
my $MEM_SOFIT       = 'ם';
my $NUN             = 'נ';
my $NUN_SOFIT       = 'ן';
my $SAMEKH          = 'ס';
my $AYIN            = 'ע';
my $PE              = 'פ';
my $PE_SOFIT        = 'ף';
my $TSADE           = 'צ';
my $TSADE_SOFIT     = 'ץ';
my $KOF             = 'ק';
my $RESH            = 'ר';
my $SHIN            = 'ש';
my $TAV             = 'ת';
my $KAMATS          = 'ָ';
my $KHATAF_KAMATS   = 'ֳ';
my $PATAKH          = 'ַ';
my $KHATAF_PATAKH   = 'ֲ';
my $TSERE           = 'ֵ';
my $SEGOL           = 'ֶ';
my $KHATAF_SEGOL    = 'ֱ';
my $KHIRIK          = 'ִ';
my $KHOLAM          = 'ֹ';
my $KUBUTS          = 'ֻ';
my $RAFE            = 'ֿ';

my $DAGESH = my $MAPIK = 'ּ';
my $KHOLAM_MALE = $VAV . $KHOLAM;
my $SHURUK      = $VAV . $DAGESH;
my $KHIRIK_MALE = $KHIRIK . $YOD;

my $LATIN_VOWEL = qr/aeiou/xms;

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

=cut

sub ita_to_heb {
    # options:
    # disable_rafe
    # disable_dagesh
    my ($ita, %options) = @_;

    my $heb = q{};
    my $word_init = 1;
    
    my @ita_letters = split qr//, lc $ita;

    foreach my $ita_letter_index (0 .. $#ita_letters) {
        my $ita_letter = $ita_letters[$ita_letter_index];
        
        if ($word_init and $ita_letter =~ $LATIN_VOWEL) {
            $heb .= $ALEPH;
        }
        
        my $hebrew_to_add;
        
        given ($ita_letter) {
            when ([qw(a à)]) {
                $hebrew_to_add = $KAMATS;
            }
            when ('b') {
                $hebrew_to_add = $BET . $DAGESH;
            }
            when ('d') {
                $hebrew_to_add = $DALET;
            }
            when ([qw (e è é)]) {
                $hebrew_to_add = $SEGOL;
            }
            when ('f') {
                $hebrew_to_add = $PE;

                if ($word_init and not $options{'disable_rafe'}) {
                    $hebrew_to_add .= $RAFE;
                }
            }
            when ([qw(i ì í î)]) {
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
            when ([qw(o ò ó)]) {
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
            when ([qw(i ù ú)]) {
                $hebrew_to_add = $SHURUK;
            }
            default {
                $hebrew_to_add = '?';
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

my $NO_CLOSED_PAST_THIS = 3;
sub closed_syllable {
    my ($letters_ref, $letter_index) = @_;
    
    if (($#{$letters_ref} - $letter_index) < $NO_CLOSED_PAST_THIS) {
        return 0;
    }
    
    for my $offset (1, 2) {
        if ($letters_ref->[$letter_index + $offset] =~ $LATIN_VOWEL) {
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
