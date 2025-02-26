# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/proprietary_party.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ProprietaryParty5 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ProprietaryParty5
    class ProprietaryParty
      attr_reader :type, :party, :raw

      # Initialize a new ProprietaryParty instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = element.at_xpath("./Tp")&.text
        @party = (Party40Choice.new(element.at_xpath("./Pty")) if element.at_xpath("./Pty"))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
