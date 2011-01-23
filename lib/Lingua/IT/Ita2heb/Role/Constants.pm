package Lingua::IT::Ita2heb::Role::Constants;

use 5.010;
use strict;
use warnings;
use utf8;
use charnames ':full';

our $VERSION = '0.01';

use Moose::Role;
 
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
my @ALL_LATIN_VOWELS =
    (@TYPES_OF_A, @TYPES_OF_E, @TYPES_OF_I, @TYPES_OF_O, @TYPES_OF_U);

sub all_latin_vowels
{
    return \@ALL_LATIN_VOWELS;
}

no Moose::Role;

1;    # End of Lingua::IT::Ita2heb::Role::Constants

__END__

=head1 NAME

Lingua::IT::Ita2heb::Role::Constants - a role for the constants we are using.

=head1 DESCRIPTION

A role for the constants we are using.

=head1 VERSION

Version 0.01

=head1 AUTHOR

Amir E. Aharoni, C<< <amir.aharoni at mail.huji.ac.il> >>
and Shlomi Fish ( L<http://www.shlomifish.org/> ).

=head1 SYNOPSIS

    package MyClass;

    use Moose;

    with ('Lingua::IT::Ita2heb::Role::Constants');

    no Moose;

    package main;

    my $obj = MyClass->new();

=head1 METHODS

=head2 all_latin_vowels

Returns a reference to an array with all the Latin/Italian vowels.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lingua::IT::Ita2heb::Role::Constants

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
