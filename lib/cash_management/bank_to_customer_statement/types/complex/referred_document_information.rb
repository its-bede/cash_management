# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/referred_document_information.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ReferredDocumentInformation7 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ReferredDocumentInformation7
    class ReferredDocumentInformation
      attr_reader :type, :number, :related_date, :line_details, :raw

      # Initialize a new ReferredDocumentInformation instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = (ReferredDocumentType.new(element.at_xpath("./Tp")) if element.at_xpath("./Tp"))
        @number = element.at_xpath("./Nb")&.text
        @related_date = parse_date(element.at_xpath("./RltdDt")&.text)
        @line_details = element.xpath("./LineDtls").map { |line| DocumentLineInformation.new(line) }
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
