# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/batch_information.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the BatchInformation2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/BatchInformation2
    class BatchInformation
      attr_reader :message_id, :payment_information_id, :number_of_transactions,
                  :total_amount, :credit_debit_indicator, :raw

      # Initialize a new BatchInformation instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @message_id = element.at_xpath("./MsgId")&.text
        @payment_information_id = element.at_xpath("./PmtInfId")&.text
        @number_of_transactions = element.at_xpath("./NbOfTxs")&.text
        @total_amount = parse_amount(element.at_xpath("./TtlAmt"))
        @credit_debit_indicator = element.at_xpath("./CdtDbtInd")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an amount element
      # @param element [Nokogiri::XML::Element, nil] The amount element
      # @return [Hash, nil] The parsed amount or nil
      def parse_amount(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute("Ccy")&.value
        }
      end
    end
  end
end
