# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/interest_record.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the InterestRecord2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/InterestRecord2
    class InterestRecord
      attr_reader :amount, :credit_debit_indicator, :type, :rate,
                  :from_to_date, :reason, :tax, :raw

      # Initialize a new InterestRecord instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @amount = parse_amount(element.at_xpath("./Amt"))
        @credit_debit_indicator = element.at_xpath("./CdtDbtInd")&.text
        @type = parse_type(element.at_xpath("./Tp"))
        @rate = element.at_xpath("./Rate") ? Rate.new(element.at_xpath("./Rate")) : nil
        @from_to_date = (DateTimePeriod.new(element.at_xpath("./FrToDt")) if element.at_xpath("./FrToDt"))
        @reason = element.at_xpath("./Rsn")&.text
        @tax = element.at_xpath("./Tax") ? TaxCharges.new(element.at_xpath("./Tax")) : nil
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an amount element
      # @param element [Nokogiri::XML::Element, nil] The amount element
      # @return [Hash, nil] The parsed amount or nil
      def parse_amount(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute("Ccy")&.value
        }
      end

      # Parse the type element
      # @param element [Nokogiri::XML::Element, nil] The type element
      # @return [Hash, nil] The parsed type or nil
      def parse_type(element)
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
