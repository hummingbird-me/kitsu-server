module DataExport
  module HTTP
    extend ActiveSupport::Concern

    private

    def simple_auth(profile)
      "#{profile.external_user_id}:#{profile.token}" # add encrpyt
    end

    def get(url, profile, opts)
      request = Typhoeus::Request.new(
        url,
        method: :get,
        userpwd: simple_auth(profile)
      )

      # TODO: @nuck is there a better way to handle this?
      request_status(request) do |response|
        yield response
      end
      request.run
    end

    def post(url, profile, body, opts)
      # isolate the Tyhpoeus method
      # between post/put/delete
      request = Typhoeus::Request.new(
        url,
        method: :post,
        userpwd: simple_auth(profile),
        body: body
      )

      # TODO: @nuck is there a better way to handle this?
      request_status(request) do |response|
        yield response
      end
      request.run
    end

    def put(url, profile, body, opts)
      request = Typhoeus::Request.new(
        url,
        method: :put,
        userpwd: simple_auth(profile),
        body: body
      )

      # TODO: @nuck is there a better way to handle this?
      request_status(request) do |response|
        yield response
      end
      request.run
    end

    def delete(url, profile, opts)
      request = Typhoeus::Request.new(
        url,
        method: :delete,
        userpwd: simple_auth(profile)
      ).run

      # TODO: @nuck is there a better way to handle this?
      request_status(request) do |response|
        yield response
      end
      request.run
    end

    def request_status(request)
      # will return request or nil
      request.on_complete do |response|
        if response.success?
          # this is being sent up to either
          # get/create/update/delete
          # afterwards the chosen method will send it up
          # to the parent request under my_anime_list.rb
          yield response.body
        elsif response.timed_out?
          # aw hell no
          log("got a time out")
        elsif response.code == 0
          # Could not get an http response, something's wrong.
          log(response.return_message)
        else
          # Received a non-successful http response.
          log("HTTP request failed: " + response.code.to_s)
        end
      end
    end
  end
end
