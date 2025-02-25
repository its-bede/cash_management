# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the PersonIdentification13 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/PersonIdentification13
    class PersonIdentification
      attr_reader :date_and_place_of_birth, :other, :raw

      # Initialize a new PersonIdentification instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @date_and_place_of_birth = if element.at_xpath("./DtAndPlcOfBirth")
                                     DateAndPlaceOfBirth.new(element.at_xpath("./DtAndPlcOfBirth"))
                                   end
        @other = element.xpath("./Othr").map { |othr| GenericPersonIdentification.new(othr) }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end 