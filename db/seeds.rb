# Load seeds from YAML files in db/seeds/*

MAX_ID = 2 ** 30 - 1
SEED_DIR = 'db/seeds'

Dir[Rails.root.join("#{SEED_DIR}/*.yml")].each do |f|
  basename = File.basename(f, File.extname(f))
  yaml = YAML::load_file(f)
  model = basename.classify.constantize
  puts "==> Seeding: #{model.name}"

  yaml.each do |key, values|
    print "#{key} "
    row = model.where(id: values['id']).first_or_initialize
    row.assign_attributes(values)
    row.save!
  end
  print "\n"
end
