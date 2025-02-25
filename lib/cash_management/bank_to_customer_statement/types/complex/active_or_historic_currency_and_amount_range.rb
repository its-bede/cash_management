# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/active_or_historic_currency_and_amount_range.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ActiveOrHistoricCurrencyAndAmountRange2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ActiveOrHistoricCurrencyAndAmountRange2
    class ActiveOrHistoricCurrencyAndAmountRange
      attr_reader :amount, :credit_debit_indicator, :currency, :raw

      # Initialize a new ActiveOrHistoricCurrencyAndAmountRange instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @amount = parse_amount_range(element.at_xpath("./Amt"))
        @credit_debit_indicator = element.at_xpath("./CdtDbtInd")&.text
        @currency = element.at_xpath("./Ccy")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an amount range element
      # @param element [Nokogiri::XML::Element, nil] The amount range element
      # @return [Hash, nil] The parsed amount range or nil
      def parse_amount_range(element)
        return nil unless element

        if element.at_xpath("./FrAmt")
          { from_amount: parse_amount_boundary(element.at_xpath("./FrAmt")) }
        elsif element.at_xpath("./ToAmt")
          { to_amount: parse_amount_boundary(element.at_xpath("./ToAmt")) }
        elsif element.at_xpath("./FrToAmt")
          {
            from_amount: parse_amount_boundary(element.at_xpath("./FrToAmt/FrAmt")),
            to_amount: parse_amount_boundary(element.at_xpath("./FrToAmt/ToAmt"))
          }
        elsif element.at_xpath("./EQAmt")
          { equal_amount: element.at_xpath("./EQAmt")&.text&.to_f }
        elsif element.at_xpath("./NEQAmt")
          { not_equal_amount: element.at_xpath("./NEQAmt")&.text&.to_f }
        end
      end

      # Parse an amount boundary
      # @param element [Nokogiri::XML::Element, nil] The amount boundary element
      # @return [Hash, nil] The parsed amount boundary or nil
      def parse_amount_boundary(element)
        return nil unless element

        {
          boundary_amount: element.at_xpath("./BdryAmt")&.text&.to_f,
          inclusive: element.at_xpath("./Incl")&.text&.downcase == "true"
        }
      end
    end
  end
end
