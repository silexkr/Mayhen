package Silex::Mayhen::Web::Model::DBIC::User;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model';

has schema => ( is => 'rw');

sub ACCEPT_CONTEXT {
    my ($self, $c) = @_;
    if (!$self->schema) {
        $self->schema($c->model('API')->schema);
    }

    return $self->schema->resultset('User');
}

=head1 DESCRIPTION

Catalyst Model.

=cut

__PACKAGE__->meta->make_immutable;

1;
