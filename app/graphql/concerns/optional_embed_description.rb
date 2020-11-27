# frozen_string_literal: true

module OptionalEmbedDescription
  extend ActiveSupport::Concern

  AUDIO_DESCRIPTION = 'A URL to an audio file to accompany this object.'
  DESCRIPTION = 'A one to two sentence description of your object.'
  DETERMINER_DESCRIPTION = %q[
    The word that appears before this object's title in a sentence.
    An enum of (a, an, the, "", auto). If auto is chosen,
    the consumer of your data should chose between "a" or "an". Default is "" (blank).
  ]
  LOCALE_DESCRIPTION = %[
    The locale these tags are marked up in.
    Of the format language_TERRITORY. Default is en_US.
  ]
  LOCALE_ALTERNATIVE_DESCRIPTION = 'An array of other locales this page is available in.'
  SITE_NAME_DESCRIPTION = %[
    If your object is part of a larger web site,
    the name which should be displayed for the overall site.
  ]
  VIDEO_DESCRIPTION = 'A URL to a video file that complements this object.'
end
