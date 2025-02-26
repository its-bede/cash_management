# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/proprietary_price.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ProprietaryPrice2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ProprietaryPrice2
    class ProprietaryPrice
      attr_reader :type, :price, :raw

      # Initialize a new ProprietaryPrice instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = element.at_xpath("./Tp")&.text
        @price = parse_price(element.at_xpath("./Pric"))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the price element
      # @param element [Nokogiri::XML::Element, nil] The price element
      # @return [Hash, nil] The parsed price or nil
      def parse_price(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute("Ccy")&.value
        }
      end
    end
  end
end
