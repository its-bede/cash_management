# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/proprietary_amount_and_currency_exchange_details.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the AmountAndCurrencyExchangeDetails4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/AmountAndCurrencyExchangeDetails4
    class ProprietaryAmountAndCurrencyExchangeDetails
      attr_reader :type, :amount, :currency_exchange, :raw

      # Initialize a new ProprietaryAmountAndCurrencyExchangeDetails instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = element.at_xpath("./Tp")&.text
        @amount = parse_amount(element.at_xpath("./Amt"))
        @currency_exchange = (CurrencyExchange.new(element.at_xpath("./CcyXchg")) if element.at_xpath("./CcyXchg"))
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
