# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/plain_card_data.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the PlainCardData1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/PlainCardData1
    class PlainCardData
      attr_reader :pan, :card_sequence_number, :effective_date, :expiry_date,
                  :service_code, :track_data, :card_security_code, :raw

      # Initialize a new PlainCardData instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @pan = element.at_xpath("./PAN")&.text
        @card_sequence_number = element.at_xpath("./CardSeqNb")&.text
        @effective_date = parse_year_month(element.at_xpath("./FctvDt")&.text)
        @expiry_date = parse_year_month(element.at_xpath("./XpryDt")&.text)
        @service_code = element.at_xpath("./SvcCd")&.text
        @track_data = element.xpath("./TrckData").map { |track| TrackData.new(track) }
        @card_security_code = if element.at_xpath("./CardSctyCd")
                                CardSecurityInformation.new(element.at_xpath("./CardSctyCd"))
                              end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an ISO year-month string
      # @param year_month_str [String, nil] The year-month string (YYYY-MM)
      # @return [Hash, nil] The parsed year and month or nil
      def parse_year_month(year_month_str)
        return nil unless year_month_str

        # Try to parse as YYYY-MM
        if /\A\d{4}-\d{2}\z/.match?(year_month_str)
          year, month = year_month_str.split("-").map(&:to_i)
          { year: year, month: month }
        else
          # Return as is if not in expected format
          year_month_str
        end
      end
    end
  end
end
