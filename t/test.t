# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use Test::More tests => 4;
use_ok('WWW::MakeAShorterLink');

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

ok (makeashorterlink('http://dave.org.uk/scripts/webged-1.02.tar.gz')
    eq 'http://makeashorterlink.com/?M328231A1');

ok (makealongerlink('http://makeashorterlink.com/?M328231A1')
    eq 'http://dave.org.uk/scripts/webged-1.02.tar.gz');

ok (makealongerlink('M328231A1')
    eq 'http://dave.org.uk/scripts/webged-1.02.tar.gz');
