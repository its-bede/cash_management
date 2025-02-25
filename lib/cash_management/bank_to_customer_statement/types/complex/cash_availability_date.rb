# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/cash_availability_date.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the CashAvailabilityDate1Choice element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CashAvailabilityDate1Choice
    class CashAvailabilityDate
      attr_reader :number_of_days, :actual_date, :raw

      # Initialize a new CashAvailabilityDate instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        # This is a choice element, so only one of the following will be set
        @number_of_days = element.at_xpath('./NbOfDays')&.text
        @actual_date = parse_date(element.at_xpath('./ActlDt')&.text)
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
    end
  end
end
