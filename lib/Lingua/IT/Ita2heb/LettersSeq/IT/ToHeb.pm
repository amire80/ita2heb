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
);


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

sub handle_letter_c {
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

sub handle_letter_f {
    my ($seq) = @_;

    if (! $seq->add_heb_final('PE', 'FINAL_PE')) {
        if ($seq->at_start and not $seq->disable_rafe)
        {
            $seq->add_heb('RAFE');
        }
    }

    return;
}

sub handle_letter_g {
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

sub handle_letter_i {
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

sub handle_letter_a {
    my ($seq) = @_;

    $seq->add_heb($seq->closed_syllable ? 'PATAH' : 'QAMATS');

    return;
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

=head1 METHODS

=head2 $seq->all_hebrew_vowels()

Returns an array ref of all Hebrew vowels.

=head1 AUTHOR

Amir E. Aharoni, C<< <amir.aharoni at mail.huji.ac.il> >>
and Shlomi Fish ( L<http://www.shlomifish.org/> ).

=head1 SYNOPSIS

    use Lingua::IT::Ita2heb::LettersSeq::IT::ToHeb;

    my $seq = Lingua::IT::Ita2heb::LettersSeq::IT::ToHeb->new(
        {
            ita_letters => \@ita_letters,
        }
    );

=head1 METHODS

=head2 $seq->add_heb_final($non_final, $final)

Adds the Hebrew as given by $non_final and $final by first calling
C<< ->heb() >> on them.

=head2 $seq->add_heb($latinized_spec)

Adds the Hebrew Latinized spec $latinized_spec after converting it to the
Hebrew glyphs.

=head2 $seq->handle_letter_a

=head2 $seq->handle_letter_c

=head2 $seq->handle_letter_f

=head2 $seq->handle_letter_g

=head2 $seq->handle_letter_i

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

=cut
