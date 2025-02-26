# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/remittance_amount.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the RemittanceAmount2 and RemittanceAmount3 elements in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/RemittanceAmount2
    # @see https://www.iso20022.org/standardsrepository/type/RemittanceAmount3
    class RemittanceAmount
      attr_reader :due_payable_amount, :discount_applied_amounts,
                  :credit_note_amount, :tax_amounts,
                  :adjustment_amounts_and_reasons, :remitted_amount, :raw

      # Initialize a new RemittanceAmount instance from an XML element
      #
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @due_payable_amount = parse_amount(element.at_xpath("./DuePyblAmt"))
        @discount_applied_amounts = element.xpath("./DscntApldAmt").map do |discount|
          parse_discount_amount(discount)
        end
        @credit_note_amount = parse_amount(element.at_xpath("./CdtNoteAmt"))
        @tax_amounts = element.xpath("./TaxAmt").map do |tax|
          parse_tax_amount(tax)
        end
        @adjustment_amounts_and_reasons = element.xpath("./AdjstmntAmtAndRsn").map do |adjustment|
          parse_document_adjustment(adjustment)
        end
        @remitted_amount = parse_amount(element.at_xpath("./RmtdAmt"))
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an amount element
      #
      # @param element [Nokogiri::XML::Element, nil] The amount element
      # @return [Hash, nil] The parsed amount or nil
      def parse_amount(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute("Ccy")&.value
        }
      end

      # Parse a discount amount element
      #
      # @param element [Nokogiri::XML::Element] The discount amount element
      # @return [Hash] The parsed discount amount
      def parse_discount_amount(element)
        {
          type: parse_discount_type(element.at_xpath("./Tp")),
          amount: parse_amount(element.at_xpath("./Amt"))
        }.compact
      end

      # Parse a discount type element
      #
      # @param element [Nokogiri::XML::Element, nil] The discount type element
      # @return [Hash, nil] The parsed discount type
      def parse_discount_type(element)
        return nil unless element

        if element.at_xpath("./Cd")
          { code: element.at_xpath("./Cd")&.text }
        elsif element.at_xpath("./Prtry")
          { proprietary: element.at_xpath("./Prtry")&.text }
        end
      end

      # Parse a tax amount element
      #
      # @param element [Nokogiri::XML::Element] The tax amount element
      # @return [Hash] The parsed tax amount
      def parse_tax_amount(element)
        {
          type: parse_tax_type(element.at_xpath("./Tp")),
          amount: parse_amount(element.at_xpath("./Amt"))
        }.compact
      end

      # Parse a tax type element
      #
      # @param element [Nokogiri::XML::Element, nil] The tax type element
      # @return [Hash, nil] The parsed tax type
      def parse_tax_type(element)
        return nil unless element

        if element.at_xpath("./Cd")
          { code: element.at_xpath("./Cd")&.text }
        elsif element.at_xpath("./Prtry")
          { proprietary: element.at_xpath("./Prtry")&.text }
        end
      end

      # Parse a document adjustment element
      #
      # @param element [Nokogiri::XML::Element] The document adjustment element
      # @return [Hash] The parsed document adjustment
      def parse_document_adjustment(element)
        {
          amount: parse_amount(element.at_xpath("./Amt")),
          credit_debit_indicator: element.at_xpath("./CdtDbtInd")&.text,
          reason: element.at_xpath("./Rsn")&.text,
          additional_information: element.at_xpath("./AddtlInf")&.text
        }.compact
      end
    end
  end
end
