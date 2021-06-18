<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', $_ENV['ARTIFAKT_MYSQL_DATABASE_NAME'] );

/** MySQL database username */
define( 'DB_USER', $_ENV['ARTIFAKT_MYSQL_USER'] );

/** MySQL database password */
define( 'DB_PASSWORD', $_ENV['ARTIFAKT_MYSQL_PASSWORD'] );

/** MySQL hostname */
define( 'DB_HOST', $_ENV['ARTIFAKT_MYSQL_HOST'] );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         ($_ENV['AUTH_KEY'] != '') ? $_ENV['AUTH_KEY'] : '!0cYeO;9o]z}8R@Xp55eKiNU~ZtT[wsjW-(Ji=ddL$Yo*O`EXt82 r=EO1-[X}w(');
define('SECURE_AUTH_KEY',  ($_ENV['SECURE_AUTH_KEY'] != '') ? $_ENV['SECURE_AUTH_KEY'] : '2/RGYVWR!:;z2tsuE=e84<Z-Oj>Uvm*GLzNz<53 @|gwBK$Mna%Jb8G#9D/A/xcS');
define('LOGGED_IN_KEY',    ($_ENV['LOGGED_IN_KEY'] != '') ? $_ENV['LOGGED_IN_KEY'] : 'T3C>W`XoF<@_+[P1P-DIh(EF=Otn;hiF D%6@gaI<`4?B`U1jH7]}&@bes]5&],{');
define('NONCE_KEY',        ($_ENV['NONCE_KEY'] != '') ? $_ENV['NONCE_KEY'] : '*hl^lPLoe<m.)w0=Nk-J3z!InR?%LD|?$ou30I0-@,{AW>|V&R-knzDR0hX+os5X');
define('AUTH_SALT',        ($_ENV['AUTH_SALT'] != '') ? $_ENV['AUTH_SALT'] : ')*+-%6ksW-}~|nYeYf%X1uRWv4}O&m}r>P8Vp3V5A&8ly94qouQK2Nre/`_A>~Hd');
define('SECURE_AUTH_SALT', ($_ENV['SECURE_AUTH_SALT'] != '') ? $_ENV['SECURE_AUTH_SALT'] : ',ZoFK~-:L6x(LWvI01e6>S~8zhADT(qO--(aaJ)[ aZke(&i+81K&c89%M+WjFVL');
define('LOGGED_IN_SALT',   ($_ENV['LOGGED_IN_SALT'] != '') ? $_ENV['LOGGED_IN_SALT'] : '-2,><jcgjGm!FriM7A-$6y[R@aj.f,t1)B<$`+q`+hztch~?Ka-n%M;SS|#AbLE*');
define('NONCE_SALT',       ($_ENV['NONCE_SALT'] != '') ? $_ENV['NONCE_SALT'] : 'E-;VUw{6?v tah]~^,dBmN`G=>+L:`OV# I:&h;]YM(lBNEr):BR3h>TP|Z@5=IU');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = ($_ENV['TABLE_PREFIX'] != '') ? $_ENV['TABLE_PREFIX'] : 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', ($_ENV['WP_DEBUG'] != '') ? $_ENV['WP_DEBUG'] : false);
define( 'WP_DEBUG_LOG', '/var/log/artifakt/wp-errors.log' );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
