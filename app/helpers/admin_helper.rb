module AdminHelper
  def url_for(options = nil)
    x = super.split("/admin")
    y = x.join("/api/admin")
    puts y
    y
  end
end
