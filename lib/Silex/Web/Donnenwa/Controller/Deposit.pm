package Silex::Web::Donnenwa::Controller::Deposit;
use Data::Dumper;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Silex::Web::Donnenwa::Controller::Deposit - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $cond   = {};
    my $page   = $c->req->params->{page};
    my $charger_id = $c->req->params->{charger} || '';
    my $attr = {};

    $attr->{page} = $page || 1;
    $cond->{user} = $charger_id if $charger_id;
    $cond->{status} = '2';

    my $total_charge = $c->model('DonDB')->resultset('Charge')->search($cond, $attr);

    my $page_info =
      Data::Pageset->new(
        {
        	( map { $_ => $total_charge->pager->$_} qw/entries_per_page total_entries current_page/ ),
        	mode => "slide",
        	pages_per_set => 10, 	
        }
      );

    my $user_names = $c->model('DonDB')->resultset('User')->search(
       {},
     {
        columns => [ qw/ user_name id / ],
     }
    );
 
    $c->stash(
        lists   => [ $total_charge->all ],
        charge_users => [ $user_names->all ],
        pageset => $page_info,
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
