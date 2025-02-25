# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class CreditLineTest < Minitest::Test
      def setup
        @xml_with_code = <<~XML
          <CdtLine>
            <Incl>true</Incl>
            <Amt Ccy="EUR">5000.00</Amt>
            <Tp>
              <Cd>OTHR</Cd>
            </Tp>
          </CdtLine>
        XML

        @xml_with_proprietary = <<~XML
          <CdtLine>
            <Incl>false</Incl>
            <Amt Ccy="USD">10000.00</Amt>
            <Tp>
              <Prtry>CustomCreditLine</Prtry>
            </Tp>
          </CdtLine>
        XML

        @xml_minimal = <<~XML
          <CdtLine>
            <Incl>true</Incl>
          </CdtLine>
        XML
      end

      def test_parse_with_code
        element = Nokogiri::XML(@xml_with_code).at_xpath("//CdtLine")
        credit_line = CreditLine.new(element)

        assert(credit_line.included)
        assert_equal({ value: 5000.00, currency: "EUR" }, credit_line.amount)
        assert_equal({ code: "OTHR" }, credit_line.type)
        assert_includes(credit_line.raw, "<CdtLine>")
      end

      def test_parse_with_proprietary
        element = Nokogiri::XML(@xml_with_proprietary).at_xpath("//CdtLine")
        credit_line = CreditLine.new(element)

        refute(credit_line.included)
        assert_equal({ value: 10000.00, currency: "USD" }, credit_line.amount)
        assert_equal({ proprietary: "CustomCreditLine" }, credit_line.type)
        assert_includes(credit_line.raw, "<CdtLine>")
      end

      def test_parse_minimal
        element = Nokogiri::XML(@xml_minimal).at_xpath("//CdtLine")
        credit_line = CreditLine.new(element)

        assert(credit_line.included)
        assert_nil(credit_line.amount)
        assert_nil(credit_line.type)
        assert_includes(credit_line.raw, "<CdtLine>")
      end
    end
  end
end 