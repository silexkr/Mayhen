package Silex::Mayhen::Web;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader

    StackTrace

    Authentication

    Session
    Session::Store::File
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';
use utf8;
use Email::MIME;
use Email::Sender::Simple 'sendmail';
use Email::Sender::Transport::SMTPS;
use Encode qw/encode_utf8 decode_utf8 encode decode/;
use MIME::Base64;
use HTTP::Tiny;
use Text::CSV;
use Try::Tiny;

# Configure the application.
#
# Note that settings in silex_web_mayhen.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Silex::Mayhen::Web',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

# Start the application
__PACKAGE__->setup();

sub notify {
    my ($self, %params) = @_;

    return unless $params{type} && $params{type} =~ m/^sms|email$/;
    return unless $params{from};
    return unless $params{to};
    return unless $params{content};
    return unless $params{username};
    return unless $params{access_token};

    my $uri   = "http://localhost:5001/api/v1/$params{type}";
    my $http  = HTTP::Tiny->new(
        default_headers => {
            accept        => 'application/json',
            authorization => sprintf(
                'Basic %s',
                encode_base64(
                    $params{username} . q{:} . $params{access_token},
                    q{},
                ),
            ),
        },
    );

    my %notify_params = (
        to      => $params{to},
        from    => $params{from},
        subject => $params{subject},
        content => $params{content},
    );

    delete $params{subject} if $params{type} eq 'sms';

    my $res = $http->post_form($uri, \%notify_params );
    $self->log->debug(
            "notify:
            type($params{type}),
            from($params{from}),
            to($params{to}),
            subject($params{subject}),
            cotent($params{content}),
            ret($res->{status})"
    );

    return $res->{success};
}

=head1 NAME

Silex::Mayhen::Web - Catalyst based application

=head1 SYNOPSIS

    script/silex_web_mayhen_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Silex::Mayhen::Web::Controller::Root>, L<Catalyst>

=head1 AUTHOR

meadow,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
