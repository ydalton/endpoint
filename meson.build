project(
  'endpoint',
  ['c', 'vala'],
  version: '0.1'
)

app_id = 'io.github.ydalton.Endpoint'

os_darwin = false
if host_machine.system() == 'darwin'
  os_darwin = true
endif

glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
gtk_dep = dependency('gtk4')
gtksourceview_dep = dependency('gtksourceview-5')
libsoup_dep = dependency('libsoup-3.0')
json_glib_dep = dependency('json-glib-1.0')

if os_darwin
  libadwaita_dep = dependency('libadwaita-1')
endif

cc = meson.get_compiler('c')

# Silence Vala warnings
if cc.get_id() == 'gcc'
  add_project_arguments('-Wno-discarded-qualifiers', language: 'c')
elif cc.get_id() == 'clang'
  add_project_arguments('-Wno-incompatible-pointer-types-discards-qualifiers', language: 'c')
endif
add_project_arguments('-Wno-unused-but-set-variable', language: 'c')
add_project_arguments('-Wno-unused-variable', language: 'c')
add_project_arguments('-Wno-unused-function', language: 'c')

gnome = import('gnome')
i18n = import('i18n')

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
config_data.set_quoted('APP_ID', app_id)
configure_file(
    output: 'config.h',
    configuration: config_data
)

subdir('data')
subdir('po')

endpoint_deps = [
  glib_dep,
  gobject_dep,
  gtk_dep,
  gtksourceview_dep,
  libsoup_dep,
  json_glib_dep
]

if os_darwin
  endpoint_deps += libadwaita_dep
endif

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

if not os_darwin
  gnome.post_install(
    gtk_update_icon_cache: true,
    update_desktop_database: true
  )
endif
