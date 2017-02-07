module AdminHelper
  def url_for(options = nil)
    return super if super.include?('/api/')
    split_url = super.split('/admin')
    joined_url = split_url.join('/api/admin')
    # for some reason it's necessary to split and rejoin, otherwise we either get /admin or /api/api/admin
    joined_url
  end

  # def dashboard_path(options = nil)
  #   return super if super.include?('/api/')
  #   split_url = super.split('/admin')
  #   joined_url = split_url.join('/api/admin')
  #   joined_url
  # end

  # def index_path(options = nil, url)
  #   return super if super.include?('/api/')
  #   split_url = super.split('/admin')
  #   joined_url = split_url.join('/api/admin')
  #   joined_url
  # end
  #
  # def new_path(options = nil, url)
  #   puts 'new path'
  #   split_url = super.split('/admin')
  #   joined_url = split_url.join('/api/admin')
  #   joined_url
  # end
  #
  # def edit_path(options = nil, url)
  #   puts 'edit path'
  #   split_url = super.split('/admin')
  #   joined_url = split_url.join('/api/admin')
  #   joined_url
  # end



  # def base_uri
  #   puts "base_uri"
  #   puts super
  #   super
  # end

  # def path_for(options = nil)
  #   return super if super.include?('/api/')
  #   split_url = super.split('/admin')
  #   joined_url = split_url.join('/api/admin')
  #   # for some reason it's necessary to split and rejoin, otherwise we either get /admin or /api/api/admin
  #   joined_url
  # end

  # def base_url
  #   puts "base_url running"
  # end

  # def link_to(body, url, html_options = {})
  #   puts "link_to"
  #   puts url
  #   super
  # end

  # def button_to(_name = nil, _options = nil, _html_options = nil)
  #   puts "button_to running"
  #   '123'
  # end
  #
  # def index_path(options = nil, url)
  #   puts "index path"
  #   puts super
  #   super
  # end
end
