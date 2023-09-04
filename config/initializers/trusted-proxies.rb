# frozen_string_literal: true

if Rails.env.production? || Rails.env.staging?
  # Grab Cloudflare IPs
  cloudflare_ips = %w[
    https://www.cloudflare.com/ips-v4
    https://www.cloudflare.com/ips-v6
  ].map { |url| URI.parse(url).open.read.split("\n") }.flatten

  # Grab IPs for all our Droplets
  droplet_ips = if ENV['DIGITALOCEAN_TOKEN'].present?
    HTTP
      .auth("Bearer #{ENV.fetch('DIGITALOCEAN_TOKEN', nil)}")
      .get('https://api.digitalocean.com/v2/droplets?per_page=200')
      .parse['droplets'].map { |droplet|
      [
        droplet['networks']['v4'].pluck('ip_address'),
        droplet['networks']['v6'].pluck('ip_address')
      ]
    }.flatten
  else
    []
  end

  env_ips = ENV['TRUSTED_PROXIES']&.split(',') || []

  trusted_ips = [cloudflare_ips, droplet_ips, env_ips].flatten.map { |ip| IPAddr.new(ip) }

  Rails.application.config.action_dispatch.trusted_proxies = trusted_ips
end
