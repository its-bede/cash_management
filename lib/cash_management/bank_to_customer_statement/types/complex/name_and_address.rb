# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/name_and_address.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the NameAndAddress16 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/NameAndAddress16
    class NameAndAddress
      attr_reader :name, :address, :raw

      # Initialize a new NameAndAddress instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @name = element.at_xpath("./Nm")&.text
        @address = element.at_xpath("./Adr") ? PostalAddress.new(element.at_xpath("./Adr")) : nil
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
