package Silex::Donnenwa::DonAPI::Charge;
use Moose;
use namespace::autoclean;
use POSIX;
use Data::Dumper;
with qw/Silex::Donnenwa::Trait::WithDBIC/;

sub search {
	my ( $self, $cond, $attr ) = @_;

	return $self->resultset('Charge')->search($cond, $attr);
}

sub find {
	my ( $self, $args ) = @_;

	return $self->resultset('Charge')->find($args);
}

sub create {
	my ( $self, $args, $user_id ) = @_;

	my $time = strftime "%Y-%m-%d %H:%M:%S", localtime; #적용 안해주면 GMT 기준으로 보임
	my $usage_date = $args->{usage_date}
	   ? DateTime::Format::ISO8601->parse_datetime($args->{usage_date})
	   : DateTime->now( time_zone => 'Asia/Seoul' )->set(hour => 0, minute => 0, second => 0)->subtract( months => 1 );

	my $pattern = '%Y-%m-%d %H:%M:%S';
	my %row  = (
	    user       => $user_id,
	    title      => $args->{title},
	    comment    => $args->{content},
	    amount     => $args->{amount},
	    usage_date => $usage_date->strftime($pattern),
	    created_on => "$time",
	    updated_on => "$time",
	);

	$self->resultset('Charge')->create(\%row);
}

sub update {
	my ( $self, $args ) = @_;

	my $time       = strftime "%Y-%m-%d %H:%M:%S", localtime;
	my $usage_date = DateTime::Format::ISO8601->parse_datetime($args->{usage_date});
	my $pattern    = '%Y-%m-%d %H:%M:%S';

	my %row = (
	    amount     => $args->{amount},
	    user       => $args->{charge_user},
	    title      => $args->{title},
	    comment    => $args->{comment},
	    usage_date => $usage_date->strftime($pattern),
	    updated_on => "$time",
	);

	$self->resultset('Charge')->find({id => $args->{charge_id} })->update(\%row);
}

1;
