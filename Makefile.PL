use strict;
use warnings;
use ExtUtils::MakeMaker;

## no critic

WriteMakefile(
    NAME          => 'Lingua::IT::Ita2heb',
    AUTHOR        => q{Amir E. Aharoni <amir.aharoni@mail.huji.ac.il>},
    VERSION_FROM  => 'lib/Lingua/IT/Ita2heb.pm',
    ABSTRACT_FROM => 'lib/Lingua/IT/Ita2heb.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ('LICENSE' => 'perl')
        : ()),
    PL_FILES  => {},
    PREREQ_PM => { 
        'Moose' => 0,
        'Test::More' => 0, 
        'List::MoreUtils' => 0,
    },
    dist      => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Lingua-IT-Ita2heb-*' },
);
