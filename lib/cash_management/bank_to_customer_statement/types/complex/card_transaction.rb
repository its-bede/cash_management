# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/card_transaction.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the CardTransaction17 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CardTransaction17
    class CardTransaction
      attr_reader :card, :point_of_interaction, :transaction, :prepaid_account, :raw

      # Initialize a new CardTransaction instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @card = (PaymentCard.new(element.at_xpath("./Card")) if element.at_xpath("./Card"))
        @point_of_interaction = (PointOfInteraction.new(element.at_xpath("./POI")) if element.at_xpath("./POI"))
        @transaction = (CardTransactionChoice.new(element.at_xpath("./Tx")) if element.at_xpath("./Tx"))
        @prepaid_account = if element.at_xpath("./PrePdAcct")
                             CashAccount.new(element.at_xpath("./PrePdAcct"), :cash_account38)
                           end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
