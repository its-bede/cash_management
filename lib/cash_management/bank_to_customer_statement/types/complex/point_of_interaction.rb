# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/point_of_interaction.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the PointOfInteraction1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/PointOfInteraction1
    class PointOfInteraction
      attr_reader :id, :system_name, :group_id, :capabilities, :components, :raw

      # Initialize a new PointOfInteraction instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @id = parse_generic_identification(element.at_xpath("./Id"))
        @system_name = element.at_xpath("./SysNm")&.text
        @group_id = element.at_xpath("./GrpId")&.text
        @capabilities = if element.at_xpath("./Cpblties")
                          PointOfInteractionCapabilities.new(element.at_xpath("./Cpblties"))
                        end
        @components = element.xpath("./Cmpnt").map { |cmpnt| PointOfInteractionComponent.new(cmpnt) }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse a generic identification element
      # @param element [Nokogiri::XML::Element, nil] The generic identification element
      # @return [Hash, nil] The parsed generic identification or nil
      def parse_generic_identification(element)
        return nil unless element

        {
          id: element.at_xpath("./Id")&.text,
          type: element.at_xpath("./Tp")&.text,
          issuer: element.at_xpath("./Issr")&.text,
          short_name: element.at_xpath("./ShrtNm")&.text
        }
      end
    end
  end
end
