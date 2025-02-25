# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/clearing_system_member_identification.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ClearingSystemMemberIdentification2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ClearingSystemMemberIdentification2
    class ClearingSystemMemberIdentification
      attr_reader :clearing_system_id, :member_id, :raw

      # Initialize a new ClearingSystemMemberIdentification instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @clearing_system_id = element.at_xpath('./ClrSysId') ?
                                ClearingSystemIdentification.new(element.at_xpath('./ClrSysId')) : nil
        @member_id = element.at_xpath('./MmbId')&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
