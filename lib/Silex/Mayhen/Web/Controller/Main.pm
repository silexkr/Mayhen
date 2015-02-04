package Silex::Mayhen::Web::Controller::Main;
use Moose;
use namespace::autoclean;
use Data::Pageset;
use POSIX;
use Const::Fast;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

has api => (
    is => 'rw',
    isa => 'Silex::Mayhen::DonAPI::History',
);

const $OWNER_NAME = 'SET_OWNER_NAME' | '';

=head1 NAME

Silex::Mayhen::Web::Controller::Main - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub auto :Private {
    my ( $self, $c ) = @_;

    $self->api($c->model('API')->find('History'));
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

sub insert :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( nav_active => "insert" );

    if ($c->req->method eq 'POST') {
        my @messages;

        push @messages, 'amount is invaild'      if ($c->req->params->{amount} !~ /^\d+$/);
        push @messages, 'title is required'      unless ($c->req->params->{title});
        push @messages, 'usage_date is required' unless ($c->req->params->{usage_date});

        if (@messages) {
            $c->flash(
                messages   => @messages,
                comment    => $c->req->params->{content},
                title      => $c->req->params->{title},
                amount     => $c->req->params->{amount},
                usage_date => $c->req->params->{usage_date},
            );

            return $c->res->redirect($c->uri_for('/main/insert'));
        }

        if (my $insert = $self->api->create($c->req->params, $c->user->id) ) {
            my $uri = "http://mayhen.silex.kr/list/view/".$insert->id;
            my $user = $c->user->user_name;
            my $amount = reverse $c->req->params->{amount};
            $amount =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
            $amount = reverse $amount;
            my $comment = $c->req->params->{comment} || "추가 내역이 없습니다.";

            my $time = strftime "%Y-%m-%d", localtime; #적용 안해주면 GMT 기준으로 보임

            if ($c->req->params->{class} eq '1') {
                $c->send_mail($OWNER_NAME,
"[Mayhen] @{[ $c->req->params->{title} ]} 사용 내역",
"안녕하십니까? Silex 경리봇 Mayhen 입니다.

$time 일 $user 님이
새로운 거래내역 [ @{[ $c->req->params->{title} ]} ]를 등록하셨습니다.
사용 금액은 $amount 원 입니다.

$comment

자세한 사항은 $uri 에서 확인 부탁드립니다.

사랑과 행복을 전하는 Silex 경리봇 Mayhen 이었습니다.
감사합니다.");
            }
            else {
                $c->send_mail($OWNER_NAME,
"[Mayhen] @{[ $c->req->params->{title} ]} 청구 요청",
"안녕하십니까? Silex 경리봇 Mayhen 입니다.

$time 일 $user 님의
새로운 청구건 [ @{[ $c->req->params->{title} ]} ]를 등록하셨습니다.
사용 금액은 $amount 원 입니다.

$comment

자세한 사항은$uri 에서 확인 부탁드립니다.

$user 님은 빠른 시일내에 답변이 오기를 바라십니다.
사장님 화이팅!

사랑과 행복을 전하는 Silex 경리봇 Mayhen 이었습니다.
감사합니다.");
            }
        }

        $c->res->redirect($c->uri_for('/main/entries'));
    }
}

sub entries :Local :Args(0) {
    my ( $self, $c ) = @_;

    my %attr  = ( 'order_by' => { -desc => 'me.id' } );

    my $rs;
    my $cond    = {};
    my $page    = $c->req->params->{page};
    my $status  = '4';


    $cond->{status} = '4';
    if ($c->req->params->{start_date} && $c->req->params->{end_date}) {
        my $from = $c->req->params->{start_date}
        ? DateTime::Format::ISO8601->parse_datetime($c->req->params->{start_date})
        : DateTime->now( time_zone => 'Asia/Seoul' )->set(hour => 0, minute => 0, second => 0)->subtract( months => 1 );


        my $to   = $c->req->params->{end_date}
        ? DateTime::Format::ISO8601->parse_datetime($c->req->params->{end_date})
        : DateTime->now( time_zone => 'Asia/Seoul' )->set(hour => 23, minute => 59, second => 59);


        my $pattern = '%Y-%m-%d %H:%M:%S';
        $cond->{updated_on} = {
            -between => [
                $from->strftime($pattern),
                $to->strftime($pattern)
            ]
        };
    }
    else {
        $attr{page} = $page || 1;
    }

    my $total_charge = $self->api->search($cond, \%attr);

    my $page_info;
    unless ($c->req->params->{start_date} && $c->req->params->{end_date}) {
        $page_info =
            Data::Pageset->new(
                {
                    ( map { $_ => $total_charge->pager->$_ } qw/entries_per_page total_entries current_page/ ),
                    mode => "slide",
                    pages_per_set => 10,
                }
        );
    }

    $c->stash(
        lists          => [ $total_charge->all ],
        status         => $status,
        pageset        => $page_info,
        nav_active     => "entries",
    );
}



=head1 AUTHOR

한조

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
