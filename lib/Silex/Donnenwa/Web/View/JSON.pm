package Silex::Donnenwa::Web::View::JSON;

use strict;
use Moose;
use JSON::XS ();
extends 'Catalyst::View::JSON';

my $encoder =
JSON::XS->new->utf8->pretty(0)->indent(1)->allow_blessed(1)->convert_blessed(1);

sub encode_json {
    my( $self, $c, $data ) = @_;
    $encoder->encode( $data );
}

1;
