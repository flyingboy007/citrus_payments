require 'net/http'
require 'uri'
require 'json'

require "citrus_payments/version"
require "citrus_payments/configuration"
require "errors/configuration"
require "errors/input"
require "citrus_payments/utility"
require "citrus_payments/merchant"
require "citrus_payments/marketplace/authentication"
require "citrus_payments/marketplace/seller"
require "citrus_payments/marketplace/split"
require "citrus_payments/marketplace/settlement"
require "citrus_payments/marketplace/transaction"


module CitrusPayments
  #class << self bit tells our CitrusPayments module that this instance variable is on the module scope
  class << self
    attr_accessor :configuration
  end

  #Writing and reading the configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  #Resetting
  #This will reset the @configuration settings to nil if needed in future
  def self.reset
    @configuration = Configuration.new
  end

  #Passing a block to our class
  #When we call CitrusPayments.configure, we pass it a block that actually creates a new instance of the CitrusPayments::Configuration class using whatever we’ve set inside of the block.
  def self.configure
    yield(configuration)
  end

end
