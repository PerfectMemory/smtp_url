# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "smtp_url/version"

Gem::Specification.new do |s|
  s.name        = "smtp_url"
  s.version     = SmtpURL::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Daniel Farrell"]
  s.email       = ["danielfarrell76@gmail.com"]
  s.homepage    = "https://github.com/danielfarrell/smtp_url"
  s.summary     = %q{Convert an smtp url into mail/action mailer friendly hashes}
  s.description = %q{Allows smtp settings to be defined as URL in environment variable, then converted to hash for use in Mail/ActionMailer}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 3.2"
  s.add_dependency('activesupport')
end
