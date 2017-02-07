module AdminHelper
  def url_for(options = nil)
    return super if super.include?('/api/')
    split_url = super.split('/admin')
    joined_url = split_url.join('/api/admin')
    # for some reason it's necessary to split and rejoin, otherwise we either get /admin or /api/api/admin
    joined_url
  end

  def dashboard_path(options = {})
    return super if super.include?('/api/')
    split_url = super.split('/admin')
    joined_url = split_url.join('/api/admin')
    joined_url
  end

  def index_path(index, options = {})
    return super if super.include?('/api/')
    split_url = super.split('/admin')
    joined_url = split_url.join('/api/admin')
    joined_url
  end

  def redirect_path(redirect, options = {})
    return super if super.include?('/api/')
    split_url = super.split('/admin')
    joined_url = split_url.join('/api/admin')
    joined_url
  end

  def edit_path(edit, options = {})
    return super if super.include?('/api/')
    split_url = super.split('/admin')
    joined_url = split_url.join('/api/admin')
    joined_url
  end

end
