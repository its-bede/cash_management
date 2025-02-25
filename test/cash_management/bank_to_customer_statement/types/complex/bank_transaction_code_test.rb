# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class BankTransactionCodeTest < Minitest::Test
      def setup
        @xml_with_domain = <<~XML
          <BkTxCd>
            <Domn>
              <Cd>PMNT</Cd>
              <Fmly>
                <Cd>RCDT</Cd>
                <SubFmlyCd>ESCT</SubFmlyCd>
              </Fmly>
            </Domn>
          </BkTxCd>
        XML

        @xml_with_proprietary = <<~XML
          <BkTxCd>
            <Prtry>
              <Cd>PROP123</Cd>
              <Issr>BANK</Issr>
            </Prtry>
          </BkTxCd>
        XML

        @xml_with_both = <<~XML
          <BkTxCd>
            <Domn>
              <Cd>PMNT</Cd>
              <Fmly>
                <Cd>RCDT</Cd>
                <SubFmlyCd>ESCT</SubFmlyCd>
              </Fmly>
            </Domn>
            <Prtry>
              <Cd>PROP123</Cd>
              <Issr>BANK</Issr>
            </Prtry>
          </BkTxCd>
        XML
      end

      def test_parse_with_domain
        element = Nokogiri::XML(@xml_with_domain).at_xpath("//BkTxCd")
        code = BankTransactionCode.new(element)

        assert_equal("PMNT", code.domain[:code])
        assert_equal("RCDT", code.domain[:family][:code])
        assert_equal("ESCT", code.domain[:family][:sub_family_code])
        assert_nil(code.proprietary)
        assert_includes(code.raw, "<BkTxCd>")
      end

      def test_parse_with_proprietary
        element = Nokogiri::XML(@xml_with_proprietary).at_xpath("//BkTxCd")
        code = BankTransactionCode.new(element)

        assert_nil(code.domain)
        assert_equal("PROP123", code.proprietary[:code])
        assert_equal("BANK", code.proprietary[:issuer])
        assert_includes(code.raw, "<BkTxCd>")
      end

      def test_parse_with_both
        element = Nokogiri::XML(@xml_with_both).at_xpath("//BkTxCd")
        code = BankTransactionCode.new(element)

        assert_equal("PMNT", code.domain[:code])
        assert_equal("RCDT", code.domain[:family][:code])
        assert_equal("ESCT", code.domain[:family][:sub_family_code])
        assert_equal("PROP123", code.proprietary[:code])
        assert_equal("BANK", code.proprietary[:issuer])
        assert_includes(code.raw, "<BkTxCd>")
      end
    end
  end
end
