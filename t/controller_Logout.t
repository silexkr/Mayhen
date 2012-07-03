use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Silex::Web::Donnenwa';
use Silex::Web::Donnenwa::Controller::Logout;

ok( request('/logout')->is_success, 'Request should succeed' );
done_testing();
