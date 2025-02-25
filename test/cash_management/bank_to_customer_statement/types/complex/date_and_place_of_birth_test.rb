# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class DateAndPlaceOfBirthTest < Minitest::Test
      def setup
        @xml_full = <<~XML
          <DtAndPlcOfBirth>
            <BirthDt>1980-01-01</BirthDt>
            <PrvcOfBirth>Brabant</PrvcOfBirth>
            <CityOfBirth>Brussels</CityOfBirth>
            <CtryOfBirth>BE</CtryOfBirth>
          </DtAndPlcOfBirth>
        XML

        @xml_minimal = <<~XML
          <DtAndPlcOfBirth>
            <BirthDt>1980-01-01</BirthDt>
            <CityOfBirth>Brussels</CityOfBirth>
            <CtryOfBirth>BE</CtryOfBirth>
          </DtAndPlcOfBirth>
        XML

        @xml_invalid_date = <<~XML
          <DtAndPlcOfBirth>
            <BirthDt>INVALID</BirthDt>
            <CityOfBirth>Brussels</CityOfBirth>
            <CtryOfBirth>BE</CtryOfBirth>
          </DtAndPlcOfBirth>
        XML
      end

      def test_parse_full
        element = Nokogiri::XML(@xml_full).at_xpath("//DtAndPlcOfBirth")
        birth_info = DateAndPlaceOfBirth.new(element)

        assert_equal(Date.new(1980, 1, 1), birth_info.birth_date)
        assert_equal("Brabant", birth_info.province_of_birth)
        assert_equal("Brussels", birth_info.city_of_birth)
        assert_equal("BE", birth_info.country_of_birth)
        assert_includes(birth_info.raw, "<DtAndPlcOfBirth>")
      end

      def test_parse_minimal
        element = Nokogiri::XML(@xml_minimal).at_xpath("//DtAndPlcOfBirth")
        birth_info = DateAndPlaceOfBirth.new(element)

        assert_equal(Date.new(1980, 1, 1), birth_info.birth_date)
        assert_nil(birth_info.province_of_birth)
        assert_equal("Brussels", birth_info.city_of_birth)
        assert_equal("BE", birth_info.country_of_birth)
        assert_includes(birth_info.raw, "<DtAndPlcOfBirth>")
      end

      def test_parse_invalid_date
        element = Nokogiri::XML(@xml_invalid_date).at_xpath("//DtAndPlcOfBirth")
        birth_info = DateAndPlaceOfBirth.new(element)

        assert_equal("INVALID", birth_info.birth_date)
        assert_nil(birth_info.province_of_birth)
        assert_equal("Brussels", birth_info.city_of_birth)
        assert_equal("BE", birth_info.country_of_birth)
        assert_includes(birth_info.raw, "<DtAndPlcOfBirth>")
      end
    end
  end
end 