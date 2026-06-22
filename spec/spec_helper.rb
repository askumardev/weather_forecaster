# frozen_string_literal: true

require 'rspec/expectations'

RSpec.configure do |config|
  config.example_status_persistence_file_path = "./spec/examples.txt"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.max_formatted_output_length = nil
  end
end
