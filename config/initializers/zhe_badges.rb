Dir[Rails.root + './app/badges/*.rb'].each do |file|
  require file
end
