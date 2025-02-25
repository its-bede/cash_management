# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/display_capabilities.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the DisplayCapabilities1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/DisplayCapabilities1
    class DisplayCapabilities
      attr_reader :display_type, :number_of_lines, :line_width, :raw

      # Initialize a new DisplayCapabilities instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @display_type = element.at_xpath("./DispTp")&.text
        @number_of_lines = element.at_xpath("./NbOfLines")&.text
        @line_width = element.at_xpath("./LineWidth")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
