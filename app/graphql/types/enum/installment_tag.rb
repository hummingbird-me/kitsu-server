# frozen_string_literal: true

class Types::Enum::InstallmentTag < Types::Enum::Base
  MAIN_STORY = 'The main story.'
  SIDE_STORY = 'Takes place sometime during the main storyline.'
  SPINOFF = 'Uses characters of a different series, but is not an alternate setting or story.'
  CROSSOVER = 'Characters from different media meet in the same story.'
  ALTERNATE_SETTING = 'Same universe/world/reality/timeline, completely different characters.'
  ALTERNATE_VERSION = 'Same setting, same characters, story is told differently.'

  value 'MAIN_STORY', MAIN_STORY, value: :main_story
  value 'SIDE_STORY', SIDE_STORY, value: :side_story
  value 'SPINOFF', SPINOFF, value: :spinoff
  value 'CROSSOVER', CROSSOVER, value: :crossover
  value 'ALTERNATE_SETTING', ALTERNATE_SETTING, value: :alternate_setting
  value 'ALTERNATE_VERSION', ALTERNATE_VERSION, value: :alternate_version
end
