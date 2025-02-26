# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/creditor_reference_information.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the CreditorReferenceInformation2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CreditorReferenceInformation2
    class CreditorReferenceInformation
      attr_reader :type, :reference, :raw

      # Initialize a new CreditorReferenceInformation instance from an XML element
      #
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = parse_reference_type(element.at_xpath("./Tp"))
        @reference = element.at_xpath("./Ref")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the creditor reference type element
      #
      # @param element [Nokogiri::XML::Element, nil] The reference type element
      # @return [Hash, nil] The parsed reference type
      def parse_reference_type(element)
        return nil unless element

        type = element.at_xpath("./CdOrPrtry")
        return nil unless type

        if type.at_xpath("./Cd")
          {
            code_or_proprietary: {
              code: type.at_xpath("./Cd")&.text
            }
          }
        elsif type.at_xpath("./Prtry")
          {
            code_or_proprietary: {
              proprietary: type.at_xpath("./Prtry")&.text
            }
          }
        end
      end
    end
  end
end
