require 'zorro'

class ListImport
  class Zorro < ListImport
    validates :input_text, presence: true

    def count
      Zorro::DB::AnimeProgress.count(for_user)
    end

    def each
      Zorro::DB::AnimeProgresss.find(for_user).each do |entry|
        row = Row.new(entry)
        yield row.media, row.data
      end
    end

    private

    def for_user
      { _p_user: "_User$#{input_text}" }
    end
  end
end
