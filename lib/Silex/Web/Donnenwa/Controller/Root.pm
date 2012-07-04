package Silex::Web::Donnenwa::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Silex::Web::Donnenwa::Controller::Root - Root Controller for Silex::Web::Donnenwa

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub auto :Private {
    my ($self, $c) = @_;

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
