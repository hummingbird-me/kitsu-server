class MyAnimeListScraper
  module DateRangeParser
    extend ActiveSupport::Concern

    def parse_date(date_str)
      return nil if date_str.strip == '?'
      Date.strptime(date_str, '%b %d, %Y')
    rescue ArgumentError
      Date.strptime(date_str, '%Y')
    end

    def parse_date_range(date_range_str)
      if date_range_str.include?(' to ')
        start_date, end_date = date_range_str.split(' to ').map(&:strip)
        [parse_date(start_date), parse_date(end_date)]
      else
        [parse_date(date_range_str.strip)] * 2
      end
    end
  end
end
