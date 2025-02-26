# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/transaction_price.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TransactionPrice4Choice element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TransactionPrice4Choice
    class TransactionPrice
      attr_reader :deal_price, :proprietary, :raw

      # Initialize a new TransactionPrice instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        # This is a choice, so only one of these will be present
        @deal_price = (Price.new(element.at_xpath("./DealPric")) if element.at_xpath("./DealPric"))
        @proprietary = element.xpath("./Prtry").map { |prtry| ProprietaryPrice.new(prtry) }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
