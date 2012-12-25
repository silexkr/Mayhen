package Silex::Donnenwa::DonAPI::User;
use Moose;
use namespace::autoclean;
use Data::Dumper;
with qw/Silex::Donnenwa::Trait::WithDBIC/;

sub search {
	my ( $self, $cond, $attr ) = @_;

	return $self->resultset('User')->search($cond, $attr);
}

sub find {
	my ( $self, $cond, $attr ) = @_;

	return $self->resultset('User')->find($cond, $attr);
}

sub mobile_user {
    my ( $self, $args ) = @_;

    my ($name, $password) = split /:/,$args;

    return ($name, $password);
}

1;
