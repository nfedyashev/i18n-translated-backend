require 'gdbm'

module I18nTranslatedBackend
  class Storage
    def initialize(file_name)
      @file_name = file_name
    end

    def contains?(key)
      !read(key).nil?
    end

    def read(key)
      begin
        @gdbm = GDBM.new(@file_name)
        @gdbm.fetch(key)
      rescue IndexError
      ensure
        @gdbm.close
      end
    end

    def write(key, value)
      @gdbm = GDBM.new(@file_name)
      @gdbm[key] = value
    ensure
      @gdbm.close
    end

    def delete(key)
      @gdbm = GDBM.new(@file_name)
      @gdbm.delete(key)
    ensure
      @gdbm.close
    end

    def cleanup!
      File.delete(@file_name) if File.exists?(@file_name)
    end
  end
end
