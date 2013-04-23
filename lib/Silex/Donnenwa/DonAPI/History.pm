package Silex::Donnenwa::DonAPI::History;
use Moose;
use namespace::autoclean;
use POSIX;
use Data::Dumper;
with qw/Silex::Donnenwa::Trait::WithDBIC/;

sub search {
	my ( $self, $cond, $attr ) = @_;

	return $self->resultset('History')->search($cond, $attr);
}

sub find {
	my ( $self, $args ) = @_;

	return $self->resultset('History')->find($args);
}

sub create {
	my ( $self, $args, $user_id ) = @_;

	my $time = strftime "%Y-%m-%d %H:%M:%S", localtime; #적용 안해주면 GMT 기준으로 보임
	my $usage_date = $args->{usage_date}
	   ? DateTime::Format::ISO8601->parse_datetime($args->{usage_date})
	   : DateTime->now( time_zone => 'Asia/Seoul' )->set(hour => 0, minute => 0, second => 0)->subtract( months => 1 );

    my $mini_class =  {};

    $mini_class = {
        '1'  => '식비',
        '2'  => '월급',
        '3'  => '월세',
        '4'  => '통신비',
        '5'  => '지식,문화',
        '6'  => '생활용품',
        '7'  => '세금',
        '8'  => '의료,건강',
        '9'  => '여가,유흥',
        '10' => '경조사비',
        '11' => '교통비',
        '12' => '기타',
    };

	my $pattern = '%Y-%m-%d %H:%M:%S';
	my %row  = (
	    user       => $user_id,
	    title      => $args->{title},
	    amount     => $args->{amount},
	    class      => $args->{class},
	    mini_class => $args->{mini_class},
        memo      => $mini_class->{$args->{mini_class}},
	    usage_date => $usage_date->strftime($pattern),
	    created_on => "$time",
	    updated_on => "$time",
	);

    $self->resultset('History')->create(\%row);
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
	    class      => $args->{class},
	    mini_class => $args->{mini_class},
	    usage_date => $usage_date->strftime($pattern),
	    updated_on => "$time",
	);

	$self->resultset('History')->find({id => $args->{charge_id} })->update(\%row);
}

1;
