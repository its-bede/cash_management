# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/pagination.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the Pagination (Pagination1) element
    # @see https://www.iso20022.org/standardsrepository/type/Pagination1
    class Pagination
      attr_reader :page_number, :last_page_indicator, :raw

      def initialize(element)
        @page_number = element.at_xpath('./PgNb')&.text&.to_i
        @last_page_indicator = element.at_xpath('./LastPgInd')&.text == 'true'
        @raw = element.to_s
      end
    end
  end
end