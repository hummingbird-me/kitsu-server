require 'rails_helper'

RSpec.describe HTML::Pipeline::GifFilter do
  [ 'http://i.imgur.com/z1f8bbB.gif',
    'http://i.imgur.com/z1f8bbB.gifv',
    # giphy embeds are broken
    # 'http://i.giphy.com/UKIUEcSrcvNKM.gif',
    # 'https://media.giphy.com/media/UKIUEcSrcvNKM/giphy.gif',
    'https://j.gifs.com/66Mn8V.gif' ].each do |url|
    link_filter = HTML::Pipeline::AutolinkFilter.new(url, link_attr: 'class="autolink"')
    link = link_filter.call.to_s
    gif_filter = described_class.new(link)

    it 'should convert .gif and .gifv' do
      expect(gif_filter.call.to_s).not_to include('.gif', '.gifv')
    end
  end
end
