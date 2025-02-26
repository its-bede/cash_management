# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/transaction_agents.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the TransactionAgents5 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/TransactionAgents5
    class TransactionAgents
      attr_reader :instructing_agent, :instructed_agent, :debtor_agent, :creditor_agent,
                  :intermediary_agent1, :intermediary_agent2, :intermediary_agent3,
                  :receiving_agent, :delivering_agent, :issuing_agent, :settlement_place,
                  :proprietary, :raw

      # Initialize a new TransactionAgents instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @instructing_agent = if element.at_xpath("./InstgAgt")
                               BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./InstgAgt"))
                             end
        @instructed_agent = if element.at_xpath("./InstdAgt")
                              BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./InstdAgt"))
                            end
        @debtor_agent = if element.at_xpath("./DbtrAgt")
                          BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./DbtrAgt"))
                        end
        @creditor_agent = if element.at_xpath("./CdtrAgt")
                            BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./CdtrAgt"))
                          end
        @intermediary_agent1 = if element.at_xpath("./IntrmyAgt1")
                                 BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./IntrmyAgt1"))
                               end
        @intermediary_agent2 = if element.at_xpath("./IntrmyAgt2")
                                 BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./IntrmyAgt2"))
                               end
        @intermediary_agent3 = if element.at_xpath("./IntrmyAgt3")
                                 BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./IntrmyAgt3"))
                               end
        @receiving_agent = if element.at_xpath("./RcvgAgt")
                             BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./RcvgAgt"))
                           end
        @delivering_agent = if element.at_xpath("./DlvrgAgt")
                              BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./DlvrgAgt"))
                            end
        @issuing_agent = if element.at_xpath("./IssgAgt")
                           BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./IssgAgt"))
                         end
        @settlement_place = if element.at_xpath("./SttlmPlc")
                              BranchAndFinancialInstitutionIdentification.new(element.at_xpath("./SttlmPlc"))
                            end
        @proprietary = element.xpath("./Prtry").map { |prop| ProprietaryAgent.new(prop) }
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end
    end
  end
end
