require 'spec_helper'

RSpec.describe I18nTranslatedBackend do
  example do
    actual = I18nTranslatedBackend.azure_translate_token('%{contare} proprietà. %{some_other_message}')
    expect(actual).to eq('%{contare} properties. %{some_other_message}')
  end
end
