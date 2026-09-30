require 'rspec'
require 'rails'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.mock_with(:rspec) { |c| c.syntax = :expect }
  config.disable_monkey_patching!
  config.raise_errors_for_deprecations!
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
