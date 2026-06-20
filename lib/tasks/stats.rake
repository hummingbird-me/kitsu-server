task :stats => "kitsu:stats_setup"

namespace :kitsu do
  task :stats_setup do
    require 'rails/code_statistics'
    {
      'Indices' => 'app/chewy',
      'Workers' => 'app/workers',
      'Resources' => 'app/resources',
      'Services' => 'app/services',
      'Policies' => 'app/policies'
    }.each do |label, path|
      Rails::CodeStatistics.register_directory(label, path)
    end
    Rails::CodeStatistics.directories.sort_by! { |dir| dir[0] }
  end
end
