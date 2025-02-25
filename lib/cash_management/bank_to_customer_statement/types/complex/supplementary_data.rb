# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the SupplementaryData1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/SupplementaryData1
    class SupplementaryData
      attr_reader :plc_and_nm, :envlp, :raw

      # Initialize a new SupplementaryData instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @plc_and_nm = element.at_xpath('PlcAndNm')&.content
        @envlp = parse_envelope(element.at_xpath('Envlp'))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the envelope node which can contain any XML content
      # @param element [Nokogiri::XML::Element, nil] The envelope XML node
      # @return [Hash, nil] The parsed envelope data
      def parse_envelope(element)
        return nil unless element

        # Convert the envelope's contents to a hash
        element.elements.each_with_object({}) do |el, hash|
          hash[el.name.to_sym] = el.content
        end
      end
    end
  end
end