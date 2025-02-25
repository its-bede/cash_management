# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/original_business_query.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the OriginalBusinessQuery (OriginalBusinessQuery1) element
    # @see https://www.iso20022.org/standardsrepository/type/OriginalBusinessQuery1
    class OriginalBusinessQuery
      attr_reader :message_id, :message_name_id, :creation_date_time, :raw

      def initialize(element)
        @message_id = element.at_xpath("./MsgId")&.text
        @message_name_id = element.at_xpath("./MsgNmId")&.text
        @creation_date_time = parse_datetime(element.at_xpath("./CreDtTm")&.text)
        @raw = element.to_s
      end

      private

      def parse_datetime(datetime_str)
        return nil unless datetime_str

        DateTime.iso8601(datetime_str)
      rescue ArgumentError
        datetime_str
      end
    end
  end
end
