package Silex::Donnenwa::DonAPI::Charge;
use Moose;
use namespace::autoclean;
use Data::Dumper;
with qw/Silex::Donnenwa::Trait::WithDBIC/;

sub get_search {
	my ( $self, $cond, $attr ) = @_;

	return $self->resultset('Charge')->search($cond, $attr);
}

1;