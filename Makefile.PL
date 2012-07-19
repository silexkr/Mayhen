#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Silex-Web-Donnenwa';
all_from 'lib/Silex/Web/Donnenwa.pm';

requires "Starman";
requires "Devel::Cover";
requires "Perl::Metrics::Lite";
requires "TAP::Formatter::JUnit";
requires 'Catalyst::Plugin::Unicode::Encoding';
requires "Catalyst::View::TT";
requires "Catalyst::Model::DBIC::Schema";
requires "DBD::mysql";
requires "DateTime::Format::MySQL";
requires "Data::Pageset";
requires "Template::Plugin::Comma";

requires "Catalyst::Plugin::Authentication";
requires "Catalyst::Plugin::Session";
requires "Catalyst::Plugin::Session::Store::File";
requires "Catalyst::Plugin::Session::State::Cookie";
requires "Catalyst::Plugin::StackTrace";
requires "Catalyst::Authentication::Realm::SimpleDB";
requires "DBIx::Class::TimeStamp";

requires 'Catalyst::Runtime' => '5.90012';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
