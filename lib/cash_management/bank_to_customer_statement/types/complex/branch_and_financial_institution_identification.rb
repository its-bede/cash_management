# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/branch_and_financial_institution_identification.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the BranchAndFinancialInstitutionIdentification6 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/BranchAndFinancialInstitutionIdentification6
    class BranchAndFinancialInstitutionIdentification
      attr_reader :financial_institution_id, :branch_id, :raw

      # Initialize a new BranchAndFinancialInstitutionIdentification instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @financial_institution_id = if element.at_xpath('./FinInstnId')
                                      FinancialInstitutionIdentification.new(element.at_xpath('./FinInstnId'))
                                    else
                                      nil
                                    end
        @branch_id = if element.at_xpath('./BrnchId')
                       BranchData.new(element.at_xpath('./BrnchId'))
                     else
                       nil
                     end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
