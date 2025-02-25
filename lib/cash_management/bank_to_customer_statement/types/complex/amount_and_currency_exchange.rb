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
        @instructed_amount = if element.at_xpath("./InstdAmt")
                               AmountAndCurrencyExchangeDetails.new(element.at_xpath("./InstdAmt"))
                             end
        @transaction_amount = if element.at_xpath("./TxAmt")
                                AmountAndCurrencyExchangeDetails.new(element.at_xpath("./TxAmt"))
                              end
        @counter_value_amount = if element.at_xpath("./CntrValAmt")
                                  AmountAndCurrencyExchangeDetails.new(element.at_xpath("./CntrValAmt"))
                                end
        @announced_posting_amount = if element.at_xpath("./AnncdPstngAmt")
                                      AmountAndCurrencyExchangeDetails.new(element.at_xpath("./AnncdPstngAmt"))
                                    end
        @proprietary_amounts = element.xpath("./PrtryAmt").map do |amt|
          ProprietaryAmountAndCurrencyExchangeDetails.new(amt)
        end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
