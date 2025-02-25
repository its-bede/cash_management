# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/tax_charges.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TaxCharges2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TaxCharges2
    class TaxCharges
      attr_reader :id, :rate, :amount, :raw

      # Initialize a new TaxCharges instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @id = element.at_xpath('./Id')&.text
        @rate = parse_percentage_rate(element.at_xpath('./Rate')&.text)
        @amount = parse_amount(element.at_xpath('./Amt'))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse a percentage rate
      # @param rate_str [String, nil] The rate string
      # @return [Float, nil] The parsed rate or nil
      def parse_percentage_rate(rate_str)
        return nil unless rate_str

        rate_str.to_f
      end

      # Parse an amount element
      # @param element [Nokogiri::XML::Element, nil] The amount element
      # @return [Hash, nil] The parsed amount or nil
      def parse_amount(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute('Ccy')&.value
        }
      end
    end
  end
end
