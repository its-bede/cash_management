# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the Contact4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/Contact4
    class Contact
      attr_reader :name_prefix, :name, :phone_number, :mobile_number, :fax_number,
                  :email_address, :other, :preferred_method, :raw

      # Initialize a new Contact instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @name_prefix = element.at_xpath("./NmPrfx")&.text
        @name = element.at_xpath("./Nm")&.text
        @phone_number = element.at_xpath("./PhneNb")&.text
        @mobile_number = element.at_xpath("./MobNb")&.text
        @fax_number = element.at_xpath("./FaxNb")&.text
        @email_address = element.at_xpath("./EmailAdr")&.text
        @other = element.at_xpath("./Othr")&.text
        @preferred_method = element.at_xpath("./PrefrdMtd")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
