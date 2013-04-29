use utf8;
package Silex::Donnenwa::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Silex::Donnenwa::Schema::Result::User

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Silex::Donnenwa::Schema::ResultBase>

=cut

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'Silex::Donnenwa::Schema::ResultBase';

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 email

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 password

  data_type: 'varchar'
  default_value: (empty string)
  encode_args: {algorithm => "SHA-1",format => "hex"}
  encode_check_method: 'check_password'
  encode_class: 'Digest'
  encode_column: 1
  is_nullable: 0
  size: 255

=head2 created_on

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  inflate_datetime: 1
  is_nullable: 0
  set_on_create: 1

=head2 updated_on

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  inflate_datetime: 1
  is_nullable: 0
  set_on_create: 1
  set_on_update: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "email",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "password",
  {
    data_type           => "varchar",
    default_value       => "",
    encode_args         => { algorithm => "SHA-1", format => "hex" },
    encode_check_method => "check_password",
    encode_class        => "Digest",
    encode_column       => 1,
    is_nullable         => 0,
    size                => 255,
  },
  "created_on",
  {
    data_type                 => "datetime",
    datetime_undef_if_invalid => 1,
    default_value             => "0000-00-00 00:00:00",
    inflate_datetime          => 1,
    is_nullable               => 0,
    set_on_create             => 1,
  },
  "updated_on",
  {
    data_type                 => "datetime",
    datetime_undef_if_invalid => 1,
    default_value             => "0000-00-00 00:00:00",
    inflate_datetime          => 1,
    is_nullable               => 0,
    set_on_create             => 1,
    set_on_update             => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<email>

=over 4

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("email", ["email"]);

=head2 C<user_name>

=over 4

=item * L</user_name>

=back

=cut

__PACKAGE__->add_unique_constraint("user_name", ["user_name"]);

=head1 RELATIONS

=head2 histories

Type: has_many

Related object: L<Silex::Donnenwa::Schema::Result::History>

=cut

__PACKAGE__->has_many(
  "histories",
  "Silex::Donnenwa::Schema::Result::History",
  { "foreign.user" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-04-29 16:49:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+g6XwgJjuII+Jb5ZQnojHw

__PACKAGE__->has_many(
    charges => 'Silex::Donnenwa::Schema::Result::Charge',
    {
      'foreign.user' => 'self.id'
    },
    { cascading_delete => 1},

);


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
