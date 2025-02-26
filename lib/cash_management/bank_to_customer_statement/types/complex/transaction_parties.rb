# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/transaction_parties.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TransactionParties6 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TransactionParties6
    class TransactionParties
      attr_reader :initiating_party, :debtor, :debtor_account, :ultimate_debtor,
                  :creditor, :creditor_account, :ultimate_creditor, :trading_party,
                  :proprietary, :raw

      # Initialize a new TransactionParties instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @initiating_party = (Party40Choice.new(element.at_xpath("./InitgPty")) if element.at_xpath("./InitgPty"))
        @debtor = (Party40Choice.new(element.at_xpath("./Dbtr")) if element.at_xpath("./Dbtr"))
        @debtor_account = if element.at_xpath("./DbtrAcct")
                            CashAccount.new(element.at_xpath("./DbtrAcct"), :cash_account38)
                          end
        @ultimate_debtor = (Party40Choice.new(element.at_xpath("./UltmtDbtr")) if element.at_xpath("./UltmtDbtr"))
        @creditor = (Party40Choice.new(element.at_xpath("./Cdtr")) if element.at_xpath("./Cdtr"))
        @creditor_account = if element.at_xpath("./CdtrAcct")
                              CashAccount.new(element.at_xpath("./CdtrAcct"), :cash_account38)
                            end
        @ultimate_creditor = (Party40Choice.new(element.at_xpath("./UltmtCdtr")) if element.at_xpath("./UltmtCdtr"))
        @trading_party = (Party40Choice.new(element.at_xpath("./TradgPty")) if element.at_xpath("./TradgPty"))
        @proprietary = element.xpath("./Prtry").map { |prtry| ProprietaryParty.new(prtry) }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
