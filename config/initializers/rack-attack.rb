class Rack::Attack
  throttle('logins/ip', limit: 15, period: 60.seconds) do |req|
    if req.path == '/api/oauth/token' && req.post? && req.params['grant_type'] == 'password'
      ActionDispatch::Request.new(req.env).remote_ip
    end
  end

  throttle('registrations/ip', limit: 5, period: 1.hour) do |req|
    if req.path == '/api/edge/users' && req.post?
      ActionDispatch::Request.new(req.env).remote_ip
    end
  end

  throttle('posts/token', limit: 3, period: 60.seconds) do |req|
    if req.path == '/api/edge/posts' && req.post?
      # return the email if present, nil otherwise
      req.env['HTTP_AUTHORIZATION']
    end
  end

  throttle('likes/token', limit: 40, period: 120.seconds) do |req|
    if req.path == '/api/edge/post-likes' || req.path == '/api/edge/comment-likes' && req.post?
      # return the email if present, nil otherwise
      req.env['HTTP_AUTHORIZATION']
    end
  end

  throttle('follows/token', limit: 50, period: 300.seconds) do |req|
    if req.path == '/api/edge/follows' && req.post?
      # return the email if present, nil otherwise
      req.env['HTTP_AUTHORIZATION']
    end
  end
end
