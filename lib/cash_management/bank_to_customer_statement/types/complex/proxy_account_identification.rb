# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the ProxyAccountIdentification1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ProxyAccountIdentification1
    class ProxyAccountIdentification
      attr_reader :type, :id, :raw

      # Initialize a new ProxyAccountIdentification instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = parse_proxy_type(element.at_xpath("./Tp"))
        @id = element.at_xpath("./Id")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the proxy type element
      # @param element [Nokogiri::XML::Element, nil] The proxy type element
      # @return [Hash, nil] The parsed proxy type or nil
      def parse_proxy_type(element)
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
