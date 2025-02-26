# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/proprietary_date.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ProprietaryDate3 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ProprietaryDate3
    class ProprietaryDate
      attr_reader :type, :date, :raw

      # Initialize a new ProprietaryDate instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = element.at_xpath("./Tp")&.text
        @date = parse_date_and_date_time_choice(element.at_xpath("./Dt"))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse a DateAndDateTime2Choice element
      # @param element [Nokogiri::XML::Element, nil] The element to parse
      # @return [Hash, nil] The parsed date information or nil
      def parse_date_and_date_time_choice(element)
        return nil unless element

        if element.at_xpath("./Dt")
          { date: parse_date(element.at_xpath("./Dt")&.text) }
        elsif element.at_xpath("./DtTm")
          { date_time: parse_datetime(element.at_xpath("./DtTm")&.text) }
        end
      end

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
