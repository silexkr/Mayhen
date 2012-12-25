package Silex::Donnenwa::Web::Controller::Root;
use Moose;
use namespace::autoclean;
use MIME::Base64;

BEGIN { extends 'Catalyst::Controller' }

has api => (
    is  => 'rw',
    isa => 'Silex::Donnenwa::DonAPI::User',
);

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Silex::Donnenwa::Web::Controller::Root - Root Controller for Silex::Donnenwa::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub auto :Private {
    my ($self, $c) = @_;
    $self->api($c->model('API')->find('User'));

    my $mobile_user = $c->req->header('Authorization');

    if ($mobile_user) {
## $auth is 'cnVtaWRpZXI6MTIzNA==
## MIME::Base64::encode
        my $user_info = decode_base64((split / /, $mobile_user)[1]);
        my ( $username, $password ) = $self->api->mobile_user($user_info);

        if ($username && $password) {
            if ($c->authenticate({ user_name => $username, password => $password })) {
                return 1;
            }
            else {
                $c->stash->{error} = 'Unauthorized';
                $c->res->code(401);
                $c->forward('View::JSON');
                return 0;
            }
        }
        else {
        }
    }

    if ($c->controller eq $c->controller('Login')) {
        return 1;
    }

    if (!$c->user_exists) {
        $c->res->redirect($c->uri_for('/login'));
        return 0;
    }

    return 1;
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect('/list');
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

meadow,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
