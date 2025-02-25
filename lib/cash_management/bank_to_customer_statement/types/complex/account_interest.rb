# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/account_interest.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the AccountInterest4 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/AccountInterest4
    class AccountInterest
      attr_reader :type, :rates, :from_to_date, :reason, :tax, :raw

      # Initialize a new AccountInterest instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = parse_interest_type(element.at_xpath("./Tp"))
        @rates = element.xpath("./Rate").map { |rate| Rate.new(rate) }
        @from_to_date = (DateTimePeriod.new(element.at_xpath("./FrToDt")) if element.at_xpath("./FrToDt"))
        @reason = element.at_xpath("./Rsn")&.text
        @tax = element.at_xpath("./Tax") ? TaxCharges.new(element.at_xpath("./Tax")) : nil
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the interest type element
      # @param element [Nokogiri::XML::Element, nil] The interest type element
      # @return [Hash, nil] The parsed interest type or nil
      def parse_interest_type(element)
        return nil unless element

        if element.at_xpath("./Cd")
          { code: element.at_xpath("./Cd")&.text }
        elsif element.at_xpath("./Prtry")
          { proprietary: element.at_xpath("./Prtry")&.text }
        end
      end
    end
  end
end
