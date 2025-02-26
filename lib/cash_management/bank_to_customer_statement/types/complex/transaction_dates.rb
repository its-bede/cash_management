# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/transaction_dates.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TransactionDates3 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TransactionDates3
    class TransactionDates
      attr_reader :acceptance_date_time, :trade_activity_contractual_settlement_date,
                  :trade_date, :interbank_settlement_date, :start_date, :end_date,
                  :transaction_date_time, :proprietary, :raw

      # Initialize a new TransactionDates instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @acceptance_date_time = parse_datetime(element.at_xpath("./AccptncDtTm")&.text)
        @trade_activity_contractual_settlement_date = parse_date(element.at_xpath("./TradActvtyCtrctlSttlmDt")&.text)
        @trade_date = parse_date(element.at_xpath("./TradDt")&.text)
        @interbank_settlement_date = parse_date(element.at_xpath("./IntrBkSttlmDt")&.text)
        @start_date = parse_date(element.at_xpath("./StartDt")&.text)
        @end_date = parse_date(element.at_xpath("./EndDt")&.text)
        @transaction_date_time = parse_datetime(element.at_xpath("./TxDtTm")&.text)
        @proprietary = element.xpath("./Prtry").map { |prop| ProprietaryDate.new(prop) }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an ISO date string
      # @param date_str [String, nil] The date string
      # @return [Date, nil] The parsed date or nil
      def parse_date(date_str)
        return nil unless date_str

        Date.iso8601(date_str)
      rescue ArgumentError
        # Return the original string if parsing fails
        date_str
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
