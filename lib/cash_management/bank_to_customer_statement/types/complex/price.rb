# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/price.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the Price7 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/Price7
    class Price
      attr_reader :type, :value, :raw

      # Initialize a new Price instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = parse_type(element.at_xpath("./Tp"))
        @value = parse_value(element.at_xpath("./Val"))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the type element
      # @param element [Nokogiri::XML::Element, nil] The type element
      # @return [Hash, nil] The parsed type or nil
      def parse_type(element)
        return nil unless element

        if element.at_xpath("./Yldd")
          { yielded: element.at_xpath("./Yldd")&.text&.downcase == "true" }
        elsif element.at_xpath("./ValTp")
          { value_type: element.at_xpath("./ValTp")&.text }
        end
      end

      # Parse the value element
      # @param element [Nokogiri::XML::Element, nil] The value element
      # @return [Hash, nil] The parsed value or nil
      def parse_value(element)
        return nil unless element

        if element.at_xpath("./Rate")
          { rate: element.at_xpath("./Rate")&.text&.to_f }
        elsif element.at_xpath("./Amt")
          {
            amount: element.at_xpath("./Amt")&.text&.to_f,
            currency: element.at_xpath("./Amt")&.attribute("Ccy")&.value
          }
        end
      end
    end
  end
end
