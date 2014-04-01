package Silex::Mayhen::DonAPI;
use Moose;
use namespace::autoclean;
use Silex::Mayhen::Schema;

use Class::Load qw( load_class is_class_loaded );

with qw/Silex::Mayhen::Trait::WithAPI Silex::Mayhen::Trait::WithDBIC/;

sub _build_schema {
    my $self = shift;
    Silex::Mayhen::Schema->connect( $self->connect_info );
}

sub _build_apis {
    my $self = shift;
    my %apis;

    for my $module (qw/User History/) {
        my $class = __PACKAGE__ . "::$module";
        if (!is_class_loaded($class)) {
            load_class($class);
        }
        my $opt = $self->opts->{$module} || {};
        $apis{$module} = $class->new( schema => $self->schema, %{ $opt } );
    }

    return \%apis;
}

__PACKAGE__->meta->make_immutable;

1;
