# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/card_entry.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the CardEntry4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CardEntry4
    class CardEntry
      attr_reader :card, :point_of_interaction, :aggregated_entry, :prepaid_account, :raw

      # Initialize a new CardEntry instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @card = element.at_xpath('./Card') ?
                  PaymentCard.new(element.at_xpath('./Card')) : nil
        @point_of_interaction = element.at_xpath('./POI') ?
                                  PointOfInteraction.new(element.at_xpath('./POI')) : nil
        @aggregated_entry = element.at_xpath('./AggtdNtry') ?
                              CardAggregated.new(element.at_xpath('./AggtdNtry')) : nil
        @prepaid_account = element.at_xpath('./PrePdAcct') ?
                             CashAccount.new(element.at_xpath('./PrePdAcct'), :cash_account38) : nil
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end