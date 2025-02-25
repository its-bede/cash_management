# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/card_sequence_number_range.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the CardSequenceNumberRange1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CardSequenceNumberRange1
    class CardSequenceNumberRange
      attr_reader :first_transaction, :last_transaction, :raw

      # Initialize a new CardSequenceNumberRange instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @first_transaction = element.at_xpath("./FrstTx")&.text
        @last_transaction = element.at_xpath("./LastTx")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
