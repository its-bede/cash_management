# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the Party38Choice element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/Party38Choice
    class PartyChoice
      attr_reader :organisation_identification, :private_identification, :raw

      # Initialize a new PartyChoice instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @organisation_identification = if element.at_xpath("./OrgId")
                                         OrganisationIdentification.new(element.at_xpath("./OrgId"))
                                       end
        @private_identification = if element.at_xpath("./PrvtId")
                                    PersonIdentification.new(element.at_xpath("./PrvtId"))
                                  end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end 