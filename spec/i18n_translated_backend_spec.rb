require 'spec_helper'

RSpec.describe I18nTranslatedBackend do
  context 'given default config options' do
    example do
      actual = I18nTranslatedBackend.azure_translate_token('%{contare} proprietà. %{some_other_message}')
      expect(actual).to eq('%{contare} properties. %{some_other_message}')
    end
  end

  context 'given custom :display_as decorator' do
    example do
      I18nTranslatedBackend.configure do |config|
        config.display_as = ->(original, translated) { %(#{translated}(***#{original}***)) }
      end

      actual = I18nTranslatedBackend.azure_translate_token('Grazie')
      expect(actual).to eq %(Thank you(***Grazie***))
    end
  end
end
