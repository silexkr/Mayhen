my $DONNENWA_DB          = $ENV{DONNENWA_DB}          || 'dondb';
my $DONNENWA_DB_USER     = $ENV{DONNENWA_DB_USER}     || 'don';
my $DONNENWA_DB_PASSWORD = $ENV{DONNENWA_DB_PASSWORD} || 'don';

{
    schema_class => "Silex::Schema",
    connect_info => {
        dsn               => "dbi:mysql:$DONNENWA_DB:127.0.0.1",
        user              => $DONNENWA_DB_USER,
        pass              => $DONNENWA_DB_PASSWORD,
        mysql_enable_utf8  => 1,
    },
    loader_options => {
        dump_directory     => 'lib',
        naming             => { ALL => 'v8' },
        skip_load_external => 1,
        relationships      => 1,
        use_moose          => 1,
        only_autoclean     => 1,
        col_collision_map  => 'column_%s',
        result_base_class => 'Silex::Schema::ResultBase',
        overwrite_modifications => 1,
        datetime_undef_if_invalid => 1,
        custom_column_info => sub {
            my ($table, $col_name, $col_info) = @_;

#            if ($col_name eq 'password') {
#                return { %{ $col_info },
#                         encode_column => 1,
#                         encode_class  => 'Digest',
#                         encode_args   => { algorithm => 'SHA-1', format => 'hex' },
#                         encode_check_method => 'check_password' };
#            }
            if ($col_name eq 'created_at') {
                return { %{ $col_info }, set_on_create => 1, inflate_datetime => 1 };
            }
        },
    },
}
