package Silex::Donnenwa::Web::Controller::Deposit;
use Data::Dumper;
use Moose;
use DateTime;
use DateTime::Format::ISO8601;
use DateTime::Format::Strptime;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Silex::Donnenwa::Web::Controller::Deposit - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

has us_api => (
    is => 'rw',
    isa => 'Silex::Donnenwa::DonAPI::User',
);

has his_api => (
    is => 'rw',
    isa => 'Silex::Donnenwa::DonAPI::History',
);

sub auto :Private {
    my ($self, $c) = @_;

    $self->us_api($c->model('API')->find('User'));
    $self->his_api($c->model('API')->find('History'));

    $c->stash( nav_active => "deposit" );
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $cond       = {};
    my $attr       = {};
    my $page       = $c->req->params->{page};
    my $charger_id = $c->req->params->{charger} || '0';
    my $status     = $c->req->params->{status}  || '0';


    if ($c->req->params->{start_date} && $c->req->params->{end_date}) {
        my $from = $c->req->params->{start_date}
        ? DateTime::Format::ISO8601->parse_datetime($c->req->params->{start_date})
        : DateTime->now( time_zone => 'Asia/Seoul' )->set(hour => 0, minute => 0, second => 0)->subtract( months => 1 );


        my $to   = $c->req->params->{end_date}
        ? DateTime::Format::ISO8601->parse_datetime($c->req->params->{end_date})
        : DateTime->now( time_zone => 'Asia/Seoul' )->set(hour => 23, minute => 59, second => 59);


        my $pattern = '%Y-%m-%d %H:%M:%S';
        $cond->{created_on} = {
            -between => [
                $from->strftime($pattern),
                $to->strftime($pattern)
            ]
        };
    }
    $attr->{page} = $page || 1;
    $cond->{user} = $charger_id if $charger_id;

    $cond->{status} = $status ? $status : '2';

    my $total_charge = $self->his_api->search($cond, $attr);

    my $page_info =
      Data::Pageset->new(
        {
            ( map { $_ => $total_charge->pager->$_} qw/entries_per_page total_entries current_page/ ),
            mode => "slide",
            pages_per_set => 10,
        }
      );

    my $user_names = $self->us_api->search(
        {},
        {
            columns => [ qw/ user_name id / ],
        }
    );

    $c->stash(
        lists          => [ $total_charge->all ],
        charge_users   => [ $user_names->all ],
        deposit_status => $charger_id,
        status         => $status,
        pageset        => $page_info,
    );
}

sub approval :Local :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my @target_ids = split ',', $id;

    return $c->res->redirect($c->uri_for("/deposit")) unless @target_ids;

    my $target_charges
        = $self->his_api->search({ id => { -in => \@target_ids } } );
    my $approval = $target_charges->update_all({ status => '4' });

    if ($approval) {
        $c->flash->{messages} = 'Success Approval Deposit.';

        foreach my $charge ($target_charges->all) {
            my $amount_commify = reverse @{[ $charge->amount ]};
            $amount_commify    =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
            $amount_commify    = reverse $amount_commify;

            my $charge_datas = {};
            $charge_datas->{amount}         = shift @{[ $charge->amount ]};
            $charge_datas->{user}           = shift @{[ $charge->user ]};
            $charge_datas->{title}          = shift @{[ $charge->title ]};
            $charge_datas->{usage_date}     = shift @{[ $charge->usage_date ]};
            $charge_datas->{created_on}     = shift @{[ $charge->created_on ]};
            $charge_datas->{class}          = shift @{[ $charge->class ]};
            $charge_datas->{mini_class}     = shift @{[ $charge->mini_class ]};
            $charge_datas->{memo}           = shift @{[ $charge->memo ]};
            $charge_datas->{history_status} = shift @{[ $charge->id ]};

            $self->his_api->upgrade($charge_datas);
            my $time = DateTime::Format::ISO8601->parse_datetime($charge_datas->{created_on})->ymd;

            #$c->send_mail($charge->user->email,
            $c->send_mail('rumidier@naver.com',
                "Mayhen 입금 거부 메일 [@{[ $charge->title ]}]",
                "안녕하십니까? Silex 경리봇 Mayhen 입니다.

                $time 일 청구하신 [ @{[ $charge->title ]} ] ($amount_commify)원이 입금 처리되었습니다.
                자세한 문의 사항은 관리자에게 문의해 주시기 바랍니다.

                사랑과 행복을 전하는 Silex 경리봇 Mayhen 이었습니다.
                감사합니다.
            ");
        }
    }
    else {
        $c->flash->{messages} = 'No Approval Deposit Item.';
    }

    $c->flash->{status} = '4';
    $c->res->redirect($c->uri_for("/deposit"));
}

sub cancel :Local :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my @target_ids = split ',', $id;

    return $c->res->redirect($c->uri_for("/deposit")) unless @target_ids;

    my $cancel = $self->his_api->search({ id => { -in => \@target_ids } })->update_all({ status => '1' });

    if ($cancel) {
        $c->flash->{messages} = 'Success Cancel.';
    }
    else {
        $c->flash->{messages} = 'No Cancel Item.';
    }

    $c->res->redirect($c->uri_for('/deposit'));
}

sub refuse :Local :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my @target_ids = split ',', $id;

    return $c->res->redirect($c->uri_for("/deposit")) unless @target_ids;

    my $target_refuse = $self->his_api->search({ id => { -in => \@target_ids } });
    my $refuse = $target_refuse->update_all({ status => '2' });

    if ($refuse) {
        $self->his_api->search({ history_status => { -in => \@target_ids } })->delete_all();
        $c->flash->{messages} = 'Success Refuse Deposit.';

        foreach my $charge ($target_refuse->all) {
            my $amount_commify = reverse @{[ $charge->amount ]};
            $amount_commify    =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
            $amount_commify    = reverse $amount_commify;
            my $time = DateTime::Format::ISO8601->parse_datetime(@{[ $charge->created_on ]})->ymd;

            #$c->send_mail($charge->user->email,
            $c->send_mail('rumidier@naver.com',
                "Mayhen 입금 거부 메일 [@{[ $charge->title ]}]",
                "안녕하십니까? Silex 경리봇 Mayhen 입니다.

                $time 일 청구하신 [  @{[ $charge->title ]} ] ( $amount_commify )원이 입금 취소되었습니다.
                자세한 문의 사항은 관리자에게 문의해 주시기 바랍니다.

                사랑과 행복을 전하는 Silex 경리봇 Mayhen 이었습니다.
                감사합니다.
            ");
        }
    }
    else {
        $c->flash->{messages} = 'No Approval Deposit Item.';
    }

    if ($refuse) {
        $c->flash->{messages} = 'Success refuse.';
    }
    else {
        $c->flash->{messages} = 'No refuse Item.';
    }

    $c->res->redirect($c->uri_for('/deposit'));
}

sub export :Local CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my @target_ids = split ',', $id;

    return $c->res->redirect($c->uri_for("/deposit")) unless @target_ids;

    my @charges;
    push @charges, ['제목', '청구자', '금액', '영수증날짜']; # set header

    foreach my $charge ($self->his_api->search({ id => { -in => \@target_ids } })->all) {
        push @charges, [ $charge->title, $charge->user->user_name, $charge->amount, $charge->usage_date ];
    }

    if (@charges) {
        $c->stash->{'csv'} = { 'data' => [ @charges ] };
        $c->flash->{messages} = 'Success Exported.';

    } else {
        $c->flash->{messages} = 'Export Failed.';
    }
    $c->forward('Silex::Donnenwa::Web::View::Download::CSV');
}

=head1 AUTHOR

한조

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
