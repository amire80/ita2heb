#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 1;
use charnames ':full';

use lib './t/lib';
use CheckItaTrans qw(start_log check_ita_tr);

start_log(__FILE__);

TODO: {
    local $TODO = 'Italian apostrophe is not properly handled yet';
    check_ita_tr(
        [q(Sant'Agata)],
        "\N{HEBREW LETTER SAMEKH}"
            . "\N{HEBREW POINT PATAH}"
            . "\N{HEBREW LETTER NUN}"
            . "\N{HEBREW POINT SHEVA}"
            . "\N{HEBREW LETTER TET}"
            . "\N{HEBREW PUNCTUATION MAQAF}"
            . "\N{HEBREW LETTER ALEF}"
            . "\N{HEBREW POINT QAMATS}"
            . "\N{HEBREW LETTER GIMEL}"
            . "\N{HEBREW POINT QAMATS}"
            . "\N{HEBREW LETTER TET}"
            . "\N{HEBREW POINT QAMATS}"
            . "\N{HEBREW LETTER HE}",
        q(Sant'Agata),
    );
}
