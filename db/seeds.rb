# Load seeds from YAML files in db/seeds/*

require 'seed_file'

MAX_ID = 2 ** 30 - 1
SEED_DIR = 'db/seeds'

previous_logger = ApplicationRecord.logger
ApplicationRecord.logger = Logger.new(nil)

Dir[Rails.root.join("#{SEED_DIR}/*.yml")].each do |f|
  seed = SeedFile.new(f)
  puts "==> Seeding: #{seed.model.name}"
  print "  "
  seed.import! { |key| print "#{key} | " }
  print "\n"
end

ApplicationRecord.logger = previous_logger
