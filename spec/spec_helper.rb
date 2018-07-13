require 'simplecov'
SimpleCov.start

require 'i18n-translated-backend'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before do
    I18nTranslatedBackend.reset_configuration
  end
end
