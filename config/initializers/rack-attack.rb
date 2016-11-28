class Rack::Attack
  throttle('logins/ip', limit: 15, period: 60.seconds) do |req|
    if req.path == '/oauth/token' && req.post? && req.params['grant_type'] == 'password'
      req.remote_ip
    end
  end

  throttle('posts/token', limit: 3, period: 60.seconds) do |req|
    if req.path == '/edge/posts' && req.post?
      # return the email if present, nil otherwise
      req.env['HTTP_AUTHORIZATION']
    end
  end
end
