# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the CreditLine3 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CreditLine3
    class CreditLine
      attr_reader :included, :amount, :type, :raw

      # Initialize a new CreditLine instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @included = element.at_xpath("./Incl")&.text&.downcase == "true"
        @amount = parse_amount(element.at_xpath("./Amt"))
        @type = parse_credit_line_type(element.at_xpath("./Tp"))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an amount element
      # @param element [Nokogiri::XML::Element, nil] The amount element
      # @return [Hash, nil] The parsed amount or nil
      def parse_amount(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute("Ccy")&.value
        }
      end

      # Parse the credit line type element
      # @param element [Nokogiri::XML::Element, nil] The credit line type element
      # @return [Hash, nil] The parsed credit line type or nil
      def parse_credit_line_type(element)
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
