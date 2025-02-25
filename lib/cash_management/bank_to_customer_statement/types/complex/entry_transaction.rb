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
        @references = element.at_xpath('./Refs') ?
                        TransactionReferences.new(element.at_xpath('./Refs')) : nil
        @amount = parse_amount(element.at_xpath('./Amt'))
        @credit_debit_indicator = element.at_xpath('./CdtDbtInd')&.text
        @amount_details = element.at_xpath('./AmtDtls') ?
                            AmountAndCurrencyExchange.new(element.at_xpath('./AmtDtls')) : nil
        @availability = element.xpath('./Avlbty').map { |avl|
          CashAvailability.new(avl)
        }
        @bank_transaction_code = element.at_xpath('./BkTxCd') ?
                                   BankTransactionCode.new(element.at_xpath('./BkTxCd')) : nil
        @charges = element.at_xpath('./Chrgs') ?
                     Charges.new(element.at_xpath('./Chrgs')) : nil
        @interest = element.at_xpath('./Intrst') ?
                      TransactionInterest.new(element.at_xpath('./Intrst')) : nil
        @related_parties = element.at_xpath('./RltdPties') ?
                             TransactionParties.new(element.at_xpath('./RltdPties')) : nil
        @related_agents = element.at_xpath('./RltdAgts') ?
                            TransactionAgents.new(element.at_xpath('./RltdAgts')) : nil
        @local_instrument = parse_local_instrument(element.at_xpath('./LclInstrm'))
        @purpose = parse_purpose(element.at_xpath('./Purp'))
        @related_remittance_information = element.xpath('./RltdRmtInf').map { |rmt|
          RemittanceLocation.new(rmt)
        }
        @remittance_information = element.at_xpath('./RmtInf') ?
                                    RemittanceInformation.new(element.at_xpath('./RmtInf')) : nil
        @related_dates = element.at_xpath('./RltdDts') ?
                           TransactionDates.new(element.at_xpath('./RltdDts')) : nil
        @related_price = element.at_xpath('./RltdPric') ?
                           TransactionPrice.new(element.at_xpath('./RltdPric')) : nil
        @related_quantities = element.xpath('./RltdQties').map { |qty|
          TransactionQuantities.new(qty)
        }
        @financial_instrument_id = element.at_xpath('./FinInstrmId') ?
                                     SecurityIdentification.new(element.at_xpath('./FinInstrmId')) : nil
        @tax = element.at_xpath('./Tax') ?
                 TaxInformation.new(element.at_xpath('./Tax')) : nil
        @return_information = element.at_xpath('./RtrInf') ?
                                PaymentReturnReason.new(element.at_xpath('./RtrInf')) : nil
        @corporate_action = element.at_xpath('./CorpActn') ?
                              CorporateAction.new(element.at_xpath('./CorpActn')) : nil
        @safekeeping_account = element.at_xpath('./SfkpgAcct') ?
                                 CashAccount.new(element.at_xpath('./SfkpgAcct'), :cash_account38) : nil
        @cash_deposit = element.xpath('./CshDpst').map { |dpst|
          CashDeposit.new(dpst)
        }
        @card_transaction = element.at_xpath('./CardTx') ?
                              CardTransaction.new(element.at_xpath('./CardTx')) : nil
        @additional_transaction_information = element.at_xpath('./AddtlTxInf')&.text
        @supplementary_data = element.xpath('./SplmtryData').map { |data|
          SupplementaryData.new(data)
        }
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
          currency: element.attribute('Ccy')&.value
        }
      end

      # Parse the local instrument element
      # @param element [Nokogiri::XML::Element, nil] The local instrument element
      # @return [Hash, nil] The parsed local instrument or nil
      def parse_local_instrument(element)
        return nil unless element

        if element.at_xpath('./Cd')
          { code: element.at_xpath('./Cd')&.text }
        elsif element.at_xpath('./Prtry')
          { proprietary: element.at_xpath('./Prtry')&.text }
        end
      end

      # Parse the purpose element
      # @param element [Nokogiri::XML::Element, nil] The purpose element
      # @return [Hash, nil] The parsed purpose or nil
      def parse_purpose(element)
        return nil unless element

        if element.at_xpath('./Cd')
          { code: element.at_xpath('./Cd')&.text }
        elsif element.at_xpath('./Prtry')
          { proprietary: element.at_xpath('./Prtry')&.text }
        end
      end
    end
  end
end
