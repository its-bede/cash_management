# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the DateTimePeriod (DateTimePeriod1) element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/DateTimePeriod1
    class DateTimePeriod
      attr_reader :from_date_time, :to_date_time, :raw

      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @from_date_time = parse_datetime(element.at_xpath("./FrDtTm")&.text)
        @to_date_time = parse_datetime(element.at_xpath("./ToDtTm")&.text)
        @raw = element.to_s
      end

      private

      # Parse a datetime string
      # @param datetime_str [String, nil] The datetime string
      # @return [DateTime, nil] The parsed datetime or nil if the input is nil
      def parse_datetime(datetime_str)
        return nil unless datetime_str

        DateTime.iso8601(datetime_str)
      rescue ArgumentError
        datetime_str
      end
    end
  end
end
