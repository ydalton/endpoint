endpoint_sources += files(
  'Endpoint.vala',
  'camouflage.c'
)

blueprint_sources = files()
subdir('View')

subdir('Utils')

blueprints = custom_target('blueprints',
  input: blueprint_sources,
  output: '.',
  command: [
    find_program('blueprint-compiler'), 
    'batch-compile', 
    '@OUTPUT@',
    '@CURRENT_SOURCE_DIR@', 
    '@INPUT@'
  ],
)

endpoint_sources += gnome.compile_resources(
  'endpoint-resources',
  'endpoint.gresources.xml',
  c_name: 'endpoint_resources_',
  dependencies: blueprints
)

