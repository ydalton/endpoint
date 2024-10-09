project(
  'io.github.ydalton.Endpoint', 
  ['c', 'vala'], 
  version: '0.1'
)

glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
gtk_dep = dependency('gtk4')
gtksourceview_dep = dependency('gtksourceview-5')
libsoup_dep = dependency('libsoup-3.0')
json_glib_dep = dependency('json-glib-1.0')

# Silence Vala warnings
add_project_arguments('-Wno-discarded-qualifiers', language: 'c')
add_project_arguments('-Wno-unused-but-set-variable', language: 'c')
add_project_arguments('-Wno-unused-variable', language: 'c')
add_project_arguments('-Wno-unused-function', language: 'c')

gnome = import('gnome')

endpoint_sources = files()
libendpoint_lib_sources = files()
subdir('src')

libendpoint_lib = static_library(
  'endpoint',
  libendpoint_lib_sources,
  dependencies: [
    glib_dep,
    gobject_dep
  ]
)

subdir('test')

config_data = configuration_data()
config_data.set_quoted('VERSION', meson.project_version())
configure_file(
    output: 'config.h',
    configuration: config_data
)

endpoint_deps = [
  glib_dep,
  gobject_dep,
  gtk_dep,
  gtksourceview_dep,
  libsoup_dep,
  json_glib_dep
]

executable(
  meson.project_name(), 
  endpoint_sources, 
  dependencies: endpoint_deps,
  include_directories: include_directories('.'),
  vala_args: [
    '--gresourcesdir=' + blueprints.full_path(),
    '--vapidir', meson.current_source_dir(),
  ],
  c_args: [
    '-include', 'config.h',
  ],
  link_with: libendpoint_lib,
  install: true
)
