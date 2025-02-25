# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class GenericOrganisationIdentificationTest < Minitest::Test
      def setup
        @xml_with_code = <<~XML
          <Othr>
            <Id>123456789</Id>
            <SchmeNm>
              <Cd>CUST</Cd>
            </SchmeNm>
            <Issr>BANK</Issr>
          </Othr>
        XML

        @xml_with_proprietary = <<~XML
          <Othr>
            <Id>987654321</Id>
            <SchmeNm>
              <Prtry>PROP</Prtry>
            </SchmeNm>
            <Issr>GOVT</Issr>
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
        generic_id = GenericOrganisationIdentification.new(element)

        assert_equal("123456789", generic_id.id)
        assert_equal({ code: "CUST" }, generic_id.scheme_name)
        assert_equal("BANK", generic_id.issuer)
        assert_includes(generic_id.raw, "<Othr>")
      end

      def test_parse_with_proprietary
        element = Nokogiri::XML(@xml_with_proprietary).at_xpath("//Othr")
        generic_id = GenericOrganisationIdentification.new(element)

        assert_equal("987654321", generic_id.id)
        assert_equal({ proprietary: "PROP" }, generic_id.scheme_name)
        assert_equal("GOVT", generic_id.issuer)
        assert_includes(generic_id.raw, "<Othr>")
      end

      def test_parse_minimal
        element = Nokogiri::XML(@xml_minimal).at_xpath("//Othr")
        generic_id = GenericOrganisationIdentification.new(element)

        assert_equal("123456789", generic_id.id)
        assert_nil(generic_id.scheme_name)
        assert_nil(generic_id.issuer)
        assert_includes(generic_id.raw, "<Othr>")
      end
    end
  end
end 