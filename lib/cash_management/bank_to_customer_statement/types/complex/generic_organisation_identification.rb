# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the GenericOrganisationIdentification1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/GenericOrganisationIdentification1
    class GenericOrganisationIdentification
      attr_reader :id, :scheme_name, :issuer, :raw

      # Initialize a new GenericOrganisationIdentification instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @id = element.at_xpath("./Id")&.text
        @scheme_name = parse_scheme_name(element.at_xpath("./SchmeNm"))
        @issuer = element.at_xpath("./Issr")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the scheme name element
      # @param element [Nokogiri::XML::Element, nil] The scheme name element
      # @return [Hash, nil] The parsed scheme name or nil
      def parse_scheme_name(element)
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
