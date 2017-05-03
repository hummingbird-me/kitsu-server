if Rails.env.development?
  task :set_annotation_options do
    load 'config/initializers/annotate.rb'
  end

  Annotate.load_tasks
end
