package Silex::Donnenwa::Schema::ResultBase;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/
    EncodedColumn
    InflateColumn::DateTime
    TimeStamp
/);

sub TO_JSON {
      return { $_[0]->get_inflated_columns };
}

__PACKAGE__->meta->make_immutable;

1;
