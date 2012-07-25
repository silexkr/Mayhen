#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Silex-Donnenwa-web';
all_from 'lib/Silex/Donnenwa/Web.pm';

requires 'Authen::SASL';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Authentication::Realm::SimpleDB';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::StackTrace';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Unicode::Encoding';
requires 'Catalyst::Runtime' => '5.90012';
requires 'Catalyst::View::Download';
requires 'Catalyst::View::Download::CSV';
requires 'Catalyst::View::TT';
requires 'Config::General';
requires 'DBD::mysql';
requires 'DBIx::Class::EncodedColumn';
requires 'DBIx::Class::TimeStamp';
requires 'Data::Pageset';
requires 'Data::Show';
requires 'DateTime::Format::ISO8601';
requires 'DateTime::Format::MySQL';
requires 'Devel::Cover';
requires 'Email::MIME';
requires 'Email::Sender::Simple';
requires 'Email::Sender::Transport::SMTP';
requires 'MIME::Base64';
requires 'Moose';
requires 'Net::SMTP::SSL';
requires 'Perl::Metrics::Lite';
requires 'Starman';
requires 'TAP::Formatter::JUnit';
requires 'Template::Plugin::Comma';
requires 'Text::CSV';
requires 'namespace::autoclean';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
