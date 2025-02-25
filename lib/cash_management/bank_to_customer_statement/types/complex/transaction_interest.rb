# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/transaction_interest.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TransactionInterest4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TransactionInterest4
    class TransactionInterest
      attr_reader :total_interest_and_tax_amount, :records, :raw

      # Initialize a new TransactionInterest instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @total_interest_and_tax_amount = parse_amount(element.at_xpath("./TtlIntrstAndTaxAmt"))
        @records = element.xpath("./Rcrd").map { |rcrd| InterestRecord.new(rcrd) }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an amount element
      # @param element [Nokogiri::XML::Element, nil] The amount element
      # @return [Hash, nil] The parsed amount or nil
      def parse_amount(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute("Ccy")&.value
        }
      end
    end
  end
end
