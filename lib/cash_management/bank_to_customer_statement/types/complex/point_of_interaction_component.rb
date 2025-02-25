# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/point_of_interaction_component.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the PointOfInteractionComponent1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/PointOfInteractionComponent1
    class PointOfInteractionComponent
      attr_reader :poi_component_type, :manufacturer_id, :model, :version_number,
                  :serial_number, :approval_number, :raw

      # Initialize a new PointOfInteractionComponent instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @poi_component_type = element.at_xpath("./POICmpntTp")&.text
        @manufacturer_id = element.at_xpath("./ManfctrId")&.text
        @model = element.at_xpath("./Mdl")&.text
        @version_number = element.at_xpath("./VrsnNb")&.text
        @serial_number = element.at_xpath("./SrlNb")&.text
        @approval_number = element.xpath("./ApprvlNb").map(&:text)
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
