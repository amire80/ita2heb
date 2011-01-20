#!perl -T

use Test::More tests => 24;
use Lingua::IT::Ita2heb;

ok( Lingua::IT::Ita2heb::ita_to_heb('a') eq 'אָה',   'a' );
ok( Lingua::IT::Ita2heb::ita_to_heb('à') eq 'אָה',   'a with grave' );
ok( Lingua::IT::Ita2heb::ita_to_heb('á') eq '?',    'a with acute' );
ok( Lingua::IT::Ita2heb::ita_to_heb('b') eq 'בּ',    'b' );
ok( Lingua::IT::Ita2heb::ita_to_heb('d') eq 'ד',    'd' );
ok( Lingua::IT::Ita2heb::ita_to_heb('e') eq 'אֶה',   'e' );
ok( Lingua::IT::Ita2heb::ita_to_heb('è') eq 'אֶה',   'e with grave' );
ok( Lingua::IT::Ita2heb::ita_to_heb('é') eq 'אֶה',   'e with acute' );
ok( Lingua::IT::Ita2heb::ita_to_heb('f') eq 'פֿ',    'f' );
ok( Lingua::IT::Ita2heb::ita_to_heb('f', disable_rafe => 1) eq 'פ', 'f without rafe' );
ok( Lingua::IT::Ita2heb::ita_to_heb('i') eq 'אִי',   'i' );
ok( Lingua::IT::Ita2heb::ita_to_heb('ì') eq 'אִי',   'i with grave' );
ok( Lingua::IT::Ita2heb::ita_to_heb('í') eq 'אִי',   'i with acute' );
ok( Lingua::IT::Ita2heb::ita_to_heb('î') eq 'אִי',   'i with circumflex' );
ok( Lingua::IT::Ita2heb::ita_to_heb('k') eq 'ק',    'k' );
ok( Lingua::IT::Ita2heb::ita_to_heb('l') eq 'ל',    'l' );
ok( Lingua::IT::Ita2heb::ita_to_heb('m') eq 'מ',    'm' ); # XXX sofit?
ok( Lingua::IT::Ita2heb::ita_to_heb('n') eq 'נ',    'n' ); # XXX sofit?
ok( Lingua::IT::Ita2heb::ita_to_heb('o') eq 'אוֹ',   'o' );
ok( Lingua::IT::Ita2heb::ita_to_heb('p') eq 'פּ',    'p' ); # not sofit!
ok( Lingua::IT::Ita2heb::ita_to_heb('r') eq 'ר',    'r' );
ok( Lingua::IT::Ita2heb::ita_to_heb('s') eq 'ס',    's' );
ok( Lingua::IT::Ita2heb::ita_to_heb('t') eq 'ט',    't' );
ok( Lingua::IT::Ita2heb::ita_to_heb('u') eq 'אוּ',   'u' );

diag( "Testing Lingua::IT::Ita2heb $Lingua::IT::Ita2heb::VERSION, Perl $], $^X" );
