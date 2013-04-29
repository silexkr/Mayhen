use utf8;
package Silex::Donnenwa::Schema::Result::History;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Silex::Donnenwa::Schema::Result::History

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Silex::Donnenwa::Schema::ResultBase>

=cut

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'Silex::Donnenwa::Schema::ResultBase';

=head1 TABLE: C<history>

=cut

__PACKAGE__->table("history");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 amount

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

ê¸ì¡

=head2 user

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

 ìì±ì

=head2 title

  data_type: 'varchar'
  default_value: 'ë´ì©ìì'
  is_nullable: 1
  size: 255

ì²­êµ¬ë´ì­

=head2 usage_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

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

=head2 class

  data_type: 'enum'
  default_value: 1
  extra: {list => [1,2]}
  is_nullable: 0

=head2 mini_class

  data_type: 'enum'
  default_value: 12
  extra: {list => [1,2,3,4,5,6,7,8,9,10,11,12]}
  is_nullable: 0

=head2 memo

  data_type: 'text'
  is_nullable: 0

=head2 comment

  data_type: 'text'
  is_nullable: 0

=head2 status

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "amount",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "user",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "title",
  {
    data_type => "varchar",
    default_value => pack("H*","eb82b4ec9aa9ec9786ec9d8c"),
    is_nullable => 1,
    size => 255,
  },
  "usage_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
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
  "class",
  {
    data_type => "enum",
    default_value => 1,
    extra => { list => [1, 2] },
    is_nullable => 0,
  },
  "mini_class",
  {
    data_type => "enum",
    default_value => 12,
    extra => { list => [1 .. 12] },
    is_nullable => 0,
  },
  "memo",
  { data_type => "text", is_nullable => 0 },
  "comment",
  { data_type => "text", is_nullable => 0 },
  "status",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<Silex::Donnenwa::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Silex::Donnenwa::Schema::Result::User",
  { id => "user" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-04-29 16:49:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AP/mT9YFZ0Iu9VRdl4CvPw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
