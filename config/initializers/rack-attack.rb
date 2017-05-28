class Rack::Attack
  throttle('logins/ip', limit: 15, period: 60.seconds) do |req|
    if req.path == '/api/oauth/token' && req.post? && req.params['grant_type'] == 'password'
      ActionDispatch::Request.new(req.env).remote_ip
    end
  end

  throttle('posts/token', limit: 3, period: 60.seconds) do |req|
    if req.path == '/api/edge/posts' && req.post?
      # return the email if present, nil otherwise
      req.env['HTTP_AUTHORIZATION']
    end
  end
end
