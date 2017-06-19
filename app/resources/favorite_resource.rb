class FavoriteResource < BaseResource
  attributes :fav_rank

  has_one :user
  has_one :item, polymorphic: true

  filters :user_id, :item_type, :item_id

  def self.find_records(filters, opts = {})
    super(filters, opts).select(<<-SQL.squish)
      *, (
        row_number() OVER (
          PARTITION BY user_id, item_type
          ORDER BY fav_rank ASC
        ) - 1
      ) AS fav_rank
    SQL
  end

  def fav_rank
    if _model.fav_rank_position
      case _model.fav_rank_position
      when :first then 1
      when :last then 9_999_999
      when :up, :down then nil
      when Integer then _model.fav_rank_position + 1
      else _model.fav_rank
      end
    else
      _model.fav_rank
    end
  end

  def fav_rank=(val)
    _model.fav_rank_position = (val - 1)
  end
end
