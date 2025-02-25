# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.collapse("#{__dir__}/cash_management/bank_to_customer_statement/types")
loader.setup

require 'date'

module CashManagement
  class Error < StandardError; end
  # Your code goes here...
end
