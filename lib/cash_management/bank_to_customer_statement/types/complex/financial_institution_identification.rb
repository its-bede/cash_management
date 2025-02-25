# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/financial_institution_identification.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the FinancialInstitutionIdentification18 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/FinancialInstitutionIdentification18
    class FinancialInstitutionIdentification
      attr_reader :bicfi, :clearing_system_member_id, :lei, :name, :postal_address, :other, :raw

      # Initialize a new FinancialInstitutionIdentification instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @bicfi = element.at_xpath('./BICFI')&.text
        @clearing_system_member_id = element.at_xpath('./ClrSysMmbId') ?
                                       ClearingSystemMemberIdentification.new(element.at_xpath('./ClrSysMmbId')) : nil
        @lei = element.at_xpath('./LEI')&.text
        @name = element.at_xpath('./Nm')&.text
        @postal_address = element.at_xpath('./PstlAdr') ?
                            PostalAddress.new(element.at_xpath('./PstlAdr')) : nil
        @other = element.at_xpath('./Othr') ?
                   GenericFinancialIdentification.new(element.at_xpath('./Othr')) : nil
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
