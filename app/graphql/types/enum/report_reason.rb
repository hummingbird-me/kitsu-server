class Types::Enum::ReportReason < Types::Enum::Base
  value 'NSFW', 'Not Safe For Work', value: 'nsfw'
  value 'OFFENSIVE', '', value: 'offensive'
  value 'SPOILER', '', value: 'spoiler'
  value 'BULLYING', 'No bulli!', value: 'bullying'
  value 'SPAM', '', value: 'spam'
  value 'OTHER', '', value: 'other'
end
