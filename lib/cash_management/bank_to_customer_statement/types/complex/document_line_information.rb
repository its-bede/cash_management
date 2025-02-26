# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/document_line_information.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the DocumentLineInformation1 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/DocumentLineInformation1
    class DocumentLineInformation
      attr_reader :identifications, :description, :amount, :raw

      # Initialize a new DocumentLineInformation instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @identifications = element.xpath("./Id").map do |id_elem|
          DocumentLineIdentification.new(id_elem)
        end
        @description = element.at_xpath("./Desc")&.text
        @amount = element.at_xpath("./Amt") ? RemittanceAmount.new(element.at_xpath("./Amt")) : nil
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
