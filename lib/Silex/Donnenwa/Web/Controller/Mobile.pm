package Silex::Donnenwa::Web::Controller::Mobile;

use utf8;
use Digest::MD5 qw(md5_hex);
use DateTime;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

has api => (
  is  => 'rw',
  isa => 'Silex::Donnenwa::DonAPI::Charge',
);

has user_api => (
  is  => 'rw',
  isa => 'Silex::Donnenwa::DonAPI::User',
);

sub auto :Private {
    my ( $self, $c ) = @_;
    $self->api($c->model('API')->find('Charge'));
    $self->user_api($c->model('API')->find('User'));
    return 1;
}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $rs = $self->api->search(
        { # cond
            status => $c->req->params->{status} || $c->stash->{status} || { '!=', '4' },
        },
        { # attr
            order_by => { -desc => 'me.id' },
            page     => $c->req->params->{page} || 1,
        },
    );

    my @results;
    while ( my $item = $rs->next ) {
        push(
            @results,
            {
                id         => $item->id,
                title      => $item->title,
                amount     => sprintf("%d원", $item->amount),
                comment    => $item->comment,
                username   => $item->user->user_name,
                email      => "http://www.gravatar.com/avatar/".md5_hex(lc $item->user->email),
                created_on => sprintf("%d년 %d월 %d일",
                                $item->created_on->year,
                                $item->created_on->month,
                                $item->created_on->day
                            ),
            },
        );
    }

    $c->stash( results => \@results );
    $c->forward('View::JSON');
}

sub view :Local :Args(1) {
    my ( $self, $c, $args ) = @_;

    my $rs = $self->api->find(
        { # cond
            id => $args,
        },
    );
    my @results;
    push(
        @results,
        {
            id         => $rs->id,
            title      => $rs->title,
            amount     => sprintf("%d원", $rs->amount),
            comment    => $rs->comment,
            status     => $rs->status eq '1' ? '대기' :
                          $rs->status eq '2' ? '승인' :
                          '거부',
            username   => $rs->user->user_name,
            created_on => sprintf("%d년 %d월 %d일",
                              $rs->created_on->year,
                              $rs->created_on->month,
                              $rs->created_on->day
                          ),
            usage_date => sprintf("%d년 %d월 %d일",
                            $rs->usage_date->year,
                            $rs->usage_date->month,
                            $rs->usage_date->day
                        ),
        }
    );
    $c->stash( results => \@results );

    $c->forward('View::JSON');
}

sub write :Local :Args(0) {
    my ( $self, $c ) = @_;

    my $email = $c->req->params->{email};
    my $id = $self->user_api->find(
        {email => $email},
        {columns => [qw/id/]},
    );

    my $items = {};
    $items->{title}      = $c->req->params->{title};
    $items->{amount}     = $c->req->params->{amount};
    $items->{content}    = $c->req->params->{content};
    $items->{usage_date} = $c->req->params->{usage_date};

    if(my $charge = $self->api->create($items, $id)) {
# 저장이 되었을대 이메일 발송 해야하며 성공 메세지 전달 해야함
    }

    $c->forward('View::JSON');
}

__PACKAGE__->meta->make_immutable;
1;
