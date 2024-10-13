# frozen_string_literal: true

class Types::Enum::MediaRelationshipKind < Types::Enum::Base
  description 'The relationship kind from one media entry to another'

  value 'SEQUEL', value: 'sequel'
  value 'PREQUEL', value: 'prequel'
  value 'ALTERNATIVE_SETTING', value: 'alternative_setting'
  value 'ALTERNATIVE_VERSION', value: 'alternative_version'
  value 'SIDE_STORY', value: 'side_story'
  value 'PARENT_STORY', value: 'parent_story'
  value 'SUMMARY', value: 'summary'
  value 'FULL_STORY', value: 'full_story'
  value 'SPINOFF', value: 'spinoff'
  value 'ADAPTATION', value: 'adaptation'
  value 'CHARACTER', value: 'character'
  value 'OTHER', value: 'other'
end
