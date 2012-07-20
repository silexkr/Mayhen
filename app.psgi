use strict;
use warnings;
use Plack::Builder;
use Silex::Web::Donnenwa;

my $app = Silex::Web::Donnenwa->apply_default_middlewares(Silex::Web::Donnenwa->psgi_app);
builder {
	enable 'Static', path => qr{^(?:/static/|/favicon\.ico)}, root => Silex::Web::Donnenwa->path_to('root');
    $app;
};

