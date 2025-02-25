# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/card_aggregated.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the CardAggregated2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CardAggregated2
    class CardAggregated
      attr_reader :additional_service, :transaction_category, :sale_reconciliation_id,
                  :sequence_number_range, :transaction_date_range, :raw

      # Initialize a new CardAggregated instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @additional_service = element.at_xpath("./AddtlSvc")&.text
        @transaction_category = element.at_xpath("./TxCtgy")&.text
        @sale_reconciliation_id = element.at_xpath("./SaleRcncltnId")&.text
        @sequence_number_range = if element.at_xpath("./SeqNbRg")
                                   CardSequenceNumberRange.new(element.at_xpath("./SeqNbRg"))
                                 end
        @transaction_date_range = if element.at_xpath("./TxDtRg")
                                    parse_date_or_date_time_period(element.at_xpath("./TxDtRg"))
                                  end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse a date or date time period choice element
      # @param element [Nokogiri::XML::Element, nil] The element to parse
      # @return [Hash, nil] The parsed period choice or nil
      def parse_date_or_date_time_period(element)
        return nil unless element

        if element.at_xpath("./Dt")
          { date: parse_date_period(element.at_xpath("./Dt")) }
        elsif element.at_xpath("./DtTm")
          { date_time: DateTimePeriod.new(element.at_xpath("./DtTm")) }
        end
      end

      # Parse a date period element
      # @param element [Nokogiri::XML::Element, nil] The element to parse
      # @return [Hash, nil] The parsed date period or nil
      def parse_date_period(element)
        return nil unless element

        {
          from_date: parse_date(element.at_xpath("./FrDt")&.text),
          to_date: parse_date(element.at_xpath("./ToDt")&.text)
        }
      end

      # Parse an ISO date string
      # @param date_str [String, nil] The date string
      # @return [Date, nil] The parsed date or nil
      def parse_date(date_str)
        return nil unless date_str

        Date.iso8601(date_str)
      rescue ArgumentError
        # Return the original string if parsing fails
        date_str
      end
    end
  end
end
