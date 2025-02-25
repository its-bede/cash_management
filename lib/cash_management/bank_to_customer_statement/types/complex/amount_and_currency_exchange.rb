# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/amount_and_currency_exchange.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the AmountAndCurrencyExchange3 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/AmountAndCurrencyExchange3
    class AmountAndCurrencyExchange
      attr_reader :instructed_amount, :transaction_amount, :counter_value_amount,
                  :announced_posting_amount, :proprietary_amounts, :raw

      # Initialize a new AmountAndCurrencyExchange instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @instructed_amount = element.at_xpath('./InstdAmt') ?
                               AmountAndCurrencyExchangeDetails.new(element.at_xpath('./InstdAmt')) : nil
        @transaction_amount = element.at_xpath('./TxAmt') ?
                                AmountAndCurrencyExchangeDetails.new(element.at_xpath('./TxAmt')) : nil
        @counter_value_amount = element.at_xpath('./CntrValAmt') ?
                                  AmountAndCurrencyExchangeDetails.new(element.at_xpath('./CntrValAmt')) : nil
        @announced_posting_amount = element.at_xpath('./AnncdPstngAmt') ?
                                      AmountAndCurrencyExchangeDetails.new(element.at_xpath('./AnncdPstngAmt')) : nil
        @proprietary_amounts = element.xpath('./PrtryAmt').map { |amt|
          ProprietaryAmountAndCurrencyExchangeDetails.new(amt)
        }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
