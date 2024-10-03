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
libendpoint_lib_sources = files()
subdir('src')

libendpoint_lib = static_library(
  'libendpoint',
  libendpoint_lib_sources,
  dependencies: [
    dependency('glib-2.0'),
    dependency('gobject-2.0')
  ]
)

subdir('test')

executable(
  meson.project_name(), 
  endpoint_sources, 
  dependencies: endpoint_deps,
  vala_args: [
    '--gresourcesdir=' + blueprints.full_path(),
  ],
  link_with: libendpoint_lib,
  install: true
)
