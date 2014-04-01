use strict;
use warnings;
use Plack::Builder;
use Silex::Mayhen::Web;

my $app = Silex::Mayhen::Web->apply_default_middlewares(Silex::Mayhen::Web->psgi_app(@_));
builder {
    enable 'Static', path => qr{^(?:/static/|/favicon\.ico)}, root => Silex::Mayhen::Web->path_to('root');
    enable "Plack::Middleware::ReverseProxy";
    $app;
};
