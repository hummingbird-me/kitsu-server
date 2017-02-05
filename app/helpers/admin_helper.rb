module AdminHelper
  def url_for(options = nil)
    split_url = super.split("/admin")
    joined_url = x.join("/api/admin")
    #for some reason it's necessary to split and rejoin, otherwise we either get /admin or /api/api/admin
    joined_url
  end
end
