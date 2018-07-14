# encoding: UTF-8
require 'i18n'
require 'net/https'
require 'json'
require 'securerandom'

require 'configuration'
require 'storage'
require 'version'

module I18nTranslatedBackend
  class << self
    # A I18nTranslatedBackend configuration object. Must act like a hash and return sensible
    # values for all I18nTranslatedBackend configuration options. See I18nTranslatedBackend::Configuration.
    attr_writer :configuration

    # Call this method to modify defaults in your initializers.
    #
    # @example
    #   I18nTranslatedBackend.configure do |config|
    #     config.storage = I18nTranslatedBackend::Storage.new("en-it-translations.db")
    #     config.display_as = ->(original, translated) { translated }
    #   end
    def configure
      yield(configuration)
    end

    # The configuration object.
    # @see I18nTranslatedBackend.configure
    def configuration
      @configuration ||= Configuration.new
    end

    def reset_configuration
      @configuration = nil
    end

    # @param [String] locale_token - actual message to translate
    #                                note: it may interpolation key e.g. "%{count} proprietà. %{some_other_message}"
    # @return [String] translated message without affecting interpolation keys e.g. "%{count} thanks %{some_other_message}"
    def azure_translate_token(locale_token)
      if configuration.storage.contains?(locale_token)
        translated = configuration.storage.read(locale_token)
        configuration.display_as.call locale_token, translated
      else
        original = perform_http_request(locale_token)
        configuration.storage.write locale_token, original
        configuration.display_as.call locale_token, original
      end
    end

    def perform_http_request(locale_token)
      interpolation_raw_occurences = []
      special_placeholder = "±"
      text = locale_token.gsub(/%{[\w]+}/) do
        interpolation_raw_occurences << $&
        special_placeholder
      end

      key = configuration.api_key
      host = 'https://api.cognitive.microsofttranslator.com'
      path = '/translate?api-version=3.0'
      params = "&from=#{configuration.from}&to=#{configuration.to}"

      uri = URI (host + path + params)

      content = '[{"Text" : "' + text + '"}]'

      request = Net::HTTP::Post.new(uri)
      request['Content-type'] = 'application/json'
      request['Content-length'] = content.length
      request['Ocp-Apim-Subscription-Key'] = key
      request['X-ClientTraceId'] = SecureRandom.uuid
      request.body = content


      response = Net::HTTP.start(uri.host, use_ssl: true) { |http| http.request (request) }

      translation = JSON.parse(response.body.force_encoding("utf-8")).first['translations'].first['text']

      index = 0
      translation.gsub(special_placeholder) { interpolation_raw_occurences[index].tap { index = index + 1} }
    end
  end
end
