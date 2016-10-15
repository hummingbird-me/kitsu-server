# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  error_message           :text
#  error_trace             :text
#  input_file_content_type :string
#  input_file_file_name    :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  progress                :integer
#  status                  :integer          default(0), not null
#  strategy                :integer          not null
#  total                   :integer
#  type                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer          not null
#
# rubocop:enable Metrics/LineLength

class ListImport
  class Anilist < ListImport
    ANILIST_API = 'https://anilist.co/api/'.freeze

    # accepts a username as input
    validates :input_text, length: {
      minimum: 3,
      maximum: 20
    }, presence: true
    # does not accept file uploads
    validates :input_file, absence: true

    # def initialize(input_text)
    #   # @input_text = input_text
    #   @auth_token = get_auth_token
    # end

    def count
      # animelist will get me everything
      get("#{input_text}/animelist")['stats']['status_distribution'].map { |type|
        type.last.values.inject(&:+)
      }.inject(&:+)
    end

    def each
      # pass in toyhammered/#{anime}list
    end

    private

    def get_auth_token
      url = "#{ANILIST_API}auth/access_token"
      request = Typhoeus::Request.new(url,
        method: :post,
        body: {
          grant_type: 'client_credentials',
          client_id: 'toyhammered-c6imc',
          client_secret: 'P8sO0FJ58OwluYiek30N'
        },
        headers: { Accept: 'application/json'}
      )

      request.run

      json = JSON.parse(request.response.body)['access_token']
      json
    end

    def get(url, opts = {})
      @auth_token ||= get_auth_token
      url = build_url(url)

      request = Typhoeus::Request.get(url)

      json = JSON.parse(request.body)
      json
    end

    def build_url(path)
      #toyhammered/animelist
      "#{ANILIST_API}user/#{path}?access_token=#{@auth_token}"
    end
  end
end
