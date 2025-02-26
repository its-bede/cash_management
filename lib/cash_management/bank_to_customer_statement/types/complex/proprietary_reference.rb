# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/proprietary_reference.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ProprietaryReference1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ProprietaryReference1
    class ProprietaryReference
      attr_reader :type, :reference, :raw

      # Initialize a new ProprietaryReference instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = element.at_xpath("./Tp")&.text
        @reference = element.at_xpath("./Ref")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
