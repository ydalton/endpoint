project(
  'io.github.ydalton.Endpoint', 
  ['c', 'vala'], 
  version: '0.1'
)

endpoint_deps = [
  dependency('gtk4'),
  dependency('gtksourceview-5'),
  dependency('libsoup-3.0'),
  dependency('json-glib-1.0')
]

gnome = import('gnome')

endpoint_sources = files()
subdir('src')

executable(
  meson.project_name(), 
  endpoint_sources, 
  dependencies: endpoint_deps,
  vala_args: [
    '--gresourcesdir=' + blueprints.full_path(),
  ],
  install: true
)
