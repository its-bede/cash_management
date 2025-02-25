# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/account_statement.rb

# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the AccountStatement (AccountStatement9) element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/AccountStatement9
    class AccountStatement
      attr_reader :id, :statement_pagination, :electronic_sequence_number, :reporting_sequence,
                  :legal_sequence_number, :creation_date_time, :from_to_date, :copy_duplicate_indicator,
                  :reporting_source, :account, :related_account, :interest, :balances,
                  :transactions_summary, :entries, :additional_statement_information, :raw

      # Initialize a new AccountStatement instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @id = element.at_xpath('./Id')&.text
        @statement_pagination = element.at_xpath('./StmtPgntn') ? Pagination.new(element.at_xpath('./StmtPgntn')) : nil
        @electronic_sequence_number = element.at_xpath('./ElctrncSeqNb')&.text&.to_i
        @reporting_sequence = element.at_xpath('./RptgSeq') ? SequenceRange.new(element.at_xpath('./RptgSeq')) : nil
        @legal_sequence_number = element.at_xpath('./LglSeqNb')&.text&.to_i
        @creation_date_time = parse_datetime(element.at_xpath('./CreDtTm')&.text)
        @from_to_date = element.at_xpath('./FrToDt') ? DateTimePeriod.new(element.at_xpath('./FrToDt')) : nil
        @copy_duplicate_indicator = element.at_xpath('./CpyDplctInd')&.text
        @reporting_source = element.at_xpath('./RptgSrc') ? ReportingSource.new(element.at_xpath('./RptgSrc')) : nil
        @account = element.at_xpath('./Acct') ? CashAccount.new(element.at_xpath('./Acct')) : nil
        @related_account = element.at_xpath('./RltdAcct') ? CashAccount.new(element.at_xpath('./RltdAcct'), :cash_account38) : nil
        @interest = element.xpath('./Intrst').map { |interest_elem| AccountInterest.new(interest_elem) }
        @balances = element.xpath('./Bal').map { |balance_elem| CashBalance.new(balance_elem) }
        @transactions_summary = element.at_xpath('./TxsSummry') ? TotalTransactions.new(element.at_xpath('./TxsSummry')) : nil
        @entries = element.xpath('./Ntry').map { |entry_elem| ReportEntry.new(entry_elem) }
        @additional_statement_information = element.at_xpath('./AddtlStmtInf')&.text
        @raw = element.to_s
      end

      def summary
        text = <<~TXT
          Account Statement Summary
          -------------------------
          ID: #{@id}
          Electronic Sequence Number: #{@electronic_sequence_number}
          Legal Sequence Number: #{@legal_sequence_number}  
          Creation Date Time: #{@creation_date_time}
          Copy Duplicate Indicator: #{@copy_duplicate_indicator}
          Reporting Source: #{@reporting_source}
          Account: #{@account}
          Related Account: #{@related_account}
          Interest: #{@interest}
          Balances: #{@balances}
          Transactions Summary: #{@transactions_summary}
          Entries: #{@entries}
          Additional Statement Information: #{@additional_statement_information}
        TXT

        puts text
      end

      private

      # Parse a datetime string
      # @param datetime_str [String, nil] The datetime string
      # @return [DateTime, nil] The parsed datetime or nil if the input is nil
      def parse_datetime(datetime_str)
        return nil unless datetime_str

        DateTime.iso8601(datetime_str)
      rescue ArgumentError
        datetime_str
      end
    end
  end
end
