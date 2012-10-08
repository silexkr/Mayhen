package Silex::Donnenwa::DonAPI::User;
use Moose;
use namespace::autoclean;
use Data::Dumper;
with qw/Silex::Donnenwa::Trait::WithDBIC/;

sub search {
	my ( $self, $cond, $attr ) = @_;

	return $self->resultset('User')->search($cond, $attr);
}

1;