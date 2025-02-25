# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/track_data.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TrackData1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TrackData1
    class TrackData
      attr_reader :track_number, :track_value, :raw

      # Initialize a new TrackData instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @track_number = element.at_xpath("./TrckNb")&.text
        @track_value = element.at_xpath("./TrckVal")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
