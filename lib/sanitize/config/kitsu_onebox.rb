class Sanitize
  module Config
    KITSU_ONEBOX ||= freeze_config merge(ONEBOX,
      attributes: merge(ONEBOX[:attributes],
        'video' => %w[controls height autoplay loop width]))
  end
end
