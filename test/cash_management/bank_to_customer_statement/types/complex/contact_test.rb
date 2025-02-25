# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class ContactTest < Minitest::Test
      def setup
        @xml_full = <<~XML
          <CtctDtls>
            <NmPrfx>MISS</NmPrfx>
            <Nm>Jane Doe</Nm>
            <PhneNb>+32123456789</PhneNb>
            <MobNb>+32987654321</MobNb>
            <FaxNb>+32111222333</FaxNb>
            <EmailAdr>jane.doe@example.com</EmailAdr>
            <Othr>Additional info</Othr>
            <PrefrdMtd>EMAIL</PrefrdMtd>
          </CtctDtls>
        XML

        @xml_minimal = <<~XML
          <CtctDtls>
            <Nm>John Smith</Nm>
            <EmailAdr>john.smith@example.com</EmailAdr>
          </CtctDtls>
        XML
      end

      def test_parse_full
        element = Nokogiri::XML(@xml_full).at_xpath("//CtctDtls")
        contact = Contact.new(element)

        assert_equal("MISS", contact.name_prefix)
        assert_equal("Jane Doe", contact.name)
        assert_equal("+32123456789", contact.phone_number)
        assert_equal("+32987654321", contact.mobile_number)
        assert_equal("+32111222333", contact.fax_number)
        assert_equal("jane.doe@example.com", contact.email_address)
        assert_equal("Additional info", contact.other)
        assert_equal("EMAIL", contact.preferred_method)
        assert_includes(contact.raw, "<CtctDtls>")
      end

      def test_parse_minimal
        element = Nokogiri::XML(@xml_minimal).at_xpath("//CtctDtls")
        contact = Contact.new(element)

        assert_nil(contact.name_prefix)
        assert_equal("John Smith", contact.name)
        assert_nil(contact.phone_number)
        assert_nil(contact.mobile_number)
        assert_nil(contact.fax_number)
        assert_equal("john.smith@example.com", contact.email_address)
        assert_nil(contact.other)
        assert_nil(contact.preferred_method)
        assert_includes(contact.raw, "<CtctDtls>")
      end
    end
  end
end 