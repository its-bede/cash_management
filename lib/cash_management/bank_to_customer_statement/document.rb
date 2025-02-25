# frozen_string_literal: true

module CashManagement
  module BankToCustomerStatement
    # Represents the root document of a camt.053.001.08 message
    class Document
      attr_reader :bank_to_customer_statement

      def initialize(doc)
        @bank_to_customer_statement = BkToCstmrStmt.new(doc.at_xpath("//BkToCstmrStmt"))
      end
    end
  end
end
