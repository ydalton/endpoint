project(
  'io.github.ydalton.Endpoint', 
  ['c', 'vala'], 
  version: '0.1'
)

endpoint_deps = [
  dependency('gtk4')
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
)
