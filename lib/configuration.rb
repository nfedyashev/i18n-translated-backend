module I18nTranslatedBackend
  class Configuration
    VALID_OPTION_KEYS = [
      :storage,
    ].freeze

    attr_accessor(*VALID_OPTION_KEYS)

    def initialize
      @storage = I18nTranslatedBackend::Storage.new"en-it-translations.db"
    end
  end
end
