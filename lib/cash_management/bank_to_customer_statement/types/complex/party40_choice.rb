# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/party40_choice.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the Party40Choice element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/Party40Choice
    class Party40Choice
      attr_reader :party, :agent, :raw

      # Initialize a new Party40Choice instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @party = (PartyIdentification.new(element.at_xpath("./Pty")) if element.at_xpath("./Pty"))
        @agent = if element.at_xpath("./Agt")
                   BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./Agt"))
                 end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
