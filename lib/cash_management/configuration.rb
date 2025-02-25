# frozen_string_literal: true

require 'logger'

# lib/cash_management/configuration.rb

module CashManagement
  # Configuration class for the CashManagement gem
  class Configuration
    # @return [Boolean] Whether to raise errors on missing required elements or invalid values
    attr_accessor :strict_parsing

    # Whether to keep the raw XML for each parsed element
    # @return [Boolean]
    attr_accessor :keep_raw_xml
    
    # Logger for the gem
    # @return [Logger, nil]
    attr_accessor :logger

    def initialize
      @strict_parsing = false
      @keep_raw_xml = true
      # Default to nil instead of creating a logger
      @logger = nil
    end

    # Get the current logger or create a default one if none is set
    # @return [Logger]
    def logger
      @logger ||= default_logger
    end

    private

    # Create a default logger that outputs to null device
    # @return [Logger]
    def default_logger
      logger = Logger.new(File::NULL)
      logger.level = Logger::WARN
      logger
    end
  end

  # @return [Configuration] Current configuration
  def self.config
    @config ||= Configuration.new
  end

  # Configure the gem
  # @yield [config] Configuration object
  # @example
  #   CashManagement.configure do |config|
  #     config.keep_raw_xml = true
  #     config.logger = Rails.logger
  #   end
  def self.configure
    yield(config)
  end

  # Reset the configuration to defaults
  # @return [Configuration] Reset configuration
  def self.reset_config!
    @config = Configuration.new
  end
end

