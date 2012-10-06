package Silex::Donnenwa::Trait::WithAPI;
use Moose::Role;
use namespace::autoclean;

has apis => (
    is => 'rw',
    isa => 'HashRef[Object]',
    lazy_build => 1,
);

has opts => (
    is => 'rw',
    isa => 'HashRef',
    default => sub { +{} }
);

sub find {
    my ($self, $key) = @_;
    my $api = $self->apis->{$key};
    if (!$api) {
        confess "API by key $key was not found for $self";
    }
    $api;
}

no Moose::Role;

1;