# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class ProprietaryReferenceTest < Minitest::Test
      def setup
        @xml = <<~XML
          <Prtry>
            <Tp>CUSTOMTYPE</Tp>
            <Ref>CUSTOMREF</Ref>
          </Prtry>
        XML
      end

      def test_parse
        element = Nokogiri::XML(@xml).at_xpath("//Prtry")
        prop_ref = ProprietaryReference.new(element)

        assert_equal("CUSTOMTYPE", prop_ref.type)
        assert_equal("CUSTOMREF", prop_ref.reference)
        assert_includes(prop_ref.raw, "<Prtry>")
      end
    end
  end
end
