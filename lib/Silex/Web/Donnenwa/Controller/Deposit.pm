package Silex::Web::Donnenwa::Controller::Deposit;
use Data::Dumper;
use Moose;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Silex::Web::Donnenwa::Controller::Deposit - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $cond       = {};
    my $attr       = {};
    my $page       = $c->req->params->{page};
    my $charger_id = $c->req->params->{charger} || '';
    my $status     = $c->req->params->{status};

    $attr->{page} = $page || 1;
    $cond->{user} = $charger_id if $charger_id;

    if ($status) {
        $cond->{status} = $status;
    }
    else {
        $cond->{status} = '2';
    }

    my $total_charge = $c->model('DonDB')->resultset('Charge')->search($cond, $attr);

    my $page_info =
      Data::Pageset->new(
        {
            ( map { $_ => $total_charge->pager->$_} qw/entries_per_page total_entries current_page/ ),
            mode => "slide",
            pages_per_set => 10,    
        }
      );

    my $user_names = $c->model('DonDB')->resultset('User')->search(
        {},
        {
        columns => [ qw/ user_name id / ],
        }
    );
 
    $c->stash(
        lists        => [ $total_charge->all ],
        charge_users => [ $user_names->all ],
        status       => $status,
        pageset      => $page_info,
    );
}

sub approval :Local CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my @target_ids = split ',', $id;

    my $target_charges 
        = $c->model('DonDB')->resultset('Charge')->search({ id => { -in => \@target_ids } } );        
    my $approval = $target_charges->update_all({ status => '4' });

    if ($approval) {
        $c->flash->{messages} = 'Success Approval Deposit.';

        foreach my $charge ($target_charges->all) {            
            $c->send_mail($charge->user->email, 
                            "@{[ $charge->title ]} 입금처리",
                            "요청하신 청구건 [  @{[ $charge->title ]} ] 이 입금처리 되었습니다. 다음에 또 이용해주세요.");
        }           
    }
    else {
        $c->flash->{messages} = 'No Approval Deposit Item.';
    }

    $c->flash->{status} = '4';
    $c->res->redirect($c->uri_for("/deposit"));
}

=head1 AUTHOR

한조

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
