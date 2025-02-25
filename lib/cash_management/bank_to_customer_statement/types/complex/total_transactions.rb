# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/total_transactions.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TotalTransactions6 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TotalTransactions6
    class TotalTransactions
      attr_reader :total_entries, :total_credit_entries, :total_debit_entries,
                  :totals_per_bank_transaction_code, :raw

      # Initialize a new TotalTransactions instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @total_entries = element.at_xpath('./TtlNtries') ?
                           NumberAndSumOfTransactions4.new(element.at_xpath('./TtlNtries')) : nil
        @total_credit_entries = element.at_xpath('./TtlCdtNtries') ?
                                  NumberAndSumOfTransactions1.new(element.at_xpath('./TtlCdtNtries')) : nil
        @total_debit_entries = element.at_xpath('./TtlDbtNtries') ?
                                 NumberAndSumOfTransactions1.new(element.at_xpath('./TtlDbtNtries')) : nil
        @totals_per_bank_transaction_code = element.xpath('./TtlNtriesPerBkTxCd').map { |total|
          TotalsPerBankTransactionCode.new(total)
        }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
