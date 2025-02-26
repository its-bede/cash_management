# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/payment_return_reason.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the PaymentReturnReason5 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/PaymentReturnReason5
    class PaymentReturnReason
      attr_reader :original_bank_transaction_code, :originator, :reason, :additional_information, :raw

      # Initialize a new PaymentReturnReason instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @original_bank_transaction_code = if element.at_xpath("./OrgnlBkTxCd")
                                            BankTransactionCode.new(element.at_xpath("./OrgnlBkTxCd"))
                                          end
        @originator = element.at_xpath("./Orgtr") ? PartyIdentification.new(element.at_xpath("./Orgtr")) : nil
        @reason = element.at_xpath("./Rsn") ? ReturnReasonChoice.new(element.at_xpath("./Rsn")) : nil
        @additional_information = element.xpath("./AddtlInf").map(&:text)
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
