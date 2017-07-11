module CitrusPayments
  class Configuration
    attr_accessor :access_key, :secret_key, :vanity_url, :base_url

    def initialize
      @access_key = nil
      @secret_key = nil
      @vanity_url = nil
      @base_url = nil
    end

    def access_key
      raise CitrusPayments::Errors::Configuration, "Citrus access_key missing!" unless @access_key
      @access_key
    end

    def secret_key
      raise CitrusPayments::Errors::Configuration, "Citrus secret_key missing!" unless @secret_key
      @secret_key
    end

    def vanity_url
      raise CitrusPayments::Errors::Configuration, "Citrus vanity_url missing!" unless @vanity_url
      @vanity_url
    end

    def base_url
      raise CitrusPayments::Errors::Configuration, "Citrus base_url missing!" unless @base_url
      @base_url
    end
  end
end