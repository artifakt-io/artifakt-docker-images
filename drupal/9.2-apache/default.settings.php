<?php

// @codingStandardsIgnoreFile

/**
 * @file
 * Drupal site-specific configuration file.
 */

// Config sync directory.
$settings['config_sync_directory'] = '../config/sync';

// Hash salt.
$settings['hash_salt'] = file_get_contents('/data/salt.txt'); ;

// Disallow access to update.php by anonymous users.
$settings['update_free_access'] = FALSE;

// Other helpful settings.
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';
$settings['entity_update_batch_size'] = 50;
$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];

// Database connection.
$databases['default']['default'] = [
  'database' => $_ENV['ARTIFAKT_MYSQL_DATABASE_NAME'],
  'username' => $_ENV['ARTIFAKT_MYSQL_USER'],
  'password' => $_ENV['ARTIFAKT_MYSQL_PASSWORD'],
  'prefix' => '',
  'host' => $_ENV['ARTIFAKT_MYSQL_HOST'],
  'port' => $_ENV['ARTIFAKT_MYSQL_PORT'],
  'namespace' => 'Drupal\Core\Database\Driver\mysql',
  'driver' => 'mysql',
];
