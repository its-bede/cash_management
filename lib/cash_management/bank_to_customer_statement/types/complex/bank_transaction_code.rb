# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the BankTransactionCodeStructure4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/BankTransactionCodeStructure4
    class BankTransactionCode
      attr_reader :domain, :proprietary, :raw

      # Initialize a new BankTransactionCode instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @domain = parse_domain(element.at_xpath("./Domn"))
        @proprietary = parse_proprietary(element.at_xpath("./Prtry"))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the domain element
      # @param element [Nokogiri::XML::Element, nil] The domain element
      # @return [Hash, nil] The parsed domain or nil
      def parse_domain(element)
        return nil unless element

        {
          code: element.at_xpath("./Cd")&.text,
          family: parse_family(element.at_xpath("./Fmly"))
        }.compact
      end

      # Parse the family element
      # @param element [Nokogiri::XML::Element, nil] The family element
      # @return [Hash, nil] The parsed family or nil
      def parse_family(element)
        return nil unless element

        {
          code: element.at_xpath("./Cd")&.text,
          sub_family_code: element.at_xpath("./SubFmlyCd")&.text
        }.compact
      end

      # Parse the proprietary element
      # @param element [Nokogiri::XML::Element, nil] The proprietary element
      # @return [Hash, nil] The parsed proprietary or nil
      def parse_proprietary(element)
        return nil unless element

        {
          code: element.at_xpath("./Cd")&.text,
          issuer: element.at_xpath("./Issr")&.text
        }.compact
      end
    end
  end
end
