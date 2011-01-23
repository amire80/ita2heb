#!perl -T

use 5.010;
use strict;
use warnings;

use Test::More tests => 3;
use charnames ':full';

use lib './t/lib';
use CheckItaTrans qw(start_log check_ita_tr);

start_log(__FILE__);

my $EMILIA = "\N{HEBREW LETTER ALEF}"
    . "\N{HEBREW POINT SEGOL}"
    . "\N{HEBREW LETTER MEM}"
    . "\N{HEBREW POINT HIRIQ}"
    . "\N{HEBREW LETTER YOD}"
    . "\N{HEBREW LETTER LAMED}"
    . "\N{HEBREW POINT SHEVA}"
    . "\N{HEBREW LETTER YOD}"
    . "\N{HEBREW POINT QAMATS}"
    . "\N{HEBREW LETTER HE}";

my $ROMAGNA = "\N{HEBREW LETTER RESH}"
    . "\N{HEBREW LETTER VAV}"
    . "\N{HEBREW POINT HOLAM}"
    . "\N{HEBREW LETTER MEM}"
    . "\N{HEBREW POINT PATAH}"
    . "\N{HEBREW LETTER NUN}"
    . "\N{HEBREW POINT SHEVA}"
    . "\N{HEBREW LETTER YOD}"
    . "\N{HEBREW POINT QAMATS}"
    . "\N{HEBREW LETTER HE}";
        
check_ita_tr(
    [q(Emilia-Romagna)],
        $EMILIA
        . "\N{HEBREW PUNCTUATION MAQAF}"
        . $ROMAGNA,
    q(Emilia-Romagna),
);

check_ita_tr(
    [q(Emilia-Romagna), ascii_maqaf => 1],
        "$EMILIA-$ROMAGNA",
    q(Emilia-Romagna),
);

check_ita_tr(
    [q(Sant'Agata)],
    "\N{HEBREW LETTER SAMEKH}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER NUN}"
        . "\N{HEBREW POINT SHEVA}"
        . "\N{HEBREW LETTER TET}"
        . "\N{APOSTROPHE}"
        . "\N{HEBREW LETTER ALEF}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER GIMEL}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER TET}"
        . "\N{HEBREW POINT QAMATS}"
        . "\N{HEBREW LETTER HE}",
    q(Sant'Agata),
);
