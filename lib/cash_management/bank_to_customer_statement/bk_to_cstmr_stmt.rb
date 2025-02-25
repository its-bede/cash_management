# frozen_string_literal: true

module CashManagement
  # Module for bank to customer statement (camt.053) functionality
  module BankToCustomerStatement
    # Represents the BkToCstmrStmt element
    class BkToCstmrStmt
      attr_reader :group_header, :statements, :supplementary_data

      def initialize(element)
        @group_header = GroupHeader.new(element.at_xpath("./GrpHdr"))
        @statements = element.xpath("./Stmt").map { |stmt| AccountStatement.new(stmt) }
        return unless element.xpath("./SplmtryData").any?

        @supplementary_data = element.xpath("./SplmtryData").map do |data|
          SupplementaryData.new(data)
        end
      end
    end
  end
end
