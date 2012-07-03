package Silex::Web::Donnenwa::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Silex::Web::Donnenwa::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};

    if ($username && $password) {
        if ($c->authenticate({ user_name => $username, password => $password } )) {
            $c->response->redirect($c->uri_for($c->controller('List')->action_for('index')));
            return;
        }
        else {
            $c->stash(error_msg => "Bad username or password.");
        }
    }
    else {
        $c->stash(error_msg => "Empty username or password.") unless ($c->user_exists);
    }
}


=head1 AUTHOR

meadow,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
