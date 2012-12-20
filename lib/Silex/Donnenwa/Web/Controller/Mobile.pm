package Silex::Donnenwa::Web::Controller::Mobile;

use utf8;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

has api => (
  is  => 'rw',
  isa => 'Silex::Donnenwa::DonAPI::Charge',
);

sub auto :Private {
    my ( $self, $c ) = @_;
    $self->api($c->model('API')->find('Charge'));
    return 1;
}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $rs = $self->api->search(
        { # cond
            status => $c->req->params->{status} || $c->stash->{status} || { '!=', '4' },
        },
        { # attr
            order_by => { -desc => 'me.id' },
            page     => $c->req->params->{page} || 1,
        },
    );

    my @results;
    while ( my $item = $rs->next ) {
        push(
            @results,
            {
                id         => $item->id,
                title      => $item->title,
                amount     => $item->amount,
                comment    => $item->comment,
                username   => $item->user->user_name,
                email      => $item->user->email,
                status     => $item->status,
                created_on => $item->created_on->datetime,
                usage_date => $item->usage_date->datetime,
            },
        );
    }

    $c->stash( results => \@results );
    $c->forward('View::JSON');
}

sub view :Local :Args(1) {
    my ( $self, $c, $args ) = @_;

    my $rs = $self->api->find(
        { # cond
            id => $args,
        },
    );
    my @results;
    push(
        @results,
        {
            id         => $rs->id,
            title      => $rs->title,
            amount     => $rs->amount,
            comment    => $rs->comment,
            username   => $rs->user->user_name,
            email      => $rs->status,
            created_on => $rs->created_on->datetime,
            usage_date => $rs->usage_date->datetime,
        }
    );
    $c->stash( results => \@results );

    $c->forward('View::JSON');
}

__PACKAGE__->meta->make_immutable;
1;
