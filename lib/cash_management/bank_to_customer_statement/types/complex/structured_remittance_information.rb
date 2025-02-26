# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/structured_remittance_information.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the StructuredRemittanceInformation16 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/StructuredRemittanceInformation16
    class StructuredRemittanceInformation
      attr_reader :referred_document_information, :referred_document_amount,
                  :creditor_reference_information, :invoicer, :invoicee,
                  :tax_remittance, :garnishment_remittance,
                  :additional_remittance_information, :raw

      # Initialize a new StructuredRemittanceInformation instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @referred_document_information = element.xpath("./RfrdDocInf").map do |doc_info|
          ReferredDocumentInformation.new(doc_info)
        end
        @referred_document_amount = if element.at_xpath("./RfrdDocAmt")
                                      RemittanceAmount.new(element.at_xpath("./RfrdDocAmt"))
                                    end
        @creditor_reference_information = if element.at_xpath("./CdtrRefInf")
                                            CreditorReferenceInformation.new(element.at_xpath("./CdtrRefInf"))
                                          end
        @invoicer = element.at_xpath("./Invcr") ? PartyIdentification.new(element.at_xpath("./Invcr")) : nil
        @invoicee = element.at_xpath("./Invcee") ? PartyIdentification.new(element.at_xpath("./Invcee")) : nil
        @tax_remittance = element.at_xpath("./TaxRmt") ? TaxInformation.new(element.at_xpath("./TaxRmt")) : nil
        @garnishment_remittance = element.at_xpath("./GrnshmtRmt") ? Garnishment.new(element.at_xpath("./GrnshmtRmt")) : nil
        @additional_remittance_information = element.xpath("./AddtlRmtInf").map(&:text)
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
