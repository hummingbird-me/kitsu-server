namespace :graphql do
  task :dump_schema do
    require 'graphql/rake_task'

    GraphQL::RakeTask.new(
      load_schema: ->(_task) {
        require File.expand_path('../../app/graphql/kitsu_schema', __dir__)
        KitsuSchema
      },
      directory: './' # Creates ./schema.graphql
    )

    Rake::Task['graphql:schema:idl'].invoke
  end
end
