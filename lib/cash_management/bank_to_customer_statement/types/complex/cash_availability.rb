# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/cash_availability.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the CashAvailability1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CashAvailability1
    class CashAvailability
      attr_reader :date, :amount, :credit_debit_indicator, :raw

      # Initialize a new CashAvailability instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @date = element.at_xpath('./Dt') ?
                  CashAvailabilityDate.new(element.at_xpath('./Dt')) : nil
        @amount = parse_amount(element.at_xpath('./Amt'))
        @credit_debit_indicator = element.at_xpath('./CdtDbtInd')&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

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
