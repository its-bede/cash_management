# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/totals_per_bank_transaction_code.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TotalsPerBankTransactionCode5 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TotalsPerBankTransactionCode5
    class TotalsPerBankTransactionCode
      attr_reader :number_of_entries, :sum, :total_net_entry, :credit_entries,
                  :debit_entries, :forecast_indicator, :bank_transaction_code,
                  :availability, :date, :raw

      # Initialize a new TotalsPerBankTransactionCode instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @number_of_entries = element.at_xpath('./NbOfNtries')&.text
        @sum = parse_decimal(element.at_xpath('./Sum')&.text)
        @total_net_entry = parse_amount_and_direction(element.at_xpath('./TtlNetNtry'))
        @credit_entries = element.at_xpath('./CdtNtries') ?
                            NumberAndSumOfTransactions1.new(element.at_xpath('./CdtNtries')) : nil
        @debit_entries = element.at_xpath('./DbtNtries') ?
                           NumberAndSumOfTransactions1.new(element.at_xpath('./DbtNtries')) : nil
        @forecast_indicator = parse_boolean(element.at_xpath('./FcstInd')&.text)
        @bank_transaction_code = element.at_xpath('./BkTxCd') ?
                                   BankTransactionCode.new(element.at_xpath('./BkTxCd')) : nil
        @availability = element.xpath('./Avlbty').map { |avl|
          CashAvailability.new(avl)
        }
        @date = parse_date(element.at_xpath('./Dt'))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse a decimal value
      # @param decimal_str [String, nil] The decimal string
      # @return [Float, nil] The parsed decimal or nil
      def parse_decimal(decimal_str)
        return nil unless decimal_str

        decimal_str.to_f
      end

      # Parse an amount and direction element
      # @param element [Nokogiri::XML::Element, nil] The element to parse
      # @return [Hash, nil] The parsed amount and direction or nil
      def parse_amount_and_direction(element)
        return nil unless element

        {
          amount: parse_decimal(element.at_xpath('./Amt')&.text),
          credit_debit_indicator: element.at_xpath('./CdtDbtInd')&.text
        }
      end

      # Parse a boolean value
      # @param bool_str [String, nil] The boolean string
      # @return [Boolean, nil] The parsed boolean or nil
      def parse_boolean(bool_str)
        return nil unless bool_str

        bool_str.downcase == 'true'
      end

      # Parse a date element
      # @param element [Nokogiri::XML::Element, nil] The date element
      # @return [Hash, nil] The parsed date or nil
      def parse_date(element)
        return nil unless element

        if element.at_xpath('./Dt')
          { date: parse_iso_date(element.at_xpath('./Dt')&.text) }
        elsif element.at_xpath('./DtTm')
          { date_time: parse_datetime(element.at_xpath('./DtTm')&.text) }
        end
      end

      # Parse an ISO date string
      # @param date_str [String, nil] The date string
      # @return [Date, nil] The parsed date or nil
      def parse_iso_date(date_str)
        return nil unless date_str

        Date.iso8601(date_str)
      rescue ArgumentError
        # Return the original string if parsing fails
        date_str
      end

      # Parse an ISO datetime string
      # @param datetime_str [String, nil] The datetime string
      # @return [DateTime, nil] The parsed datetime or nil
      def parse_datetime(datetime_str)
        return nil unless datetime_str

        DateTime.iso8601(datetime_str)
      rescue ArgumentError
        # Return the original string if parsing fails
        datetime_str
      end
    end
  end
end
