#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 2;
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

    # TEST
    ok (scalar('a' ~~ @{$obj->all_latin_vowels}),
        "a is contained in all latin vowels",
    );
}
