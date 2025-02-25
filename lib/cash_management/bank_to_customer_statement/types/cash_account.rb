# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/cash_account.rb

module CashManagement
  module BankToCustomerStatement
    # Represents a Cash Account (CashAccount39 or CashAccount38) element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/CashAccount39
    # @see https://www.iso20022.org/standardsrepository/type/CashAccount38
    class CashAccount
      attr_reader :id, :type, :currency, :name, :proxy, :owner, :servicer, :raw

      # @param element [Nokogiri::XML::Element] The XML element to parse
      # @param account_type [Symbol] :cash_account39 or :cash_account38
      def initialize(element, account_type = :cash_account39)
        @id = parse_account_id(element.at_xpath('./Id'))
        @type = parse_account_type(element.at_xpath('./Tp'))
        @currency = element.at_xpath('./Ccy')&.text
        @name = element.at_xpath('./Nm')&.text
        @proxy = element.at_xpath('./Prxy') ? ProxyAccountIdentification.new(element.at_xpath('./Prxy')) : nil

        # These fields are only in CashAccount39, not in CashAccount38
        if account_type == :cash_account39
          @owner = element.at_xpath('./Ownr') ? PartyIdentification.new(element.at_xpath('./Ownr')) : nil
          @servicer = element.at_xpath('./Svcr') ? BranchAndFinancialInstitutionIdentification.new(element.at_xpath('./Svcr')) : nil
        end

        @raw = element.to_s
      end

      private

      # Parse the account identification
      # @param element [Nokogiri::XML::Element, nil] The account ID element
      # @return [Hash, nil] The parsed account ID or nil
      def parse_account_id(element)
        return nil unless element

        if element.at_xpath('./IBAN')
          { iban: element.at_xpath('./IBAN')&.text }
        elsif element.at_xpath('./Othr')
          { other: {
            id: element.at_xpath('./Othr/Id')&.text,
            scheme_name: parse_scheme_name(element.at_xpath('./Othr/SchmeNm')),
            issuer: element.at_xpath('./Othr/Issr')&.text
          }}
        end
      end

      # Parse the account type
      # @param element [Nokogiri::XML::Element, nil] The account type element
      # @return [Hash, nil] The parsed account type or nil
      def parse_account_type(element)
        return nil unless element

        if element.at_xpath('./Cd')
          { code: element.at_xpath('./Cd')&.text }
        elsif element.at_xpath('./Prtry')
          { proprietary: element.at_xpath('./Prtry')&.text }
        end
      end

      # Parse the scheme name
      # @param element [Nokogiri::XML::Element, nil] The scheme name element
      # @return [Hash, nil] The parsed scheme name or nil
      def parse_scheme_name(element)
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
