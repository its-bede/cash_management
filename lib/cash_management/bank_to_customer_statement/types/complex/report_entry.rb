# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/complex/report_entry.rb
# rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
module CashManagement
  module BankToCustomerStatement
    # Represents a Report Entry (ReportEntry10) element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/ReportEntry10
    class ReportEntry
      attr_reader :entry_reference, :amount, :credit_debit_indicator, :reversal_indicator,
                  :status, :booking_date, :value_date, :account_servicer_reference,
                  :availability, :bank_transaction_code, :commission_waiver_indicator,
                  :additional_information_indicator, :amount_details, :charges,
                  :technical_input_channel, :interest, :card_transaction,
                  :entry_details, :additional_entry_information, :raw

      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @entry_reference = element.at_xpath("./NtryRef")&.text
        @amount = parse_amount(element.at_xpath("./Amt"))
        @credit_debit_indicator = element.at_xpath("./CdtDbtInd")&.text
        @reversal_indicator = element.at_xpath("./RvslInd")&.text == "true"
        @status = parse_status(element.at_xpath("./Sts"))
        @booking_date = parse_date(element.at_xpath("./BookgDt"))
        @value_date = parse_date(element.at_xpath("./ValDt"))
        @account_servicer_reference = element.at_xpath("./AcctSvcrRef")&.text
        @availability = element.xpath("./Avlbty").map { |avail| CashAvailability.new(avail) }
        @bank_transaction_code = parse_bank_transaction_code(element.at_xpath("./BkTxCd"))
        @commission_waiver_indicator = element.at_xpath("./ComssnWvrInd")&.text == "true"
        @additional_information_indicator = element.at_xpath("./AddtlInfInd") ? MessageIdentification.new(element.at_xpath("./AddtlInfInd")) : nil
        @amount_details = element.at_xpath("./AmtDtls") ? AmountAndCurrencyExchange.new(element.at_xpath("./AmtDtls")) : nil
        @charges = element.at_xpath("./Chrgs") ? Charges.new(element.at_xpath("./Chrgs")) : nil
        @technical_input_channel = parse_technical_input_channel(element.at_xpath("./TechInptChanl"))
        @interest = element.at_xpath("./Intrst") ? TransactionInterest.new(element.at_xpath("./Intrst")) : nil
        @card_transaction = element.at_xpath("./CardTx") ? CardEntry.new(element.at_xpath("./CardTx")) : nil
        @entry_details = element.xpath("./NtryDtls").map { |detail| EntryDetails.new(detail) }
        @additional_entry_information = element.at_xpath("./AddtlNtryInf")&.text
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse an amount
      # @param element [Nokogiri::XML::Element, nil] The amount element
      # @return [Hash, nil] The parsed amount or nil
      def parse_amount(element)
        return nil unless element

        {
          value: element.text&.to_f,
          currency: element.attribute("Ccy")&.value
        }
      end

      # Parse the status
      # @param element [Nokogiri::XML::Element, nil] The status element
      # @return [Hash, nil] The parsed status or nil
      def parse_status(element)
        return nil unless element

        if element.at_xpath("./Cd")
          { code: element.at_xpath("./Cd")&.text }
        elsif element.at_xpath("./Prtry")
          { proprietary: element.at_xpath("./Prtry")&.text }
        end
      end

      # Parse a date
      # @param element [Nokogiri::XML::Element, nil] The date element
      # @return [Hash, nil] The parsed date or nil
      def parse_date(element)
        return nil unless element

        if element.at_xpath("./Dt")
          { date: parse_iso_date(element.at_xpath("./Dt")&.text) }
        elsif element.at_xpath("./DtTm")
          { date_time: parse_datetime(element.at_xpath("./DtTm")&.text) }
        end
      end

      # Parse the bank transaction code
      # @param element [Nokogiri::XML::Element, nil] The bank transaction code element
      # @return [Hash, nil] The parsed bank transaction code or nil
      def parse_bank_transaction_code(element)
        return nil unless element

        result = {}

        if element.at_xpath("./Domn")
          domain = {}
          domain[:code] = element.at_xpath("./Domn/Cd")&.text

          if element.at_xpath("./Domn/Fmly")
            family = {}
            family[:code] = element.at_xpath("./Domn/Fmly/Cd")&.text
            family[:sub_family_code] = element.at_xpath("./Domn/Fmly/SubFmlyCd")&.text
            domain[:family] = family
          end

          result[:domain] = domain
        end

        if element.at_xpath("./Prtry")
          proprietary = {}
          proprietary[:code] = element.at_xpath("./Prtry/Cd")&.text
          proprietary[:issuer] = element.at_xpath("./Prtry/Issr")&.text
          result[:proprietary] = proprietary
        end

        result
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

      # Parse the technical input channel
      # @param element [Nokogiri::XML::Element, nil] The technical input channel element
      # @return [Hash, nil] The parsed technical input channel or nil
      def parse_technical_input_channel(element)
        return nil unless element

        if element.at_xpath("./Cd")
          { code: element.at_xpath("./Cd")&.text }
        elsif element.at_xpath("./Prtry")
          { proprietary: element.at_xpath("./Prtry")&.text }
        end
      end

      # Parse an ISO date string
      # @param date_str [String, nil] The date string
      # @return [Date, nil] The parsed date or nil
      def parse_iso_date(date_str)
        return nil unless date_str

        Date.iso8601(date_str)
      rescue ArgumentError
        date_str
      end

      # Parse an ISO datetime string
      # @param datetime_str [String, nil] The datetime string
      # @return [DateTime, nil] The parsed datetime or nil
      def parse_datetime(datetime_str)
        return nil unless datetime_str

        DateTime.iso8601(datetime_str)
      rescue ArgumentError
        datetime_str
      end
    end
  end
end
