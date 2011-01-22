package Lingua::IT::Ita2heb::LettersSeq::IT;

use 5.010;
use strict;
use warnings;

use Moose;

extends(
    'Lingua::IT::Ita2heb::LettersSeq'
);

has '_ALL_LATIN_VOWELS' =>
(
    is => 'ro',
    isa => 'ArrayRef[Str]',
);

our $VERSION = '0.01';

my $NO_CLOSED_PAST_THIS => 3;

sub closed_syllable {
    my ($self) = @_;

    if ($self->_count - 1 - $self->idx() < $NO_CLOSED_PAST_THIS) {
        return 0;
    }

    for my $offset (1, 2) {
        if ($self->_letter($self->idx+$offset) ~~ @{$self->_ALL_LATIN_VOWELS}) {
            return 0;
        }
    }

    return 1;

}

1;    # End of Lingua::IT::Ita2heb::LettersSeq::IT

__END__

=head1 NAME

Lingua::IT::Ita2heb::LettersSeq::IT - Italian-specific subclass of Lingua::IT::Ita2heb::LettersSeq

=head1 DESCRIPTION

A sequence of letters in Italian.

=head1 VERSION

Version 0.01

=head1 AUTHOR

Amir E. Aharoni, C<< <amir.aharoni at mail.huji.ac.il> >>
and Shlomi Fish ( L<http://www.shlomifish.org/> ).

=head1 SYNOPSIS

    use Lingua::IT::Ita2heb::LettersSeq::IT;

    my $seq = Lingua::IT::Ita2heb::LettersSeq::IT->new(
        {
            ita_letters => \@ita_letters,  
            _ALL_LATIN_VOWELS => \@ALL_LATIN_VOWELS,
        }
    );

=head1 METHODS

=head2 $seq->closed_syllable()

Checks that the current letter is a closed syllable.

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
