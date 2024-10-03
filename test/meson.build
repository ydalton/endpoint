test_show_length = executable(
  'test-show-length',
  'test-show-length.vala',
  dependencies: [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
  ],
  # HACK
  c_args: [
    '-I.'
  ],
  link_with: libendpoint_lib
)

test(
  'test-show-length',
  test_show_length,
  protocol: 'tap'
)