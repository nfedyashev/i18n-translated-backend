require 'spec_helper'

RSpec.describe I18nTranslatedBackend do
  before do
    described_class.send(:configuration).storage.cleanup!
  end

  let(:storage_backend) { described_class.send(:configuration).storage }
  let(:update) { -> { storage_backend.write key, 'new value'} }
  let(:key) { 'key1' }

  describe '#contains?' do
    example do
      expect(update).to change {storage_backend.contains? key}.from(false).to(true)
    end
  end

  describe 'read' do
    example do
      expect(update).to change {storage_backend.read key}.from(nil).to('new value')

      update.call

      expect(storage_backend.read(key)).to eq('new value')
    end
  end

  describe 'delete' do
    before do
      storage_backend.write key, 'new value'
    end

    example do
      delete = -> { storage_backend.delete(key) }

      expect(delete).to change {storage_backend.contains? key}.from(true).to(false)

      delete.call
    end
  end

  context '.configure' do
    example do
      CustomStorage = Class.new do
        def contains?(key)
          raise 'custom err message'
        end

        def read(key)
          :noop
        end

        def write(key, value)
          :noop
        end

        def delete(key)
          :noop
        end

        def cleanup!
          :noop
        end
      end

      described_class.configure do |config|
        config.storage = CustomStorage.new
      end

      expect { described_class.configuration.storage.contains?(:k) }.to raise_error('custom err message')
    end
  end
end
