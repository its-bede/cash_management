# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/from_to_sequence.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the SequenceRange1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/SequenceRange1
    class FromToSequence
      attr_reader :from_sequence, :to_sequence, :raw

      # Initialize a new FromToSequence instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @from_sequence = element.at_xpath("./FrSeq")&.text
        @to_sequence = element.at_xpath("./ToSeq")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
