# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/tax_record.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TaxRecord2 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TaxRecord2
    class TaxRecord
      attr_reader :type, :category, :category_details, :debtor_status,
                  :certificate_id, :forms_code, :period, :tax_amount,
                  :additional_information, :raw

      # Initialize a new TaxRecord instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = element.at_xpath("./Tp")&.text
        @category = element.at_xpath("./Ctgy")&.text
        @category_details = element.at_xpath("./CtgyDtls")&.text
        @debtor_status = element.at_xpath("./DbtrSts")&.text
        @certificate_id = element.at_xpath("./CertId")&.text
        @forms_code = element.at_xpath("./FrmsCd")&.text
        @period = element.at_xpath("./Prd") ? TaxPeriod.new(element.at_xpath("./Prd")) : nil
        @tax_amount = element.at_xpath("./TaxAmt") ? TaxAmount.new(element.at_xpath("./TaxAmt")) : nil
        @additional_information = element.at_xpath("./AddtlInf")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
