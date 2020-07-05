class Types::Enum::CharacterRole < Types::Enum::Base
  value 'MAIN', 'A character who appears throughout a series and is a focal point of the media',
    value: 'main'
  value 'RECURRING', 'A character who appears in multiple episodes but is not a main character',
    value: 'recurring'
  value 'BACKGROUND', 'A background character who generally only appears in a few episodes',
    value: 'supporting'
  value 'CAMEO', 'A character from a different franchise making a (usually brief) appearance',
    value: 'cameo'
end
