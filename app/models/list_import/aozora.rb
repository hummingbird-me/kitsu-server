class ListImport
  class Aozora < ListImport
    validates :input_text, presence: true
    validates :input_file_data, absence: true

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
