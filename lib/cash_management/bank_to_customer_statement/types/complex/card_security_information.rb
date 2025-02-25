# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/card_security_information.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the CardSecurityInformation1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CardSecurityInformation1
    class CardSecurityInformation
      attr_reader :csc_management, :csc_value, :raw

      # Initialize a new CardSecurityInformation instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @csc_management = element.at_xpath('./CSCMgmt')&.text
        @csc_value = element.at_xpath('./CSCVal')&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end