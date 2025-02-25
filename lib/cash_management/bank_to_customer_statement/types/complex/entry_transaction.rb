# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/entry_transaction.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the EntryTransaction10 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/EntryTransaction10
    class EntryTransaction
      attr_reader :references, :amount, :credit_debit_indicator, :amount_details,
                  :availability, :bank_transaction_code, :charges, :interest,
                  :related_parties, :related_agents, :local_instrument, :purpose,
                  :related_remittance_information, :remittance_information,
                  :related_dates, :related_price, :related_quantities,
                  :financial_instrument_id, :tax, :return_information,
                  :corporate_action, :safekeeping_account, :cash_deposit,
                  :card_transaction, :additional_transaction_information,
                  :supplementary_data, :raw

      # Initialize a new EntryTransaction instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @references = (TransactionReferences.new(element.at_xpath("./Refs")) if element.at_xpath("./Refs"))
        @amount = parse_amount(element.at_xpath("./Amt"))
        @credit_debit_indicator = element.at_xpath("./CdtDbtInd")&.text
        @amount_details = if element.at_xpath("./AmtDtls")
                            AmountAndCurrencyExchange.new(element.at_xpath("./AmtDtls"))
                          end
        @availability = element.xpath("./Avlbty").map do |avl|
          CashAvailability.new(avl)
        end
        @bank_transaction_code = (BankTransactionCode.new(element.at_xpath("./BkTxCd")) if element.at_xpath("./BkTxCd"))
        @charges = (Charges.new(element.at_xpath("./Chrgs")) if element.at_xpath("./Chrgs"))
        @interest = (TransactionInterest.new(element.at_xpath("./Intrst")) if element.at_xpath("./Intrst"))
        @related_parties = (TransactionParties.new(element.at_xpath("./RltdPties")) if element.at_xpath("./RltdPties"))
        @related_agents = (TransactionAgents.new(element.at_xpath("./RltdAgts")) if element.at_xpath("./RltdAgts"))
        @local_instrument = parse_local_instrument(element.at_xpath("./LclInstrm"))
        @purpose = parse_purpose(element.at_xpath("./Purp"))
        @related_remittance_information = element.xpath("./RltdRmtInf").map do |rmt|
          RemittanceLocation.new(rmt)
        end
        @remittance_information = if element.at_xpath("./RmtInf")
                                    RemittanceInformation.new(element.at_xpath("./RmtInf"))
                                  end
        @related_dates = (TransactionDates.new(element.at_xpath("./RltdDts")) if element.at_xpath("./RltdDts"))
        @related_price = (TransactionPrice.new(element.at_xpath("./RltdPric")) if element.at_xpath("./RltdPric"))
        @related_quantities = element.xpath("./RltdQties").map do |qty|
          TransactionQuantities.new(qty)
        end
        @financial_instrument_id = if element.at_xpath("./FinInstrmId")
                                     SecurityIdentification.new(element.at_xpath("./FinInstrmId"))
                                   end
        @tax = (TaxInformation.new(element.at_xpath("./Tax")) if element.at_xpath("./Tax"))
        @return_information = (PaymentReturnReason.new(element.at_xpath("./RtrInf")) if element.at_xpath("./RtrInf"))
        @corporate_action = (CorporateAction.new(element.at_xpath("./CorpActn")) if element.at_xpath("./CorpActn"))
        @safekeeping_account = if element.at_xpath("./SfkpgAcct")
                                 CashAccount.new(element.at_xpath("./SfkpgAcct"), :cash_account38)
                               end
        @cash_deposit = element.xpath("./CshDpst").map do |dpst|
          CashDeposit.new(dpst)
        end
        @card_transaction = (CardTransaction.new(element.at_xpath("./CardTx")) if element.at_xpath("./CardTx"))
        @additional_transaction_information = element.at_xpath("./AddtlTxInf")&.text
        @supplementary_data = element.xpath("./SplmtryData").map do |data|
          SupplementaryData.new(data)
        end
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an amount element
      # @param element [Nokogiri::XML::Element, nil] The amount element
      # @return [Hash, nil] The parsed amount or nil
      def parse_amount(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute("Ccy")&.value
        }
      end

      # Parse the local instrument element
      # @param element [Nokogiri::XML::Element, nil] The local instrument element
      # @return [Hash, nil] The parsed local instrument or nil
      def parse_local_instrument(element)
        return nil unless element

        if element.at_xpath("./Cd")
          { code: element.at_xpath("./Cd")&.text }
        elsif element.at_xpath("./Prtry")
          { proprietary: element.at_xpath("./Prtry")&.text }
        end
      end

      # Parse the purpose element
      # @param element [Nokogiri::XML::Element, nil] The purpose element
      # @return [Hash, nil] The parsed purpose or nil
      def parse_purpose(element)
        return nil unless element

        if element.at_xpath("./Cd")
          { code: element.at_xpath("./Cd")&.text }
        elsif element.at_xpath("./Prtry")
          { proprietary: element.at_xpath("./Prtry")&.text }
        end
      end
    end
  end
end
