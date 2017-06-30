if Rails.env.development?
  # You can override any of these by setting an environment variable of the
  # same name.
  Annotate.set_defaults(
    'classified_sort'         => 'true',
    'exclude_controllers'     => 'true',
    'force'                   => 'true',
    'format_bare'             => 'true',
    'hide_limit_column_types' => 'integer,boolean',
    'routes'                  => 'true',
    'show_foreign_keys'       => 'true',
    'show_indexes'            => 'true',
    'simple_indexes'          => 'true',
    'wrapper'                 => 'true',
    'wrapper_open'            => 'rubocop:disable Metrics/LineLength',
    'wrapper_close'           => 'rubocop:enable Metrics/LineLength',
    'position_in_routes'      => 'bottom'
  )
end
