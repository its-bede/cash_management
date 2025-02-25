# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/currency_exchange.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the CurrencyExchange5 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CurrencyExchange5
    class CurrencyExchange
      attr_reader :source_currency, :target_currency, :unit_currency,
                  :exchange_rate, :contract_id, :quotation_date, :raw

      # Initialize a new CurrencyExchange instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @source_currency = element.at_xpath('./SrcCcy')&.text
        @target_currency = element.at_xpath('./TrgtCcy')&.text
        @unit_currency = element.at_xpath('./UnitCcy')&.text
        @exchange_rate = parse_rate(element.at_xpath('./XchgRate')&.text)
        @contract_id = element.at_xpath('./CtrctId')&.text
        @quotation_date = parse_datetime(element.at_xpath('./QtnDt')&.text)
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse a rate string
      # @param rate_str [String, nil] The rate string
      # @return [Float, nil] The parsed rate or nil
      def parse_rate(rate_str)
        return nil unless rate_str

        rate_str.to_f
      end

      # Parse an ISO datetime string
      # @param datetime_str [String, nil] The datetime string
      # @return [DateTime, nil] The parsed datetime or nil
      def parse_datetime(datetime_str)
        return nil unless datetime_str

        DateTime.iso8601(datetime_str)
      rescue ArgumentError
        # Return the original string if parsing fails
        datetime_str
      end
    end
  end
end
