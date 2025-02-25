# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/security_identification.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the SecurityIdentification19 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/SecurityIdentification19
    class SecurityIdentification
      attr_reader :isin, :other_identification, :description, :raw

      # Initialize a new SecurityIdentification instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @isin = element.at_xpath("./ISIN")&.text
        @other_identification = parse_other_identification(element.at_xpath("./OthrId"))
        @description = element.at_xpath("./Desc")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the other identification element
      # @param element [Nokogiri::XML::Element, nil] The other identification element
      # @return [Hash, nil] The parsed other identification or nil
      def parse_other_identification(element)
        return nil unless element

        {
          id: element.at_xpath("./Id")&.text,
          type: parse_identification_type(element.at_xpath("./Tp")),
          issuer: element.at_xpath("./Issr")&.text
        }.compact
      end

      # Parse the identification type element
      # @param element [Nokogiri::XML::Element, nil] The identification type element
      # @return [Hash, nil] The parsed identification type or nil
      def parse_identification_type(element)
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
