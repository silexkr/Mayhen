use utf8;
package Silex::Schema::Result::Charge;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Silex::Schema::Result::Charge

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Silex::Schema::ResultBase>

=cut

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'Silex::Schema::ResultBase';

=head1 TABLE: C<charge>

=cut

__PACKAGE__->table("charge");

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
  is_nullable: 0

ì²­êµ¬ ìì±ì

=head2 comment

  data_type: 'varchar'
  default_value: 'ë´ì© ìì'
  is_nullable: 0
  size: 255

ì²­êµ¬ ë©ëª¨

=head2 title

  data_type: 'varchar'
  default_value: 'ì ëª© ìì'
  is_nullable: 0
  size: 255

ì²­êµ¬ ì ëª©

=head2 status

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

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
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "comment",
  {
    data_type => "varchar",
    default_value => pack("H*","eb82b4ec9aa920ec9786ec9d8c"),
    is_nullable => 0,
    size => 255,
  },
  "title",
  {
    data_type => "varchar",
    default_value => pack("H*","eca09cebaaa920ec9786ec9d8c"),
    is_nullable => 0,
    size => 255,
  },
  "status",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
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
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-18 18:36:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NHhwD2+TSWzRne/yazykng

__PACKAGE__->belongs_to(
    user => 'Silex::Schema::Result::User',
    {
      'foreign.id' => 'self.user'
    }
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
