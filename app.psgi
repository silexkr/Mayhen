use strict;
use warnings;

use Silex::Web::Donnenwa;

my $app = Silex::Web::Donnenwa->apply_default_middlewares(Silex::Web::Donnenwa->psgi_app);
$app;

