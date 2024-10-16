conf = configuration_data()
conf.set('app_id', app_id)

desktop_conf = configure_file(
  input: 'app.desktop.in',
  output: '@0@.desktop.in'.format(app_id),
  configuration: conf,
)

desktop_file = i18n.merge_file(
  input: desktop_conf,
  output: '@0@.desktop'.format(app_id),
  type: 'desktop',
  po_dir: '../po',
  install: true,
  install_dir: get_option('datadir') / 'applications',
)

subdir('icons')
