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
  class Aozora < ListImport
    validates :input_text, presence: true

    def count
      ::Zorro::DB::AnimeProgress.count(for_user)
    end

    def each
      ::Zorro::DB::AnimeProgress.find(for_user).each do |entry|
        row = Row.new(entry)
        yield row.media, row.data
      end
    end

    # Just override the default value for queue
    def apply_async!(queue: 'eventually')
      super
    end

    private

    # @return [Hash] the MongoDB query object for the user's AnimeProgress documents
    def for_user
      { _p_user: "_User$#{input_text}" }
    end
  end
end
