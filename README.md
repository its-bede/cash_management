# CashManagement

A Ruby gem for parsing ISO 20022 camt.053.001.08 bank statement files (Bank-to-Customer Statement).

This gem provides a comprehensive parser for camt.053.001.08 XML files, allowing you to easily extract and work with bank statement data in your Ruby applications.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add cash_management
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install cash_management
```

## Usage

### Basic Usage

```ruby
require 'cash_management'

# Parse a camt.053.001.08 file
file_path = 'path/to/camt.053.001.08.xml'
statement = CashManagement::BankToCustomerStatement.parse(file_path)

# Access statement data
statement.group_header.message_id                # => "STMT20220101001"
statement.group_header.creation_date_time        # => 2022-01-01 12:00:00 UTC

# Access statement information
statement.statements.each do |stmt|
  puts "Statement ID: #{stmt.id}"
  puts "Account: #{stmt.account.id[:iban]}"
  
  # Access balance information
  stmt.balances.each do |balance|
    puts "Balance type: #{balance.type[:code_or_proprietary][:code]}"
    puts "Amount: #{balance.amount[:value]} #{balance.amount[:currency]}"
    puts "Credit/Debit: #{balance.credit_debit_indicator}"
  end
  
  # Access transaction entries
  stmt.entries.each do |entry|
    puts "Entry reference: #{entry.entry_reference}"
    puts "Amount: #{entry.amount[:value]} #{entry.amount[:currency]}"
    puts "Credit/Debit: #{entry.credit_debit_indicator}"
    
    # Access transaction details
    entry.entry_details.each do |detail|
      detail.transactions.each do |tx|
        puts "Transaction reference: #{tx.references.account_servicer_reference}"
        puts "Transaction amount: #{tx.amount[:value]} #{tx.amount[:currency]}"
        puts "Transaction details: #{tx.details.unstructured}"
      end
    end
  end
end
```

### Configuration

You can configure the gem to suit your needs:

```ruby
# Manual configuration
CashManagement.configure do |config|
  # Whether to raise errors on missing required elements or invalid values
  config.strict_parsing = false
  
  # Keep the raw XML for each parsed element
  config.keep_raw_xml = true
  
  # Set custom logger
  config.logger = Rails.logger
end
```

### Rails Integration

For Rails applications, you can use the included generator to create a default configuration file:

```bash
rails generate cash_management:install
```

This will create a configuration file at `config/initializers/cash_management.rb` that automatically uses your Rails application's logger.

In a Rails application, you might want to create a service to handle statement imports:

```ruby
# app/services/statement_import_service.rb
class StatementImportService
  def self.import(file_path)
    statement = CashManagement::BankToCustomerStatement.parse(file_path)
    
    # Process the statement data and save to your database
    # ...
    
    statement
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/your-username/cash_management. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/your-username/cash_management/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CashManagement project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/your-username/cash_management/blob/main/CODE_OF_CONDUCT.md).
