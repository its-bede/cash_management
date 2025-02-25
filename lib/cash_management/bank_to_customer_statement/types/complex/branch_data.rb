# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/branch_data.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the BranchData3 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/BranchData3
    class BranchData
      attr_reader :id, :lei, :name, :postal_address, :raw

      # Initialize a new BranchData instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @id = element.at_xpath('./Id')&.text
        @lei = element.at_xpath('./LEI')&.text
        @name = element.at_xpath('./Nm')&.text
        @postal_address = element.at_xpath('./PstlAdr') ?
                            PostalAddress.new(element.at_xpath('./PstlAdr')) : nil
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
