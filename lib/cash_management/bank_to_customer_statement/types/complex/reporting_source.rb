# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/reporting_source.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ReportingSource1Choice element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ReportingSource1Choice
    class ReportingSource
      attr_reader :code, :proprietary, :raw

      # Initialize a new ReportingSource instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        # This is a choice element, so only one of the following will be set
        @code = element.at_xpath("./Cd")&.text
        @proprietary = element.at_xpath("./Prtry")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
