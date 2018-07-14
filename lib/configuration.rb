module I18nTranslatedBackend
  class Configuration
    VALID_OPTION_KEYS = [
      :storage,
      :display_as
    ].freeze

    attr_accessor(*VALID_OPTION_KEYS)

    def initialize
      @storage = I18nTranslatedBackend::Storage.new"en-it-translations.db"
      @display_as = ->(original, translated) { translated }
    end
  end
end
