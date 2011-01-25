package Lingua::IT::Ita2heb::LettersSeq::IT::ToHeb;

use 5.010;
use strict;
use warnings;

use Readonly;

use Moose;

extends(
    'Lingua::IT::Ita2heb::LettersSeq::IT'
);

with( 'Lingua::IT::Ita2heb::Role::Constants::Hebrew' );

has next_letter_error_code =>
(
    is => 'ro',
    isa => 'Str',
    default => 'NEXT_LETTER',
);

has all_hebrew_vowels =>
(
    is => 'ro',
    isa => 'ArrayRef[Str]',
    lazy_build => 1,
);

has disable_rafe => (
    is => 'ro',
    isa => 'Bool',
);

has disable_dagesh => (
    is => 'ro',
    isa => 'Bool',
    traits => ['Bool'],
    handles => {
        dagesh_enabled => 'not',
    },
);

has '_simple_trs' => (
    is => 'ro',
    isa => 'HashRef[Str]',
    lazy_build => 1,
);

sub _build__simple_trs {
    my $seq = shift;

    return +{
        'b' => $seq->heb('BET'),
        'd' => $seq->heb('DALET'),
        (map { $_ => $seq->heb('SEGOL') } @{$seq->types_of_e}),
        'k' => $seq->heb('QOF'),
        'l' => $seq->heb('LAMED'),
        (map { $_ => $seq->heb('HOLAM_MALE') } @{$seq->types_of_o}),
        'p' => $seq->heb('PE'),
        'r' => $seq->heb('RESH'),
        't' => $seq->heb('TET'),
        'x' => $seq->heb('SHIN'), # This isn't right, of course
    };
}

has handled_letters => (
    isa => 'HashRef[Str]',
    is => 'ro',
    lazy_build => 1,
);

sub _build_handled_letters {
    my $seq = shift;

    return +{ (map { $_ => "_handle_letter_$_" } qw(c f g h m n q s v z)),
        (map { $_ => "_handle_letter_a" } @{$seq->types_of_a}),
        (map { $_ => "_handle_letter_i" } @{$seq->types_of_i}),
        (map { $_ => "_handle_letter_u" } @{$seq->types_of_u}),
        (map { $_ => "_handle_simple_tr_letter" } 
            keys(%{$seq->_simple_trs})
        ),
    };
}

sub _build_all_hebrew_vowels {
    my ($self) = @_;
    return [ $self->list_heb( qw( QAMATS HATAF_QAMATS PATAH HATAF_PATAH
        TSERE SEGOL HATAF_SEGOL HIRIQ HIRIQ_MALE HOLAM HOLAM_MALE QUBUTS SHURUK)
    ) ];
}

sub add_heb_final {
    my ($seq, @args) = @_;

    return $seq->add_final(map { $seq->heb($_) } @args);
}

sub add_heb {
    my ($seq, $latinized_spec) = @_;

    return $seq->add( $seq->heb( $latinized_spec ) );
}

sub handle_letter {
    my ($seq, $letter) = @_;

    my $meth = $seq->handled_letters->{$letter};

    return $seq->$meth($letter);
}

sub _handle_simple_tr_letter {
    my ($seq, $letter) = @_;

    $seq->add( $seq->_simple_trs->{$letter} );

    return;
}

sub _handle_letter_a {
    my ($seq) = @_;

    $seq->add_heb($seq->closed_syllable ? 'PATAH' : 'QAMATS');

    return;
}

sub _handle_letter_c {
    my ($seq) = @_;

    if (
        not(    $seq->match_before([['s']]) 
                and $seq->match_cg_mod_after([]))
    )
    {
        $seq->add_heb(
            $seq->set_optional_cg_geresh([['c']]) ? 'TSADI' : 'QOF'
        );
    }
    
    return;
}

sub _handle_letter_f {
    my ($seq) = @_;

    if (! $seq->add_heb_final('PE', 'FINAL_PE')) {
        if ($seq->at_start and not $seq->disable_rafe)
        {
            $seq->add_heb('RAFE');
        }
    }

    return;
}

sub _handle_letter_g {
    my ($seq) = @_;

    $seq->set_optional_cg_geresh([['g']]);

    if ($seq->match_after([['n']]))
    {
        $seq->add_heb('NUN,SHEVA,YOD');
    }
    elsif (
        not(
            $seq->after_start
                and $seq->match_after([['l']])
        )
    )
    {
        $seq->add_heb('GIMEL');
    }

    return;
}

sub _handle_letter_h {
    return; # Niente.
}

sub _handle_letter_i {
    my ($seq) = @_;

    if ( # No [i] in sci, except end of word
        not(
            $seq->before_end
                and $seq->match_before([['s'],['c']])
        )
    )
    {
        if ($seq->add_geresh) {
            if (not $seq->match_vowel_after )
            {
                $seq->add_heb('HIRIQ')
            }
        }
        elsif ($seq->match_vowel_after)
        {
            if (   $seq->at_start
                    or $seq->match_vowel_before) {
                $seq->add_heb('YOD')
            }
            else {
                $seq->add_heb('SHEVA,YOD')
            }
        }
        else {
            $seq->add_heb('HIRIQ_MALE')
        }
    }

    return;
}

sub _handle_letter_n {
    my ($seq) = @_;

    if ( $seq->match_before([['g']]) )
    {
        return $seq->next_letter_error_code;
    }

    $seq->add_heb_final('NUN', 'FINAL_NUN');

    return;
}

sub _handle_letter_m {
    my ($seq) = @_;

    $seq->add_heb_final('MEM', 'FINAL_MEM');

    return;
}

sub _handle_letter_q {
    my ($seq) = @_;

    if ( $seq->match_before([['c']]) )
    {
        if ($seq->dagesh_enabled) {
            $seq->add_heb('DAGESH');
        }
    }
    else {
        $seq->add_heb('QOF');
    }

    $seq->add_heb('SHEVA,VAV');

    return;
}

sub _handle_letter_s {
    my ($seq) = @_;

    if (    $seq->match_vowel_before
            and $seq->match_vowel_after
    )
    {
        $seq->add_heb('ZAYIN');
    }
    elsif ($seq->match_cg_mod_after([['c']]))
    {
        $seq->add_heb('SHIN');
    }
    else {
        $seq->add_heb('SAMEKH');
    }

    return;
}

sub _handle_letter_u {
    my ($seq) = @_;

    if ($seq->match_before([['q']]))
    {
        return $seq->next_letter_error_code;
    }
    else {
        $seq->add_heb('SHURUK');
    }

    return;
}

sub _handle_letter_v {
    my ($seq) = @_;

    $seq->add_heb($seq->does_v_require_bet ? 'BET' : 'VAV');

    return;
}

sub _handle_letter_z {
    my ($seq) = @_;

    if ($seq->at_start) {
        $seq->add_heb('DALET,DAGESH,SHEVA,ZAYIN');
    }
    else {
        $seq->add_heb_final('TSADI', 'FINAL_TSADI');
    }

    return;
}

{
    my %map = (map { $_ => 1 } qw(b p));

    sub requires_dagesh_phonetic {
        my ($seq) = @_;

        return exists($map{$seq->current});
    }
}

{
    my @REQUIRES_DAGESH_LENE = __PACKAGE__->list_heb( qw(GIMEL DALET) );

    sub text_to_add_requires_dagesh_lene {
        my ($seq) = @_;

        return $seq->text_to_add ~~ @REQUIRES_DAGESH_LENE;
    }
}

{
    my @VOWEL_BEFORE_GERESH = __PACKAGE__->list_heb( 
        qw(QAMATS PATAH TSERE SEGOL HIRIQ) 
    );

    sub _text_to_add_requires_before_geresh {
        my ($seq) = @_;

        return $seq->text_to_add ~~ @VOWEL_BEFORE_GERESH;
    }
}

{
    my @VOWEL_AFTER_GERESH = __PACKAGE__->list_heb( qw(HOLAM_MALE SHURUK) );

    sub _text_to_add_requires_after_geresh {
        my ($seq) = @_;

        return $seq->text_to_add ~~ @VOWEL_AFTER_GERESH;
    }
}

sub should_add_dagesh {
    my ($seq) = @_;

    return
    (
        $seq->requires_dagesh_phonetic
            or
        ($seq->geminated and $seq->dagesh_enabled)   # Dagesh geminating
            or 
        (
            (not $seq->match_vowel_before)
                and $seq->text_to_add_requires_dagesh_lene
                and (not $seq->requires_dagesh_phonetic)
        )
    );
}

sub add_dagesh_if_needed {
    my ($seq) = @_;

    if ( $seq->should_add_dagesh )
    {
        if ($seq->text_to_add ne $seq->heb('RESH')) {
            $seq->add_heb('DAGESH');
        }

        $seq->unset_geminated;
    }

    return;
}

sub _add_geresh_cond {
    my ($seq, $predicate) = @_;

    return ($seq->add_geresh and $seq->$predicate());
}

sub requires_after_geresh {
    return shift->_add_geresh_cond('_text_to_add_requires_after_geresh');
}

sub requires_before_geresh {
    return shift->_add_geresh_cond('_text_to_add_requires_before_geresh');
}

1;    # End of Lingua::IT::Ita2heb::LettersSeq::IT::ToHeb

__END__

=head1 NAME

Lingua::IT::Ita2heb::LettersSeq::IT::ToHeb - Italian-to-Hebrew specific 
subclass of Lingua::IT::Ita2heb::LettersSeq::IT

=head1 DESCRIPTION

A converter of letters from Italian to Hebrew.

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Lingua::IT::Ita2heb::LettersSeq::IT::ToHeb;

    my $seq = Lingua::IT::Ita2heb::LettersSeq::IT::ToHeb->new(
        {
            ita_letters => \@ita_letters,
            disable_rafe => ($option{disable_rafe} ? 1 : 0),
            disable_dagesh => ($option{disable_dagesh} ? 1 : 0),
        }
    );

=head1 METHODS

=head2 $seq->all_hebrew_vowels()

Returns an array ref of all Hebrew vowels.


=head2 $seq->add_heb_final($non_final, $final)

Adds the Hebrew as given by $non_final and $final by first calling
C<< ->heb() >> on them.

=head2 $seq->add_heb($latinized_spec)

Adds the Hebrew Latinized spec $latinized_spec after converting it to the
Hebrew glyphs.

=head2 $seq->dagesh_enabled

The opposite of $seq->disable_dagesh .

=head2 $seq->handled_letters()

Returns a lookup table of the letters that the object can handle.

=head2 $seq->handle_letter($letter)

Handles the Latin letter $letter.

=head2 $seq->requires_dagesh_phonetic()

Whether the current letter requires a dagesh phonetic (b or p).

=head2 $seq->text_to_add_requires_dagesh_lene()

=head2 $seq->requires_after_geresh()

=head2 $seq->requires_before_geresh()

=head2 $seq->should_add_dagesh()

This predicate determines if a dagesh is needed to be added after the current
letter.

=head2 $seq->add_dagesh_if_needed()

Determines if a dagesh is needed and if so adds it.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lingua::IT::Ita2heb::LettersSeq::IT

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

=head1 AUTHOR

Amir E. Aharoni, C<< <amir.aharoni at mail.huji.ac.il> >>
and Shlomi Fish ( L<http://www.shlomifish.org/> ).

=cut
