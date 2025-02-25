# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class OrganisationIdentificationTest < Minitest::Test
      def setup
        @xml_full = <<~XML
          <OrgId>
            <AnyBIC>BANKBEBB</AnyBIC>
            <LEI>LEINUM123456789</LEI>
            <Othr>
              <Id>123456789</Id>
              <SchmeNm>
                <Cd>CUST</Cd>
              </SchmeNm>
              <Issr>BANK</Issr>
            </Othr>
            <Othr>
              <Id>987654321</Id>
              <SchmeNm>
                <Prtry>PROP</Prtry>
              </SchmeNm>
            </Othr>
          </OrgId>
        XML

        @xml_minimal = <<~XML
          <OrgId>
            <AnyBIC>BANKBEBB</AnyBIC>
          </OrgId>
        XML
      end

      def test_parse_full
        element = Nokogiri::XML(@xml_full).at_xpath("//OrgId")
        org_id = OrganisationIdentification.new(element)

        assert_equal("BANKBEBB", org_id.any_bic)
        assert_equal("LEINUM123456789", org_id.lei)
        assert_equal(2, org_id.other.size)

        assert_equal("123456789", org_id.other[0].id)
        assert_equal({ code: "CUST" }, org_id.other[0].scheme_name)
        assert_equal("BANK", org_id.other[0].issuer)

        assert_equal("987654321", org_id.other[1].id)
        assert_equal({ proprietary: "PROP" }, org_id.other[1].scheme_name)
        assert_includes(org_id.raw, "<OrgId>")
      end

      def test_parse_minimal
        element = Nokogiri::XML(@xml_minimal).at_xpath("//OrgId")
        org_id = OrganisationIdentification.new(element)

        assert_equal("BANKBEBB", org_id.any_bic)
        assert_nil(org_id.lei)
        assert_empty(org_id.other)
        assert_includes(org_id.raw, "<OrgId>")
      end
    end
  end
end
