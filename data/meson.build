desktop_conf = configure_file(
  input: 'app.desktop.in',
  output: '@0@.desktop'.format(app_id),
  configuration: config_data,
  install: true,
  install_dir: get_option('datadir') / 'applications',
)
