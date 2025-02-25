# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class ProxyAccountIdentificationTest < Minitest::Test
      def setup
        @xml_with_code = <<~XML
          <Prxy>
            <Tp>
              <Cd>EMPL</Cd>
            </Tp>
            <Id>12345678</Id>
          </Prxy>
        XML

        @xml_with_proprietary = <<~XML
          <Prxy>
            <Tp>
              <Prtry>CustomType</Prtry>
            </Tp>
            <Id>87654321</Id>
          </Prxy>
        XML

        @xml_without_type = <<~XML
          <Prxy>
            <Id>12345678</Id>
          </Prxy>
        XML
      end

      def test_parse_with_code
        element = Nokogiri::XML(@xml_with_code).at_xpath("//Prxy")
        proxy = ProxyAccountIdentification.new(element)

        assert_equal({ code: "EMPL" }, proxy.type)
        assert_equal("12345678", proxy.id)
        assert_includes(proxy.raw, "<Prxy>")
      end

      def test_parse_with_proprietary
        element = Nokogiri::XML(@xml_with_proprietary).at_xpath("//Prxy")
        proxy = ProxyAccountIdentification.new(element)

        assert_equal({ proprietary: "CustomType" }, proxy.type)
        assert_equal("87654321", proxy.id)
        assert_includes(proxy.raw, "<Prxy>")
      end

      def test_parse_without_type
        element = Nokogiri::XML(@xml_without_type).at_xpath("//Prxy")
        proxy = ProxyAccountIdentification.new(element)

        assert_nil(proxy.type)
        assert_equal("12345678", proxy.id)
        assert_includes(proxy.raw, "<Prxy>")
      end
    end
  end
end
