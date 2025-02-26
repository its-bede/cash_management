# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/remittance_location_data.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the RemittanceLocationData1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/RemittanceLocationData1
    class RemittanceLocationData
      attr_reader :method, :electronic_address, :postal_address, :raw

      # Initialize a new RemittanceLocationData instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @method = element.at_xpath("./Mtd")&.text
        @electronic_address = element.at_xpath("./ElctrncAdr")&.text
        @postal_address = if element.at_xpath("./PstlAdr")
                            NameAndAddress.new(element.at_xpath("./PstlAdr"))
                          end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
