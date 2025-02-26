# frozen_string_literal: true

require "test_helper"
require "nokogiri"

module CashManagement
  module BankToCustomerStatement
    class TransactionReferencesTest < Minitest::Test
      def setup
        @xml_full = <<~XML
          <Refs>
            <MsgId>MSGID123</MsgId>
            <AcctSvcrRef>SVCREF456</AcctSvcrRef>
            <PmtInfId>PMTID789</PmtInfId>
            <InstrId>INSID101112</InstrId>
            <EndToEndId>E2EID131415</EndToEndId>
            <UETR>97ed4827-7b6f-4491-a06f-b548d5a7512d</UETR>
            <TxId>TXID161718</TxId>
            <MndtId>MANDATE192021</MndtId>
            <ChqNb>123456789</ChqNb>
            <ClrSysRef>CLRSYSREF222324</ClrSysRef>
            <AcctOwnrTxId>OWNER252627</AcctOwnrTxId>
            <AcctSvcrTxId>SERVICER282930</AcctSvcrTxId>
            <MktInfrstrctrTxId>MARKET313233</MktInfrstrctrTxId>
            <PrcgId>PROC343536</PrcgId>
            <Prtry>
              <Tp>CUSTOMTYPE1</Tp>
              <Ref>CUSTOMREF1</Ref>
            </Prtry>
            <Prtry>
              <Tp>CUSTOMTYPE2</Tp>
              <Ref>CUSTOMREF2</Ref>
            </Prtry>
          </Refs>
        XML

        @xml_minimal = <<~XML
          <Refs>
            <MsgId>MSGID123</MsgId>
            <EndToEndId>E2EID131415</EndToEndId>
          </Refs>
        XML
      end

      def test_parse_full
        element = Nokogiri::XML(@xml_full).at_xpath("//Refs")
        refs = TransactionReferences.new(element)

        assert_equal("MSGID123", refs.message_id)
        assert_equal("SVCREF456", refs.account_servicer_reference)
        assert_equal("PMTID789", refs.payment_information_id)
        assert_equal("INSID101112", refs.instruction_id)
        assert_equal("E2EID131415", refs.end_to_end_id)
        assert_equal("97ed4827-7b6f-4491-a06f-b548d5a7512d", refs.uetr)
        assert_equal("TXID161718", refs.transaction_id)
        assert_equal("MANDATE192021", refs.mandate_id)
        assert_equal("123456789", refs.cheque_number)
        assert_equal("CLRSYSREF222324", refs.clearing_system_reference)
        assert_equal("OWNER252627", refs.account_owner_transaction_id)
        assert_equal("SERVICER282930", refs.account_servicer_transaction_id)
        assert_equal("MARKET313233", refs.market_infrastructure_transaction_id)
        assert_equal("PROC343536", refs.processing_id)

        assert_equal(2, refs.proprietary.size)
        assert_equal("CUSTOMTYPE1", refs.proprietary[0].type)
        assert_equal("CUSTOMREF1", refs.proprietary[0].reference)
        assert_equal("CUSTOMTYPE2", refs.proprietary[1].type)
        assert_equal("CUSTOMREF2", refs.proprietary[1].reference)

        assert_includes(refs.raw, "<Refs>")
      end

      def test_parse_minimal
        element = Nokogiri::XML(@xml_minimal).at_xpath("//Refs")
        refs = TransactionReferences.new(element)

        assert_equal("MSGID123", refs.message_id)
        assert_nil(refs.account_servicer_reference)
        assert_nil(refs.payment_information_id)
        assert_nil(refs.instruction_id)
        assert_equal("E2EID131415", refs.end_to_end_id)
        assert_nil(refs.uetr)
        assert_nil(refs.transaction_id)
        assert_nil(refs.mandate_id)
        assert_nil(refs.cheque_number)
        assert_nil(refs.clearing_system_reference)
        assert_nil(refs.account_owner_transaction_id)
        assert_nil(refs.account_servicer_transaction_id)
        assert_nil(refs.market_infrastructure_transaction_id)
        assert_nil(refs.processing_id)

        assert_empty(refs.proprietary)

        assert_includes(refs.raw, "<Refs>")
      end
    end
  end
end
