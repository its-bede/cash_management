# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the OrganisationIdentification8 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/OrganisationIdentification8
    class OrganisationIdentification
      attr_reader :any_bic, :lei, :other, :raw

      # Initialize a new OrganisationIdentification instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @any_bic = element.at_xpath("./AnyBIC")&.text
        @lei = element.at_xpath("./LEI")&.text
        @other = element.xpath("./Othr").map { |othr| GenericOrganisationIdentification.new(othr) }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end 