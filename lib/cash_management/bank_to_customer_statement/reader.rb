# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/reader.rb

require 'nokogiri'

module CashManagement
  # Namespace for the bank to customer statement module
  # Represents the bank to customer statement file
  # https://www.iso20022.org/standardsrepository/type/camt.053.001.08
  module BankToCustomerStatement
    # Class to read and validate the bank to customer statement file against the bank to customer statement schema
    # The bank to customer statement file is an XML file.
    class Reader

      attr_reader :file_path, :xsd_path

      def initialize(file_path)
        @file_path = file_path.to_s
        @xsd_path = Pathname(File.join(File.dirname(__FILE__), 'schema', 'camt.053.001.08.xsd'))
      end

      # Read the bank to customer statement file
      # @return [Nokogiri::XML::Document] The bank to customer statement file as a Nokogiri XML document
      # @raise [CashManagement::BankToCustomerStatement::Reader::ValidationError] If the bank to customer statement file is invalid
      def read
        xsd = Nokogiri::XML::Schema(xsd_path.read)
        doc = Nokogiri::XML(Pathname(file_path).read)

        errors = xsd.validate(doc)

        raise ValidationError, format_errors(errors) if errors.any?

        doc.remove_namespaces!
        build_document(doc.document)
      rescue Nokogiri::XML::SyntaxError => e
        raise ValidationError, e.message
      rescue Errno::ENOENT
        raise ValidationError, "File not found: #{e.message}"
      end

      private

      def build_document(doc)
        Document.new(doc)
      end

      # Format the errors
      # @param errors [Array<Nokogiri::XML::SyntaxError>] The errors
      # @return [String] The formatted errors
      def format_errors(errors)
        errors.map do |error|
          "Line #{error.line}: #{error.message}"
        end.join("\n")
      end
    end
  end
end