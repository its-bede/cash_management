# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class GenericPersonIdentificationTest < Minitest::Test
      def setup
        @xml_with_code = <<~XML
          <Othr>
            <Id>123456789</Id>
            <SchmeNm>
              <Cd>NIDN</Cd>
            </SchmeNm>
            <Issr>GOVT</Issr>
          </Othr>
        XML

        @xml_with_proprietary = <<~XML
          <Othr>
            <Id>DRIV123456</Id>
            <SchmeNm>
              <Prtry>DRLC</Prtry>
            </SchmeNm>
            <Issr>DMV</Issr>
          </Othr>
        XML

        @xml_minimal = <<~XML
          <Othr>
            <Id>123456789</Id>
          </Othr>
        XML
      end

      def test_parse_with_code
        element = Nokogiri::XML(@xml_with_code).at_xpath("//Othr")
        generic_id = GenericPersonIdentification.new(element)

        assert_equal("123456789", generic_id.id)
        assert_equal({ code: "NIDN" }, generic_id.scheme_name)
        assert_equal("GOVT", generic_id.issuer)
        assert_includes(generic_id.raw, "<Othr>")
      end

      def test_parse_with_proprietary
        element = Nokogiri::XML(@xml_with_proprietary).at_xpath("//Othr")
        generic_id = GenericPersonIdentification.new(element)

        assert_equal("DRIV123456", generic_id.id)
        assert_equal({ proprietary: "DRLC" }, generic_id.scheme_name)
        assert_equal("DMV", generic_id.issuer)
        assert_includes(generic_id.raw, "<Othr>")
      end

      def test_parse_minimal
        element = Nokogiri::XML(@xml_minimal).at_xpath("//Othr")
        generic_id = GenericPersonIdentification.new(element)

        assert_equal("123456789", generic_id.id)
        assert_nil(generic_id.scheme_name)
        assert_nil(generic_id.issuer)
        assert_includes(generic_id.raw, "<Othr>")
      end
    end
  end
end 