# frozen_string_literal: true

# CashManagement gem configuration
CashManagement.configure do |config|
  # Whether to raise errors on missing required elements or invalid values
  config.strict_parsing = false

  # Whether to keep the raw XML for each parsed element
  config.keep_raw_xml = true

  # Use the Rails logger
  config.logger = Rails.logger
end
