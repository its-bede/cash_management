# frozen_string_literal: true

# lib/cash_management/bank_to_customer_statement/reader.rb

require "nokogiri"

module CashManagement
  # Namespace for the bank to customer statement module
  # Represents the bank to customer statement file
  # https://www.iso20022.org/standardsrepository/type/camt.053.001.08
  # @example Parse a camt.053.001.08 file
  #   reader = CashManagement::BankToCustomerStatement::Reader.new("statement.xml")
  #   doc = reader.parse
  #
  #   # Access document data
  #   doc.group_header.message_id                # => "STMT20220101001"
  #   doc.group_header.creation_date_time        # => 2022-01-01 12:00:00 UTC
  #
  #   # Access statement information
  #   doc.statements.each do |stmt|
  #     puts "Statement ID: #{stmt.id}"
  #     puts "Account: #{stmt.account.id[:iban]}"
  #
  #     # Access balance information
  #     stmt.balances.each do |balance|
  #       puts "Balance: #{balance.amount[:value]} #{balance.amount[:currency]}"
  #     end
  #   end
  # rubocop:disable Layout/LineLength, Metrics/AbcSize, Metrics/MethodLength
  module BankToCustomerStatement
    # Class to read and validate the bank to customer statement file against the bank to customer statement schema
    # The bank to customer statement file is an XML file.
    class Reader
      attr_reader :file_path, :xsd_path

      def initialize(file_path, options = {})
        @file_path = file_path.to_s
        version = options[:version] || :v8
        schema_file = "camt.053.001.#{version == :v8 ? "08" : "02"}.xsd"
        @xsd_path = Pathname(File.join(File.dirname(__FILE__), "schema", schema_file))
      end

      # Read the bank to customer statement file
      # @return [Nokogiri::XML::Document] The bank to customer statement file as a Nokogiri XML document
      # @raise [CashManagement::BankToCustomerStatement::Reader::ValidationError] If the bank to customer statement file is invalid
      def parse
        xsd = Nokogiri::XML::Schema(xsd_path.read)
        doc = Nokogiri::XML(Pathname(file_path).read)

        errors = xsd.validate(doc)
        if errors.any?
          raise ValidationError, format_errors(errors) if CashManagement.config.strict_parsing

          CashManagement.config.logger.error("#{errors.count} errors found in the file:")
          CashManagement.config.logger.error(format_errors(errors))
        end

        doc.remove_namespaces!
        build_document(doc.document)
      rescue Nokogiri::XML::SyntaxError => e
        raise ValidationError, e.message
      rescue Errno::ENOENT
        raise ValidationError, "File not found: #{e.message}"
      end

      # Parse a camt.053.001.08 file
      # @param file_path [String] Path to the XML file
      # @return [BankToCustomerStatement] Parsed statement
      def self.parse(file_path, *options)
        new(file_path, *options).parse
      end

      private

      def build_document(doc)
        # Check if the required elements exist before creating the document
        statement_node = doc.at_xpath("//Document/BkToCstmrStmt")

        raise ValidationError, "Invalid document structure: Missing BkToCstmrStmt element" if statement_node.nil?

        statement = BankToCustomerStatement.new(statement_node)

        # Safely access message_id with proper nil checking
        message_id = statement.group_header&.message_id || "unknown"
        CashManagement.config.logger.info("Successfully parsed statement with ID: #{message_id}")

        Document.new(doc)
      rescue NoMethodError => e
        CashManagement.config.logger.error("Error parsing document structure: #{e.message}")
        raise ValidationError, "Invalid document structure: #{e.message}"
      rescue StandardError => e
        CashManagement.config.logger.error("Unexpected error parsing document: #{e.message}")
        raise
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
# rubocop:enable Layout/LineLength, Metrics/AbcSize, Metrics/MethodLength
