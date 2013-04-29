use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Silex::Donnenwa::Web';
use Silex::Donnenwa::Web::Controller::Main;

ok( request('/main')->is_success, 'Request should succeed' );
done_testing();
