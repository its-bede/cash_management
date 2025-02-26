# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/tax_party2.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TaxParty2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TaxParty2
    class TaxParty2
      attr_reader :tax_id, :registration_id, :tax_type, :authorisation, :raw

      # Initialize a new TaxParty2 instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @tax_id = element.at_xpath("./TaxId")&.text
        @registration_id = element.at_xpath("./RegnId")&.text
        @tax_type = element.at_xpath("./TaxTp")&.text
        @authorisation = element.at_xpath("./Authstn") ? TaxAuthorisation.new(element.at_xpath("./Authstn")) : nil
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
