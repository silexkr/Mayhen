my $MAYHEN_DB          = $ENV{MAYHEN_DB}          || 'mayhen';
my $MAYHEN_DB_USER     = $ENV{MAYHEN_DB_USER}     || 'mayhen';
my $MAYHEN_DB_PASSWORD = $ENV{MAYHEN_DB_PASSWORD} || 'mayhen';

{
    schema_class => "Silex::Mayhen::Schema",
    connect_info => {
        dsn               => "dbi:mysql:$MAYHEN_DB:127.0.0.1",
        user              => $MAYHEN_DB_USER,
        pass              => $MAYHEN_DB_PASSWORD,
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
        result_base_class => 'Silex::Mayhen::Schema::ResultBase',
        overwrite_modifications => 1,
        datetime_undef_if_invalid => 1,
        custom_column_info => sub {
            my ($table, $col_name, $col_info) = @_;

            if ($col_name eq 'password') {
                return { %{ $col_info },
                         encode_column => 1,
                         encode_class  => 'Digest',
                         encode_args   => { algorithm => 'SHA-1', format => 'hex' },
                         encode_check_method => 'check_password' };
            }
            if ($col_name eq 'created_on') {
                return { %{ $col_info }, set_on_create => 1, inflate_datetime => 1 };
            }

            if ($col_name eq 'updated_on') {
                return { %{ $col_info }, set_on_create => 1, set_on_update => 1, inflate_datetime => 1 };
            }
        },
    },
}
