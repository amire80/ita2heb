#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 1;
use charnames ':full';

package MyClass;

use Moose;

with ('Lingua::IT::Ita2heb::Role::Constants');

no Moose;

package main;

{
    my $obj = MyClass->new;

    # TEST
    ok ($obj, "Object was initialized.");
}
