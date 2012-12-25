+{
    name => 'Silex::Donnenwa::Web',
    disable_component_resolution_regex_fallback => 1,
    default_view => 'Bootstrap',
    "Model::API" => {
        class => "Silex::Donnenwa::DonAPI",
        args  => {
            connect_info => {
                dsn      => $ENV{DB_DON_DSN}      || "dbi:mysql:dondb:127.0.0.1",
                user     => $ENV{DB_DON_USER}     || "don",
                password => $ENV{DB_DON_PASSWORD} || "don",
                RaiseError        => 1,
                AutoCommit        => 1,
                mysql_enable_utf8 => 1,
                on_connect_do     => ["SET NAMES utf8"],
                quote_char        => q{`},
            },
        },
    },
    'View::Bootstrap' => {
        PRE_CHOMP          => 1,
        POST_CHOMP         => 1,
        ENCODING           => 'utf8',
        TEMPLATE_EXTENSION => '.tt',
        INCLUDE_PATH => [
            '__path_to(root/templates/bootstrap/src)__',
            '__path_to(root/templates/bootstrap/lib)__',
        ],
        PRE_PROCESS => 'config/main',
        WRAPPER     => 'site/wrapper',
        COMPILE_DIR => '__path_to(root/tt_cache)__',
        COMPILE_EXT => '.ttc',
        TIMER       => 0,
        ERROR       => '500.tt',
        render_die  => 1,
    },
    authentication => {
        default_realm => 'default',
        realms => {
            default => {
                class       =>  'SimpleDB',
                password_type   => 'hashed',
                password_hash_type  => 'SHA-1',
                user_model  =>  'DBIC::User',
            },
        }
    },
    'View::JSON' => {
    },
    session => {
        flash_to_stash => 1,
        storage        => "__path_to(etc/storage/session)__",
        expires        => 86400,
        unlink_on_exit => 0,
    },
}
