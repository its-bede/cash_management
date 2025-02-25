# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/rate.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the Rate4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/Rate4
    class Rate
      attr_reader :type, :validity_range, :raw

      # Initialize a new Rate instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = parse_type(element.at_xpath("./Tp"))
        @validity_range = if element.at_xpath("./VldtyRg")
                            ActiveOrHistoricCurrencyAndAmountRange.new(element.at_xpath("./VldtyRg"))
                          end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the type element
      # @param element [Nokogiri::XML::Element, nil] The type element
      # @return [Hash, nil] The parsed type or nil
      def parse_type(element)
        return nil unless element

        if element.at_xpath("./Pctg")
          { percentage: element.at_xpath("./Pctg")&.text&.to_f }
        elsif element.at_xpath("./Othr")
          { other: element.at_xpath("./Othr")&.text }
        end
      end
    end
  end
end
