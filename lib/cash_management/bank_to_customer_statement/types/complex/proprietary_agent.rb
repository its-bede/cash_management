# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/proprietary_agent.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ProprietaryAgent4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ProprietaryAgent4
    class ProprietaryAgent
      attr_reader :type, :agent, :raw

      # Initialize a new ProprietaryAgent instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = element.at_xpath("./Tp")&.text
        @agent = if element.at_xpath("./Agt")
                   BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./Agt"))
                 end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
