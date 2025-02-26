# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/remittance_location.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the RemittanceLocation7 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/RemittanceLocation7
    class RemittanceLocation
      attr_reader :remittance_id, :remittance_location_details, :raw

      # Initialize a new RemittanceLocation instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @remittance_id = element.at_xpath("./RmtId")&.text
        @remittance_location_details = element.xpath("./RmtLctnDtls").map do |details|
          RemittanceLocationData.new(details)
        end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
