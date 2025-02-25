# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/message_identification.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the MessageIdentification2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/MessageIdentification2
    class MessageIdentification
      attr_reader :message_name_id, :message_id, :raw

      # Initialize a new MessageIdentification instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @message_name_id = element.at_xpath("./MsgNmId")&.text
        @message_id = element.at_xpath("./MsgId")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
