# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/payment_card.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the PaymentCard4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/PaymentCard4
    class PaymentCard
      attr_reader :plain_card_data, :card_country_code, :card_brand, :additional_card_data, :raw

      # Initialize a new PaymentCard instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @plain_card_data = if element.at_xpath("./PlainCardData")
                             PlainCardData.new(element.at_xpath("./PlainCardData"))
                           end
        @card_country_code = element.at_xpath("./CardCtryCd")&.text
        @card_brand = (parse_generic_identification(element.at_xpath("./CardBrnd")) if element.at_xpath("./CardBrnd"))
        @additional_card_data = element.at_xpath("./AddtlCardData")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse a generic identification element
      # @param element [Nokogiri::XML::Element, nil] The generic identification element
      # @return [Hash, nil] The parsed generic identification or nil
      def parse_generic_identification(element)
        return nil unless element

        {
          id: element.at_xpath("./Id")&.text,
          scheme_name: element.at_xpath("./SchmeNm")&.text,
          issuer: element.at_xpath("./Issr")&.text
        }
      end
    end
  end
end
