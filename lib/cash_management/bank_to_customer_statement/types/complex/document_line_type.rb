# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/document_line_type.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the DocumentLineType1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/DocumentLineType1
    class DocumentLineType
      attr_reader :code_or_proprietary, :issuer, :raw

      # Initialize a new DocumentLineType instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @code_or_proprietary = parse_code_or_proprietary(element.at_xpath("./CdOrPrtry"))
        @issuer = element.at_xpath("./Issr")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the code or proprietary element
      # @param element [Nokogiri::XML::Element, nil] The code or proprietary element
      # @return [Hash, nil] The parsed code or proprietary or nil
      def parse_code_or_proprietary(element)
        return nil unless element

        if element.at_xpath("./Cd")
          { code: element.at_xpath("./Cd")&.text }
        elsif element.at_xpath("./Prtry")
          { proprietary: element.at_xpath("./Prtry")&.text }
        end
      end
    end
  end
end
