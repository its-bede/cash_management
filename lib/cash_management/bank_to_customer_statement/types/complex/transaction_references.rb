# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/transaction_references.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TransactionReferences6 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TransactionReferences6
    class TransactionReferences
      attr_reader :message_id, :account_servicer_reference, :payment_information_id,
                  :instruction_id, :end_to_end_id, :uetr, :transaction_id,
                  :mandate_id, :cheque_number, :clearing_system_reference,
                  :account_owner_transaction_id, :account_servicer_transaction_id,
                  :market_infrastructure_transaction_id, :processing_id,
                  :proprietary, :raw

      # Initialize a new TransactionReferences instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @message_id = element.at_xpath("./MsgId")&.text
        @account_servicer_reference = element.at_xpath("./AcctSvcrRef")&.text
        @payment_information_id = element.at_xpath("./PmtInfId")&.text
        @instruction_id = element.at_xpath("./InstrId")&.text
        @end_to_end_id = element.at_xpath("./EndToEndId")&.text
        @uetr = element.at_xpath("./UETR")&.text
        @transaction_id = element.at_xpath("./TxId")&.text
        @mandate_id = element.at_xpath("./MndtId")&.text
        @cheque_number = element.at_xpath("./ChqNb")&.text
        @clearing_system_reference = element.at_xpath("./ClrSysRef")&.text
        @account_owner_transaction_id = element.at_xpath("./AcctOwnrTxId")&.text
        @account_servicer_transaction_id = element.at_xpath("./AcctSvcrTxId")&.text
        @market_infrastructure_transaction_id = element.at_xpath("./MktInfrstrctrTxId")&.text
        @processing_id = element.at_xpath("./PrcgId")&.text
        @proprietary = element.xpath("./Prtry").map { |prop| ProprietaryReference.new(prop) }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
