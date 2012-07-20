package Silex::Web::Donnenwa::Controller::List;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use Data::Pageset;
use POSIX;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Silex::Web::Donnenwa::Controller::List - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my %attr  = ( 'order_by' => { -desc => 'me.id' } );

    my $rs;
    my %cond    = ();
    my $page    = $c->req->params->{page};
    my $status  = $c->req->param("status") || $c->stash->{"status"} || '0'; #수정 필요

    $attr{page} = $page || 1;

    if ($status) {
        %cond = ( status => $status);
    }
    else {
        %cond = ( status => {'!=', '4'});
    }

    my $total_charge = $c->model('DonDB')->resultset('Charge')->search(\%cond, \%attr);

    my $total_count    = $c->model('DonDB')->resultset('Charge')->search({status => {'!=', '4'}});
    my $charge_count   = $c->model('DonDB')->resultset('Charge')->search({ status => 1 });
    my $approval_count = $c->model('DonDB')->resultset('Charge')->search({ status => 2 });
    my $refuse_count   = $c->model('DonDB')->resultset('Charge')->search({ status => 3 });

    my $page_info =
        Data::Pageset->new(
            {
                ( map { $_ => $total_charge->pager->$_ } qw/entries_per_page total_entries current_page/ ),
                mode => "slide",
                pages_per_set => 10,
            }
    );

    $c->stash(
        lists          => [ $total_charge->all ],
        total_count    => $total_count,
        charge_count   => $charge_count,
        approval_count => $approval_count,
        refuse_count   => $refuse_count,
        status         => $status,
        pageset        => $page_info,
    );
}

sub write :Local :Args(0) {
    my ( $self, $c ) = @_;

    if ($c->req->method eq 'POST') {
        my @messages;

        push @messages, 'amount is invaild' if ($c->req->params->{amount} !~ /^\d+$/);
        push @messages, 'title is required' unless ($c->req->params->{title});
        push @messages, 'usage_date is required' unless ($c->req->params->{usage_date});

        if (@messages) {
            $c->flash(
                messages => @messages,
                comment  => $c->req->params->{content},
                title    => $c->req->params->{title},
                amount   => $c->req->params->{amount},
                usage_date => $c->req->params->{usage_date},
            );

            return $c->res->redirect($c->uri_for('/list/write'));
        }

        my $time = strftime "%Y-%m-%d %H:%M:%S", localtime; #적용 안해주면 GMT 기준으로 보임
        my $usage_date = $c->req->params->{usage_date}
           ? DateTime::Format::ISO8601->parse_datetime($c->req->params->{usage_date})
           : DateTime->now( time_zone => 'Asia/Seoul' )->set(hour => 0, minute => 0, second => 0)->subtract( months => 1 );

        my $pattern = '%Y-%m-%d %H:%M:%S';
        my %row  = (
            user       => $c->user->id,
            title      => $c->req->params->{title},
            comment    => $c->req->params->{content},
            amount     => $c->req->params->{amount},
            usage_date => $usage_date->strftime($pattern),
            created_on => "$time",
            updated_on => "$time",
        );

        if($c->model('DonDB')->resultset('Charge')->update_or_create(\%row)) {
            # $c->send_mail("supermania\@gmail.com",
            #                 "[돈내놔] @{[ $c->req->params->{title} ]} 청구 요청",
            #                 "다음 청구건 [ @{[ $c->req->params->{title} ]} ] 이 등록되었습니다. 신속한 처리를 부탁드립니다.");
        }

        $c->res->redirect($c->uri_for('/list'));
    }
}

sub view :Path('/view') :CaptureArgs(1) {
    my ( $self, $c, $charge_id) = @_;

    my $charge = $c->model('DonDB')->resultset('Charge')->find($charge_id);

    $c->stash(
        charge     => $charge
    );
}

sub delete :Local :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my @target_ids = split ',', $id;

    my $charge = $c->model('DonDB')->resultset('Charge')->search({ id => { -in => \@target_ids } })->delete_all;

    if ($charge) {
        $c->flash->{messages} = 'Success Deleted.';

    } else {
        $c->flash->{messages} = 'No Deleted Item.';
    }

    $c->res->redirect($c->uri_for('/list'));
}

sub approval :Local :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my @target_ids = split ',', $id;

    my $approval = $c->model('DonDB')->resultset('Charge')->search({ id => { -in
            => \@target_ids } })->update_all({ status => '2' });

    if ($approval) {
        $c->flash->{messages} = 'Success Approval.';
    }
    else {
        $c->flash->{messages} = 'No Approval Item.';
    }

    $c->stash->{status} = '2';
    $c->res->redirect($c->uri_for('/list'));
}

sub refuse :Local :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my @target_ids = split ',', $id;

    my $refuse = $c->model('DonDB')->resultset('Charge')->search({ id => { -in
            => \@target_ids } })->update_all({ status => '3' });

    if ($refuse) {
        $c->flash->{messages} = 'Success Refuse.';
    }
    else {
        $c->flash->{messages} = 'No Refuse Item.';
    }

    $c->stash->{status} = '3';
    $c->res->redirect($c->uri_for('/list'));
}

sub edit :Local :CaptureArgs(1) {
    my ( $self, $c, $edit_id ) = @_;

    if ($c->req->method eq 'POST') {
        my @messages;

        push @messages, 'amount is invaild' if ($c->req->params->{amount} !~ /^\d+$/);
        push @messages, 'title is required' unless ($c->req->params->{title});

        if (@messages) {
            $c->flash(
                    messages => @messages,
                    comment  => $c->req->params->{comment},
                    title    => $c->req->params->{title},
                    amount   => $c->req->params->{amount},
            );

            return $c->res->redirect($c->uri_for("/list/view/$c->req->params->{charge_id}"));
        }

        my $time = strftime "%Y-%m-%d %H:%M:%S", localtime;
        my %row = (
            id         => $c->req->params->{charge_id},
            amount     => $c->req->params->{amount},
            user       => $c->req->params->{charge_user},
            title      => $c->req->params->{title},
            comment    => $c->req->params->{comment},
            updated_on => "$time",
        );
        $c->model('DonDB')->resultset('Charge')->update_or_create(\%row);

        $c->res->redirect($c->uri_for("/list/view/$row{id}"));
    }
    else {
        my $editer = $c->model('DonDB')->resultset('Charge')->find($edit_id);

        $c->stash(
            editer => $editer,
        );
    }
}

=head1 AUTHOR

meadow,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
