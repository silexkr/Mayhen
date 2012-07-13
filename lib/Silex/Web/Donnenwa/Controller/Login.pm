package Silex::Web::Donnenwa::Controller::Login;
use Moose;
use namespace::autoclean;
use POSIX qw(strftime);

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

    if ($c->req->method eq 'POST') {
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
}

sub signup :Path('/signup') :Args(0) {
    my ( $self, $c ) = @_;

    $c->detach('signup_POST') if $c->req->method eq 'POST';
}

sub signup_POST :Private {
    my ( $self, $c ) = @_;

    my $user_name = $c->req->param('user_name') || '';
    my $email     = $c->req->param('email')     || '';
    my $password  = $c->req->param('password')  || '';

    my @messages;
    push @messages, 'Input the user name'     unless $user_name;
    push @messages, 'Input the user email'    unless $email;
    push @messages, 'Input the user password' unless $password;

    if (@messages) {
        $c->flash(
            messages => @messages,
        );

        return $c->res->redirect($c->uri_for('/signup'));
    }

    my $cond = {};
    $cond->{'me.user_name'} = "$user_name";
    my $name_search = $c->model('DonDB')->resultset('User')->search($cond);
    if ($name_search->count) {
        $c->flash(
            messages => 'Using ID again input the New ID',
        );

        return $c->res->redirect($c->uri_for('/signup'));
    }

    $cond = {} if $cond;
    $cond->{'me.email'} = "$email";
    my $email_search = $c->model('DonDB')->resultset('User')->search($cond);
    if ($email_search->count) {
        $c->flash(
            messages      => 'Using email again input the New email',
        );

        return $c->res->redirect($c->uri_for('/signup'));
    }

    my $time    = strftime "%Y-%m-%d %H:%M:%S", localtime;
    my $created = $c->model('DonDB::User')->create({
        user_name  => $user_name,
        email      => $email,
        password   => $password,
        created_on => "$time",
        updated_on => "$time",
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
