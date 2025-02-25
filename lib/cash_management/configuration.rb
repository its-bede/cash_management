# frozen_string_literal: true

# lib/cash_management/configuration.rb

module CashManagement
  # Configuration class
  class Configuration
    # @return [Boolean] Whether to raise errors on missing required elements or invalid values
    attr_accessor :strict_parsing

    # @return [Boolean] Whether to keep the raw XML in the parsed objects as .raw_xml method
    attr_accessor :keep_raw_xml

    def initialize
      @strict_parsing = false
      @keep_raw_xml = true
    end
  end
end
