# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/charges.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the Charges6 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/Charges6
    class Charges
      attr_reader :total_charges_and_tax_amount, :records, :raw

      # Initialize a new Charges instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @total_charges_and_tax_amount = parse_amount(element.at_xpath("./TtlChrgsAndTaxAmt"))
        @records = element.xpath("./Rcrd").map { |rcrd| ChargesRecord.new(rcrd) }
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
          currency: element.attribute("Ccy")&.value
        }
      end
    end
  end
end
