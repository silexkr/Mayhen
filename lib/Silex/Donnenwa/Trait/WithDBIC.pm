package Silex::Donnenwa::Trait::WithDBIC;
use Moose::Role;
use namespace::autoclean;

use Data::Pageset;

has schema => (
    is => 'ro',
    lazy_build => 1,
    handles => {
        txn_guard => 'txn_scope_guard',
    }
);

has connect_info => (
    is => 'ro',
    isa => 'HashRef',
);

sub pageset {
    my ($self, $pager) = @_;

    Data::Pageset->new(
        {
            ( map { $_ => $pager->$_ } qw/entries_per_page total_entries current_page/ ),
            mode          => "slide",
            pages_per_set => 5,
        }
    );
}

sub resultset {
    my ($self, $moniker) = @_;

    $moniker or confess blessed($self) . "->resultset() did not receive a moniker, nor does it have a default moniker";
    $self->schema->resultset($moniker);
}

no Moose::Role;

1;
