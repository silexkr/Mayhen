use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Silex::Web::Donnenwa';
use Silex::Web::Donnenwa::Controller::Login;

ok( request('/login')->is_success, 'Request should succeed' );
done_testing();
