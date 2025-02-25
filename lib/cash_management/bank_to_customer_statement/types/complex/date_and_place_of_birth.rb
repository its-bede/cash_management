# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the DateAndPlaceOfBirth1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/DateAndPlaceOfBirth1
    class DateAndPlaceOfBirth
      attr_reader :birth_date, :province_of_birth, :city_of_birth, :country_of_birth, :raw

      # Initialize a new DateAndPlaceOfBirth instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @birth_date = parse_date(element.at_xpath("./BirthDt")&.text)
        @province_of_birth = element.at_xpath("./PrvcOfBirth")&.text
        @city_of_birth = element.at_xpath("./CityOfBirth")&.text
        @country_of_birth = element.at_xpath("./CtryOfBirth")&.text
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