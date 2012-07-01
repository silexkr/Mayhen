use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Silex::Web::Donnenwa';
use Silex::Web::Donnenwa::Controller::List;

ok( request('/list')->is_success, 'Request should succeed' );
done_testing();
