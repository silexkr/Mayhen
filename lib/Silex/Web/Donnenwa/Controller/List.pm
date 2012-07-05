package Silex::Web::Donnenwa::Controller::List;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use Data::Pageset;
use POSIX qw(strftime);

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Silex::Web::Donnenwa::Controller::List - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my %attr  = ( 'order_by' => { -desc => 'me.id' } );

    my $page    = $c->req->params->{page};
    $attr{page} = $page || 1;

    my $rs = $c->model('DonDB')->resultset('Charge')->search({}, \%attr);
    my $users = $c->model('DonDB')->resultset('User')->search();

    my $page_info =
    Data::Pageset->new(
        {
            ( map { $_ => $rs->pager->$_ } qw/entries_per_page total_entries current_page/ ),
            mode => "slide",
            pages_per_set => 10,
        }
    );

    $c->stash(
        lists   => [ $rs->all ],
        users   => [ $users->all ],
        pageset => $page_info,
    );
}

sub write :Local :Args(0) {
    my ( $self, $c ) = @_;

    if ($c->req->method eq 'POST') {
        my $time = strftime "%Y-%m-%d% %H:%M:%S", localtime;
        my %row = (
            user    => $c->user->id,
            title      => $c->req->params->{title},
            content    => $c->req->params->{content},
            amount     => $c->req->params->{amount},
            created_on => "$time",
            updated_on => "$time",
        );
        $c->model('DonDB')->resultset('Charge')->update_or_create(\%row);
        $c->res->redirect($c->uri_for('/list'));

        if ( $c->request->parameters->{form_submit} eq 'yes' ) {
            if ( my $upload = $c->request->upload('upfile') ) {
                my $filename = $upload->filename;
                my $target = "image/upload/$filename";

                unless ( $upload->link_to($target) || $upload->copy_to($target) ) {
                    die ( "Failied to copy '$filename' to '$target' : $!");
                }
            }
        }
    }
}

sub view :Local :CaptureArgs(1) {
    my ( $self, $c, $user_id) = @_;

    my $rs = $c->model('DonDB')->resultset('Charge')->find($user_id);
    $c->stash->{users} = $rs;
}

=head1 AUTHOR

meadow,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
