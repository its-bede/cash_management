# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/cash_balance.rb

module CashManagement
  module BankToCustomerStatement
    # Represents a Cash Balance (CashBalance8) element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CashBalance8
    class CashBalance
      attr_reader :type, :credit_lines, :amount, :credit_debit_indicator, :date, :availability, :raw

      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = parse_balance_type(element.at_xpath('./Tp'))
        @credit_lines = element.xpath('./CdtLine').map { |line| CreditLine.new(line) }
        @amount = parse_amount(element.at_xpath('./Amt'))
        @credit_debit_indicator = element.at_xpath('./CdtDbtInd')&.text
        @date = parse_date(element.at_xpath('./Dt'))
        @availability = element.xpath('./Avlbty').map { |avail| CashAvailability.new(avail) }
        @raw = element.to_s
      end

      private

      # Parse the balance type
      # @param element [Nokogiri::XML::Element, nil] The balance type element
      # @return [Hash, nil] The parsed balance type or nil
      def parse_balance_type(element)
        return nil unless element

        result = {}

        if element.at_xpath('./CdOrPrtry/Cd')
          result[:code_or_proprietary] = { code: element.at_xpath('./CdOrPrtry/Cd')&.text }
        elsif element.at_xpath('./CdOrPrtry/Prtry')
          result[:code_or_proprietary] = { proprietary: element.at_xpath('./CdOrPrtry/Prtry')&.text }
        end

        if element.at_xpath('./SubTp')
          result[:sub_type] = parse_sub_type(element.at_xpath('./SubTp'))
        end

        result
      end

      # Parse the sub type
      # @param element [Nokogiri::XML::Element, nil] The sub type element
      # @return [Hash, nil] The parsed sub type or nil
      def parse_sub_type(element)
        return nil unless element

        if element.at_xpath('./Cd')
          { code: element.at_xpath('./Cd')&.text }
        elsif element.at_xpath('./Prtry')
          { proprietary: element.at_xpath('./Prtry')&.text }
        end
      end

      # Parse an amount
      # @param element [Nokogiri::XML::Element, nil] The amount element
      # @return [Hash, nil] The parsed amount or nil
      def parse_amount(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute('Ccy')&.value
        }
      end

      # Parse a date
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
        date_str
      end

      # Parse an ISO datetime string
      # @param datetime_str [String, nil] The datetime string
      # @return [DateTime, nil] The parsed datetime or nil
      def parse_datetime(datetime_str)
        return nil unless datetime_str
        DateTime.iso8601(datetime_str)
      rescue ArgumentError
        datetime_str
      end
    end
  end
end