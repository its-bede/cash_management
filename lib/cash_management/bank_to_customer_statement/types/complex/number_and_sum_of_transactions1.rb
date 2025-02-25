# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/number_and_sum_of_transactions1.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the NumberAndSumOfTransactions1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/NumberAndSumOfTransactions1
    class NumberAndSumOfTransactions1
      attr_reader :number_of_entries, :sum, :raw

      # Initialize a new NumberAndSumOfTransactions1 instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @number_of_entries = element.at_xpath('./NbOfNtries')&.text
        @sum = parse_decimal(element.at_xpath('./Sum')&.text)
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse a decimal value
      # @param decimal_str [String, nil] The decimal string
      # @return [Float, nil] The parsed decimal or nil
      def parse_decimal(decimal_str)
        return nil unless decimal_str

        decimal_str.to_f
      end
    end
  end
end
