# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/charges_record.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the ChargesRecord3 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ChargesRecord3
    class ChargesRecord
      attr_reader :amount, :credit_debit_indicator, :charge_included_indicator,
                  :type, :rate, :bearer, :agent, :tax, :raw

      # Initialize a new ChargesRecord instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @amount = parse_amount(element.at_xpath('./Amt'))
        @credit_debit_indicator = element.at_xpath('./CdtDbtInd')&.text
        @charge_included_indicator = parse_boolean(element.at_xpath('./ChrgInclInd')&.text)
        @type = parse_type(element.at_xpath('./Tp'))
        @rate = parse_percentage_rate(element.at_xpath('./Rate')&.text)
        @bearer = element.at_xpath('./Br')&.text
        @agent = element.at_xpath('./Agt') ?
                   BranchAndFinancialInstitutionIdentification.new(element.at_xpath('./Agt')) : nil
        @tax = element.at_xpath('./Tax') ? TaxCharges.new(element.at_xpath('./Tax')) : nil
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
          currency: element.attribute('Ccy')&.value
        }
      end

      # Parse a boolean value
      # @param bool_str [String, nil] The boolean string
      # @return [Boolean, nil] The parsed boolean or nil
      def parse_boolean(bool_str)
        return nil unless bool_str

        bool_str.downcase == 'true'
      end

      # Parse the type element
      # @param element [Nokogiri::XML::Element, nil] The type element
      # @return [Hash, nil] The parsed type or nil
      def parse_type(element)
        return nil unless element

        if element.at_xpath('./Cd')
          { code: element.at_xpath('./Cd')&.text }
        elsif element.at_xpath('./Prtry')
          { proprietary: parse_generic_identification(element.at_xpath('./Prtry')) }
        end
      end

      # Parse a generic identification element
      # @param element [Nokogiri::XML::Element, nil] The generic identification element
      # @return [Hash, nil] The parsed generic identification or nil
      def parse_generic_identification(element)
        return nil unless element

        {
          id: element.at_xpath('./Id')&.text,
          issuer: element.at_xpath('./Issr')&.text
        }
      end

      # Parse a percentage rate
      # @param rate_str [String, nil] The rate string
      # @return [Float, nil] The parsed rate or nil
      def parse_percentage_rate(rate_str)
        return nil unless rate_str

        rate_str.to_f
      end
    end
  end
end
