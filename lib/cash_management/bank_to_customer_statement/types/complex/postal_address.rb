# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/types/postal_address.rb

module CashManagement
  module BankToCustomerStatement
    # Represents the PostalAddress24 element in a camt.053.001.08 message
    # @see https://www.iso20022.org/standardsrepository/type/PostalAddress24
    class PostalAddress
      attr_reader :address_type, :department, :sub_department, :street_name, :building_number,
                  :building_name, :floor, :post_box, :room, :post_code, :town_name,
                  :town_location_name, :district_name, :country_sub_division,
                  :country, :address_lines, :raw

      # Initialize a new PostalAddress instance from an XML element
      # @param element [Nokogiri::XML::Element] The XML element to parse
      def initialize(element)
        @address_type = parse_address_type(element.at_xpath("./AdrTp"))
        @department = element.at_xpath("./Dept")&.text
        @sub_department = element.at_xpath("./SubDept")&.text
        @street_name = element.at_xpath("./StrtNm")&.text
        @building_number = element.at_xpath("./BldgNb")&.text
        @building_name = element.at_xpath("./BldgNm")&.text
        @floor = element.at_xpath("./Flr")&.text
        @post_box = element.at_xpath("./PstBx")&.text
        @room = element.at_xpath("./Room")&.text
        @post_code = element.at_xpath("./PstCd")&.text
        @town_name = element.at_xpath("./TwnNm")&.text
        @town_location_name = element.at_xpath("./TwnLctnNm")&.text
        @district_name = element.at_xpath("./DstrctNm")&.text
        @country_sub_division = element.at_xpath("./CtrySubDvsn")&.text
        @country = element.at_xpath("./Ctry")&.text
        @address_lines = element.xpath("./AdrLine").map(&:text)
        @raw = element.to_s if CashManagement.config.keep_raw_xml
      end

      private

      # Parse the address type element
      # @param element [Nokogiri::XML::Element, nil] The address type element
      # @return [Hash, nil] The parsed address type or nil
      def parse_address_type(element)
        return nil unless element

        if element.at_xpath("./Cd")
          { code: element.at_xpath("./Cd")&.text }
        elsif element.at_xpath("./Prtry")
          { proprietary: parse_generic_identification(element.at_xpath("./Prtry")) }
        end
      end

      # Parse a generic identification element
      # @param element [Nokogiri::XML::Element, nil] The generic identification element
      # @return [Hash, nil] The parsed generic identification or nil
      def parse_generic_identification(element)
        return nil unless element

        {
          id: element.at_xpath("./Id")&.text,
          issuer: element.at_xpath("./Issr")&.text,
          scheme_name: element.at_xpath("./SchmeNm")&.text
        }
      end
    end
  end
end
