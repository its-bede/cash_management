# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.collapse("#{__dir__}/cash_management/bank_to_customer_statement/types")
loader.collapse("#{__dir__}/cash_management/bank_to_customer_statement/types/simple")
loader.collapse("#{__dir__}/cash_management/bank_to_customer_statement/types/complex")
loader.setup

require "date"

# Namespace for the CashManagement gem
module CashManagement
  class Error < StandardError; end

  # Configure the gem
  # @example
  #   CashManagement.configure do |config|
  #     config.strict_parsing = true
  #   end
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config) if block_given?
      config
    end

    # Reset the configuration to defaults
    # @return [CashManagement::Configuration] The reset configuration
    def reset_config!
      @config = Configuration.new
    end
  end
end
