package Lingua::IT::Ita2heb::LettersSeq;

use 5.010;
use strict;
use warnings;

use Moose;

our $VERSION = '0.01';

has ita_letters => (isa => 'ArrayRef[Str]', is => 'ro');
has idx => (isa => 'Int', traits => ['Number'], is => 'rw', 
    handles => { add_to_idx => 'add',}, default => 0,
);

1;    # End of Lingua::IT::Ita2heb::LettersSeq

__END__

=head1 NAME

Lingua::IT::Ita2heb::LettersSeq - abstract a sequence of letters.

=head1 DESCRIPTION

A sequence of letters.

=head1 VERSION

Version 0.01

=head1 AUTHOR

Amir E. Aharoni, C<< <amir.aharoni at mail.huji.ac.il> >>
and Shlomi Fish ( L<http://www.shlomifish.org/> ).

=head1 SYNOPSIS

    use Lingua::IT::Ita2heb::LettersSeq;

    my $seq = Lingua::IT::Ita2heb::LettersSeq->new(
        {
            ita_letters => \@ita_letters,  
        }
    );

=head1 METHODS

=head2 ita_letters

The letters in the sequence. An array reference.

=head2 idx

The index. An integer.

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
