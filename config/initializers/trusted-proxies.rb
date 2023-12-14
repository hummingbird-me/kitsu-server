# frozen_string_literal: true

Sentry.with_scope do |scope|
  scope.set_transaction_name('initializers/trusted-proxies')

  if true || Rails.env.production? || Rails.env.staging?
    cloudflare_ips = begin
      # Grab Cloudflare IPs
      %w[
        https://www.cloudflare.com/ips-v4
        https://www.cloudflare.com/ips-v6
      ].map { |url| URI.parse(url).open.read.split("\n") }.flatten
    rescue StandardError => e
      Sentry.capture_exception(e)
      []
    end

    # Grab IPs for all our Droplets
    droplet_ips = begin
      next [] if ENV['DIGITALOCEAN_TOKEN'].blank?

      response = HTTP.auth("Bearer #{ENV.fetch('DIGITALOCEAN_TOKEN', nil)}")
                     .get('https://api.digitalocean.com/v2/droplets?per_page=200')

      response.parse['droplets'].map { |droplet|
        [
          droplet['networks']['v4'].pluck('ip_address'),
          droplet['networks']['v6'].pluck('ip_address')
        ]
      }.flatten
    rescue StandardError => e
      Sentry.capture_exception(e)
      []
    end

    env_ips = ENV['TRUSTED_PROXIES']&.split(',') || []

    trusted_ips = [cloudflare_ips, droplet_ips, env_ips].flatten.map { |ip| IPAddr.new(ip) }

    Rails.application.config.action_dispatch.trusted_proxies = trusted_ips
  end
end
