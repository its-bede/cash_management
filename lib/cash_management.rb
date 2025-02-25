# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.collapse("#{__dir__}/cash_management/bank_to_customer_statement/types")
loader.collapse("#{__dir__}/cash_management/bank_to_customer_statement/types/simple")
loader.collapse("#{__dir__}/cash_management/bank_to_customer_statement/types/complex")
loader.setup

require "date"
require_relative "cash_management/version"
require_relative "cash_management/configuration"

# Main module for the CashManagement gem
# @see CashManagement::Configuration For configuration options
module CashManagement
  class Error < StandardError; end
end
