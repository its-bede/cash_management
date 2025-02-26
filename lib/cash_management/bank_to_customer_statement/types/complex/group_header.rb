# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/group_header.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the GroupHeader (GroupHeader81) element
    # @see https://www.iso20022.org/standardsrepository/type/GroupHeader81
    class GroupHeader
      attr_reader :message_id, :creation_date_time, :message_recipient,
                  :message_pagination, :original_business_query, :additional_information, :raw

      # @param element [Nokogiri::XML::Element] The GroupHeader XML element
      def initialize(element)
        @message_id = element.at_xpath("./MsgId")&.text
        @creation_date_time = parse_datetime(element.at_xpath("./CreDtTm")&.text)
        @message_recipient = element.at_xpath("./MsgRcpt") ? PartyIdentification.new(element.at_xpath("./MsgRcpt")) : nil
        @message_pagination = element.at_xpath("./MsgPgntn") ? Pagination.new(element.at_xpath("./MsgPgntn")) : nil
        @original_business_query = element.at_xpath("./OrgnlBizQry") ? OriginalBusinessQuery.new(element.at_xpath("./OrgnlBizQry")) : nil
        @additional_information = element.at_xpath("./AddtlInf")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse a datetime string
      # @param datetime_str [String, nil] The datetime string
      # @return [DateTime, String] The parsed datetime or the original string if parsing fails
      def parse_datetime(datetime_str)
        return nil unless datetime_str

        # Parse ISO8601 datetime string to Ruby DateTime
        DateTime.iso8601(datetime_str)
      rescue ArgumentError
        # If parsing fails, return the original string
        datetime_str
      end
    end
  end
end
