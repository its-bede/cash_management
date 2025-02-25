# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class PartyChoiceTest < Minitest::Test
      def setup
        @xml_with_org_id = <<~XML
          <Id>
            <OrgId>
              <AnyBIC>BANKBEBB</AnyBIC>
              <LEI>LEINUM123456789</LEI>
            </OrgId>
          </Id>
        XML

        @xml_with_private_id = <<~XML
          <Id>
            <PrvtId>
              <DtAndPlcOfBirth>
                <BirthDt>1980-01-01</BirthDt>
                <CityOfBirth>Brussels</CityOfBirth>
                <CtryOfBirth>BE</CtryOfBirth>
              </DtAndPlcOfBirth>
            </PrvtId>
          </Id>
        XML
      end

      def test_parse_with_org_id
        element = Nokogiri::XML(@xml_with_org_id).at_xpath("//Id")
        party_choice = PartyChoice.new(element)

        refute_nil(party_choice.organisation_identification)
        assert_nil(party_choice.private_identification)
        assert_equal("BANKBEBB", party_choice.organisation_identification.any_bic)
        assert_equal("LEINUM123456789", party_choice.organisation_identification.lei)
        assert_includes(party_choice.raw, "<Id>")
      end

      def test_parse_with_private_id
        element = Nokogiri::XML(@xml_with_private_id).at_xpath("//Id")
        party_choice = PartyChoice.new(element)

        assert_nil(party_choice.organisation_identification)
        refute_nil(party_choice.private_identification)
        refute_nil(party_choice.private_identification.date_and_place_of_birth)
        assert_equal("Brussels", party_choice.private_identification.date_and_place_of_birth.city_of_birth)
        assert_equal("BE", party_choice.private_identification.date_and_place_of_birth.country_of_birth)
        assert_includes(party_choice.raw, "<Id>")
      end
    end
  end
end
