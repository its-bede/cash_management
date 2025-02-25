# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/entry_details.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the EntryDetails9 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/EntryDetails9
    class EntryDetails
      attr_reader :batch, :transaction_details, :raw

      # Initialize a new EntryDetails instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @batch = (BatchInformation.new(element.at_xpath("./Btch")) if element.at_xpath("./Btch"))
        @transaction_details = element.xpath("./TxDtls").map do |tx|
          EntryTransaction.new(tx)
        end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
