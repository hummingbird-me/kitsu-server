require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'graphql/rake_task'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

GraphQL::RakeTask.new(schema_name: 'KitsuSchema')

Rake::Task['release'].clear
task release: %w[build release:rubygem_push]
