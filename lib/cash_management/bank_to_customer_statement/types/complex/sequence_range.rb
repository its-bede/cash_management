# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/sequence_range.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the SequenceRange1Choice element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/SequenceRange1Choice
    class SequenceRange
      attr_reader :from_sequence, :to_sequence, :from_to_sequences,
                  :equal_sequences, :not_equal_sequences, :raw

      # Initialize a new SequenceRange instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        # This is a choice element, so only one of the following will be set
        @from_sequence = element.at_xpath("./FrSeq")&.text
        @to_sequence = element.at_xpath("./ToSeq")&.text
        @from_to_sequences = element.xpath("./FrToSeq").map { |seq| FromToSequence.new(seq) }
        @equal_sequences = element.xpath("./EQSeq").map(&:text)
        @not_equal_sequences = element.xpath("./NEQSeq").map(&:text)
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
