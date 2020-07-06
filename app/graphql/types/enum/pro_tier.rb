class Types::Enum::ProTier < Types::Enum::Base
  value 'AO_PRO', 'Aozora Pro (only hides ads)',
    deprecation_reason: 'No longer for sale',
    value: 'ao_pro'
  value 'AO_PRO_PLUS', 'Aozora Pro+ (only hides ads)',
    deprecation_reason: 'No longer for sale',
    value: 'ao_pro'
  value 'PRO', 'Basic tier of Kitsu Pro',
    value: 'pro'
  value 'PATRON', 'Top tier of Kitsu Pro',
    value: 'patron'
end
