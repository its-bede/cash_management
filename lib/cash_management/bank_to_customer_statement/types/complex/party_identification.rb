# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/party_identification.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the PartyIdentification (PartyIdentification135) element
    # @see https://www.iso20022.org/standardsrepository/type/PartyIdentification135
    class PartyIdentification
      attr_reader :name, :postal_address, :identification, :country_of_residence, :contact_details, :raw

      def initialize(element)
        @name = element.at_xpath('./Nm')&.text
        @postal_address = element.at_xpath('./PstlAdr') ? PostalAddress.new(element.at_xpath('./PstlAdr')) : nil
        @identification = element.at_xpath('./Id') ? PartyChoice.new(element.at_xpath('./Id')) : nil
        @country_of_residence = element.at_xpath('./CtryOfRes')&.text
        @contact_details = element.at_xpath('./CtctDtls') ? Contact.new(element.at_xpath('./CtctDtls')) : nil
        @raw = element.to_s
      end
    end
  end
end