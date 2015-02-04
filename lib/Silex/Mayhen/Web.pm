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
use Text::CSV;
use Try::Tiny;
use Const::Fast;

my $SMTPS_USERNAME = 'SET_USERNAME' | '';
my $SMTPS_PASSWORD = 'SET_PASSWORD' | '';

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

sub email_transporter {
    my ($self) = @_;

    return Email::Sender::Transport::SMTPS->new(
        host          => 'smtp.gmail.com',
        port          => 587,
        ssl           => 'starttls',
        sasl_username => $SMTPS_USERNAME,
        sasl_password => $SMTPS_PASSWORD,
    );
}

sub send_mail {
    my ($self, $send_to, $subject, $body) = @_;

    my $opt     = $self->email_transporter;
    my $message = Email::Simple->create(
        header => [
            From    => $SMTP_USERNAME,
            To      => $send_to,
            Subject => $subject,
        ],
        body => $body,
    );

    try {
        sendmail($message, { transport => $opt });
    } catch {
        warn "Error sending email: $_";
    };
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
