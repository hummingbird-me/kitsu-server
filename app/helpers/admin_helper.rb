module AdminHelper
  def url_for(options = nil)
    puts super
    return super if super.include?("/api")
    split_url = super.split('/admin')
    joined_url = split_url.join('/api/admin')
    puts joined_url
    # for some reason it's necessary to split and rejoin, otherwise we either get /admin or /api/api/admin
    joined_url
    end
end
