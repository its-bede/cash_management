# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/number_and_sum_of_transactions4.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the NumberAndSumOfTransactions4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/NumberAndSumOfTransactions4
    class NumberAndSumOfTransactions4
      attr_reader :number_of_entries, :sum, :total_net_entry, :raw

      # Initialize a new NumberAndSumOfTransactions4 instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @number_of_entries = element.at_xpath("./NbOfNtries")&.text
        @sum = parse_decimal(element.at_xpath("./Sum")&.text)
        @total_net_entry = parse_amount_and_direction(element.at_xpath("./TtlNetNtry"))
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

      # Parse an amount and direction element
      # @param element [Nokogiri::XML::Element, nil] The element to parse
      # @return [Hash, nil] The parsed amount and direction or nil
      def parse_amount_and_direction(element)
        return nil unless element

        {
          amount: parse_decimal(element.at_xpath("./Amt")&.text),
          credit_debit_indicator: element.at_xpath("./CdtDbtInd")&.text
        }
      end
    end
  end
end
