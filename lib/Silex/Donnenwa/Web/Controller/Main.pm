package Silex::Donnenwa::Web::Controller::Main;
use Moose;
use namespace::autoclean;
use Data::Pageset;
use POSIX;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

has api => (
    is => 'rw',
    isa => 'Silex::Donnenwa::DonAPI::History',
);

=head1 NAME

Silex::Donnenwa::Web::Controller::Main - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub auto :Private {
    my ( $self, $c ) = @_;

    $self->api($c->model('API')->find('History'));
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

sub insert :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( nav_active => "insert" );

    if ($c->req->method eq 'POST') {
        my @messages;

        push @messages, 'amount is invaild'      if ($c->req->params->{amount} !~ /^\d+$/);
        push @messages, 'title is required'      unless ($c->req->params->{title});
        push @messages, 'usage_date is required' unless ($c->req->params->{usage_date});

        if (@messages) {
            $c->flash(
                messages   => @messages,
                comment    => $c->req->params->{content},
                title      => $c->req->params->{title},
                amount     => $c->req->params->{amount},
                usage_date => $c->req->params->{usage_date},
            );

            return $c->res->redirect($c->uri_for('/main/insert'));
        }

        $self->api->create($c->req->params, $c->user->id);

        $c->res->redirect($c->uri_for('/main/entries'));
    }
}

sub entries :Local :Args(0) {
    my ( $self, $c ) = @_;

    my %attr  = ( 'order_by' => { -desc => 'me.id' } );

    my $rs;
    my %cond    = ();
    my $page    = $c->req->params->{page};
    my $status  = $c->req->params->{status} || $c->stash->{"status"} || '0'; #수정 필요

    $attr{page} = $page || 1;


    my $total_charge = $self->api->search(\%cond, \%attr);

    my $page_info =
        Data::Pageset->new(
            {
                ( map { $_ => $total_charge->pager->$_ } qw/entries_per_page total_entries current_page/ ),
                mode => "slide",
                pages_per_set => 10,
            }
    );

    $c->stash(
        lists          => [ $total_charge->all ],
        status         => $status,
        pageset        => $page_info,
        nav_active     => "entries",
    );
}



=head1 AUTHOR

한조

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
