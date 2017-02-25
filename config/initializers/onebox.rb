require_dependency 'onebox/engine/giphy_onebox.rb'
require_dependency 'onebox/engine/gifs_com_onebox.rb'
require_dependency 'onebox/engine/imgur_onebox.rb'
require_dependency 'onebox/engine/image_onebox.rb'

Onebox::Engine::WhitelistedGenericOnebox.whitelist.push("streamable.com")
