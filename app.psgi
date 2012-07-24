use strict;
use warnings;
use Plack::Builder;
use Silex::Donnenwa::Web;

my $app = Silex::Donnenwa::Web->apply_default_middlewares(Silex::Donnenwa::Web->psgi_app);
builder {
	enable 'Static', path => qr{^(?:/static/|/favicon\.ico)}, root => Silex::Donnenwa::Web->path_to('root');
    $app;
};

