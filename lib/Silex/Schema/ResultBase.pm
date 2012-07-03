package Silex::Schema::ResultBase;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/
    InflateColumn::DateTime
/);

__PACKAGE__->meta->make_immutable;

1;
