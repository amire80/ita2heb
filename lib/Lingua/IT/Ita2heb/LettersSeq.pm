package Lingua::IT::Ita2heb::LettersSeq;

use 5.010;
use strict;
use warnings;

use Moose;

our $VERSION = '0.01';

has ita_letters => (
    isa => 'ArrayRef[Str]',
    is => 'ro', 
    traits => ['Array'],
    handles => {
        '_letter' => 'get',
        '_count' => 'count',
    },
);

has idx => (isa => 'Int', traits => ['Number'], is => 'rw', 
    handles => { add_to_idx => 'add',}, default => -1,
);

has wrote_vowel => (
    isa => 'Bool',
    is => 'ro',
    traits => ['Bool'],
    default => 0,
    handles =>
    {
        'set_wrote_vowel' => 'set',
        'unset_wrote_vowel' => 'unset',
    },
);

sub current
{
    my ($self) = @_;

    return $self->_letter($self->idx());
}

sub next_index {
    my ($self) = @_;

    if ($self->idx() == $self->_count - 1)
    {
        return;
    }
    else
    {
        $self->add_to_idx(1);

        return $self->idx();
    }
}

sub at_start {
    my ($self) = @_;

    return ($self->idx == 0);
}

sub after_start {
    my ($self) = @_;

    return !($self->at_start);
}

sub before_end {
    my ($self) = @_;

    return ($self->idx < ($self->_count - 1));
}

sub at_end {
    my ($self) = @_;

    return (not $self->before_end);
}

sub match_places {
    my ($self, $start_offset, $sets_seq) = @_;

    foreach my $i (0 .. $#{$sets_seq}) {
        my $let_idx = $self->idx() + $start_offset + $i;

        if (($let_idx < 0) || ($let_idx >= $self->_count))
        {
            die "Letter index '$let_idx' is out of range.";
        }

        if (
            not $self->_letter($let_idx)
            ~~ @{ $sets_seq->[$i] })
        {
            return;
        }
    }

    return 1;
}

sub safe_match_places {
    my ($self, $start_offset, $sets_seq) = @_;

    if ($self->idx + $start_offset >= 0) {
        return $self->match_places($start_offset, $sets_seq);
    }
    else {
        return;
    }
}

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

=head2 current

The current letter at index idx.

=head2 next_index

Increment the index and return it.

=head2 at_start

Determines whether this is the start of the sequence (index No. 0).

=head2 after_start

After the start (Index larger than 1).

=head2 at_end

This is the last letter in the sequence.

=head2 before_end

This is before the end. C<!$self-at_end>.

=head2 $seq->match_places($start_offset, \@sets_seq)

Match places from $start_offset onwards with @sets_seq .

=head2 $seq->safe_match_places($start_offset, \@sets_seq)

Like match_places but return false if $start_offset is too small.

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
