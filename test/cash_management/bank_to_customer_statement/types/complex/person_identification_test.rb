# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class PersonIdentificationTest < Minitest::Test
      def setup
        @xml_full = <<~XML
          <PrvtId>
            <DtAndPlcOfBirth>
              <BirthDt>1980-01-01</BirthDt>
              <PrvcOfBirth>Brabant</PrvcOfBirth>
              <CityOfBirth>Brussels</CityOfBirth>
              <CtryOfBirth>BE</CtryOfBirth>
            </DtAndPlcOfBirth>
            <Othr>
              <Id>123456789</Id>
              <SchmeNm>
                <Cd>NIDN</Cd>
              </SchmeNm>
              <Issr>GOVT</Issr>
            </Othr>
            <Othr>
              <Id>DRIV123456</Id>
              <SchmeNm>
                <Prtry>DRLC</Prtry>
              </SchmeNm>
            </Othr>
          </PrvtId>
        XML

        @xml_minimal = <<~XML
          <PrvtId>
            <Othr>
              <Id>123456789</Id>
            </Othr>
          </PrvtId>
        XML
      end

      def test_parse_full
        element = Nokogiri::XML(@xml_full).at_xpath("//PrvtId")
        person_id = PersonIdentification.new(element)

        refute_nil(person_id.date_and_place_of_birth)
        assert_equal(Date.new(1980, 1, 1), person_id.date_and_place_of_birth.birth_date)
        assert_equal("Brabant", person_id.date_and_place_of_birth.province_of_birth)
        assert_equal("Brussels", person_id.date_and_place_of_birth.city_of_birth)
        assert_equal("BE", person_id.date_and_place_of_birth.country_of_birth)
        
        assert_equal(2, person_id.other.size)
        assert_equal("123456789", person_id.other[0].id)
        assert_equal({ code: "NIDN" }, person_id.other[0].scheme_name)
        assert_equal("GOVT", person_id.other[0].issuer)
        
        assert_equal("DRIV123456", person_id.other[1].id)
        assert_equal({ proprietary: "DRLC" }, person_id.other[1].scheme_name)
        assert_includes(person_id.raw, "<PrvtId>")
      end

      def test_parse_minimal
        element = Nokogiri::XML(@xml_minimal).at_xpath("//PrvtId")
        person_id = PersonIdentification.new(element)

        assert_nil(person_id.date_and_place_of_birth)
        assert_equal(1, person_id.other.size)
        assert_equal("123456789", person_id.other[0].id)
        assert_nil(person_id.other[0].scheme_name)
        assert_nil(person_id.other[0].issuer)
        assert_includes(person_id.raw, "<PrvtId>")
      end
    end
  end
end 