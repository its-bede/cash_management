# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/point_of_interaction_capabilities.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the PointOfInteractionCapabilities1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/PointOfInteractionCapabilities1
    class PointOfInteractionCapabilities
      attr_reader :card_reading_capabilities, :cardholder_verification_capabilities,
                  :online_capabilities, :display_capabilities, :print_line_width, :raw

      # Initialize a new PointOfInteractionCapabilities instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @card_reading_capabilities = element.xpath("./CardRdngCpblties").map(&:text)
        @cardholder_verification_capabilities = element.xpath("./CrdhldrVrfctnCpblties").map(&:text)
        @online_capabilities = element.at_xpath("./OnLineCpblties")&.text
        @display_capabilities = element.xpath("./DispCpblties").map do |disp|
          DisplayCapabilities.new(disp)
        end
        @print_line_width = element.at_xpath("./PrtLineWidth")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
