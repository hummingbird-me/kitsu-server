class Types::Enum::InstallmentTag < Types::Enum::Base
  value 'MAIN_STORY', 'The main story', value: :main_story
  value 'SIDE_STORY', '', value: :side_story
  value 'SPINOFF', 'Related to main story with a new narrative', value: :spinoff
  value 'CROSSOVER', 'When characters from different media come together', value: :crossover
  value 'ALTERNATE_SETTING', 'Same universe, with different characters or visa-versa', value: :alternate_setting
end
