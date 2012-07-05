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

sub signup :Path('/signup') :Args(0) {
    my ( $self, $c ) = @_;

    $c->detach('signup_POST') if $c->req->method eq 'POST';
}

sub signup_POST :Private {
    my ( $self, $c ) = @_;

    my $user_name = $c->req->param('user_name') || '';
    my $email     = $c->req->param('email') || '';
    my $password  = $c->req->param('password') || '';

    return unless ($user_name || $email || $password);

    my $created = $c->model('DonDB::User')->create({
        user_name => $user_name,
        email     => $email,
        password  => $password,
    });

    $c->res->redirect($c->req->uri) unless $created;

    if ($c->authenticate({ user_name => $user_name, password => $password } )) {
        $c->res->redirect($c->uri_for($c->controller('List')->action_for('index')));
    } else {
        $c->stash(error_msg => "Bad username or password."); # maybe flash?
        $c->res->redirect($c->req->uri);
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
