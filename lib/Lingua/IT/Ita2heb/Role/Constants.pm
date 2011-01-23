package Lingua::IT::Ita2heb::Role::Constants;

use 5.010;
use strict;
use warnings;

our $VERSION = '0.01';

use Moose::Role;


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
