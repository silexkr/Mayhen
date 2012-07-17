use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Silex::Web::Donnenwa';
use Silex::Web::Donnenwa::Controller::Deposit;

ok( request('/deposit')->is_success, 'Request should succeed' );
done_testing();
