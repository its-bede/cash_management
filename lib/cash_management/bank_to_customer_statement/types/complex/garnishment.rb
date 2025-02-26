# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/garnishment.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the Garnishment3 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/Garnishment3
    class Garnishment
      attr_reader :type, :garnishee, :garnishment_administrator, :reference_number,
                  :date, :remitted_amount, :family_medical_insurance_indicator,
                  :employee_termination_indicator, :raw

      # Initialize a new Garnishment instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @type = GarnishmentType.new(element.at_xpath("./Tp"))
        @garnishee = element.at_xpath("./Grnshee") ? PartyIdentification.new(element.at_xpath("./Grnshee")) : nil
        @garnishment_administrator = element.at_xpath("./GrnshmtAdmstr") ? PartyIdentification.new(element.at_xpath("./GrnshmtAdmstr")) : nil
        @reference_number = element.at_xpath("./RefNb")&.text
        @date = parse_date(element.at_xpath("./Dt")&.text)
        @remitted_amount = parse_amount(element.at_xpath("./RmtdAmt"))
        @family_medical_insurance_indicator = parse_boolean(element.at_xpath("./FmlyMdclInsrncInd")&.text)
        @employee_termination_indicator = parse_boolean(element.at_xpath("./MplyeeTermntnInd")&.text)
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

      # Parse a boolean value
      # @param bool_str [String, nil] The boolean string
      # @return [Boolean, nil] The parsed boolean or nil
      def parse_boolean(bool_str)
        return nil unless bool_str

        bool_str.downcase == "true"
      end
    end
  end
end
