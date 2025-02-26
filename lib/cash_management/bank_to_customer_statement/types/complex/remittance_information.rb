# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/remittance_information.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the RemittanceInformation16 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/RemittanceInformation16
    class RemittanceInformation
      attr_reader :unstructured, :structured, :raw

      # Initialize a new RemittanceInformation instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @unstructured = element.xpath("./Ustrd").map(&:text)
        @structured = element.xpath("./Strd").map do |strd|
          StructuredRemittanceInformation.new(strd)
        end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
