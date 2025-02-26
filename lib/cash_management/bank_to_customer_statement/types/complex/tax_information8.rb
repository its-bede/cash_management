# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/tax_information8.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TaxInformation8 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TaxInformation8
    class TaxInformation8
      attr_reader :creditor, :debtor, :administration_zone, :reference_number,
                  :method, :total_taxable_base_amount, :total_tax_amount,
                  :date, :sequence_number, :records, :raw

      # Initialize a new TaxInformation8 instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @creditor = element.at_xpath("./Cdtr") ? TaxParty.new(element.at_xpath("./Cdtr")) : nil
        @debtor = element.at_xpath("./Dbtr") ? TaxParty2.new(element.at_xpath("./Dbtr")) : nil
        @administration_zone = element.at_xpath("./AdmstnZone")&.text
        @reference_number = element.at_xpath("./RefNb")&.text
        @method = element.at_xpath("./Mtd")&.text
        @total_taxable_base_amount = parse_amount(element.at_xpath("./TtlTaxblBaseAmt"))
        @total_tax_amount = parse_amount(element.at_xpath("./TtlTaxAmt"))
        @date = parse_date(element.at_xpath("./Dt")&.text)
        @sequence_number = element.at_xpath("./SeqNb")&.text&.to_f
        @records = element.xpath("./Rcrd").map { |record| TaxRecord.new(record) }
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
