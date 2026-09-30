require 'spec_helper'
require 'smtp_url/invalid_url_exception'
require 'smtp_url/parser'

RSpec.describe SmtpURL::Parser, '#parse' do
  it "should set port to 25 is not in url" do
    url = "smtp://test.com"
    settings = SmtpURL::Parser.new(url).parse
    expect(settings[:port]).to eq(25)
  end

  it "should allow setting port" do
    url = "smtp://test.com:587"
    settings = SmtpURL::Parser.new(url).parse
    expect(settings[:port]).to eq(587)
  end

  it "should handle urls without authentication" do
    url = "smtp://test.com"
    settings = SmtpURL::Parser.new(url).parse
    expect(settings[:address]).to eq('test.com')
    expect(settings[:user_name]).to eq(nil)
    expect(settings[:password]).to eq(nil)
  end

  it "should handle urls with authentication" do
    url = "smtp://user:secret@test.com"
    settings = SmtpURL::Parser.new(url).parse
    expect(settings[:address]).to eq('test.com')
    expect(settings[:user_name]).to eq('user')
    expect(settings[:password]).to eq('secret')
  end

  it "should parse domain from query params" do
    url = "smtp://test.com/?domain=test2.com"
    settings = SmtpURL::Parser.new(url).parse
    expect(settings[:domain]).to eq('test2.com')
  end

  it "should parse authentication from query params" do
    url = "smtp://user:secret@test.com/?authentication=digest"
    settings = SmtpURL::Parser.new(url).parse
    expect(settings[:user_name]).to eq('user')
    expect(settings[:password]).to eq('secret')
    expect(settings[:authentication]).to eq(:digest)
  end

  it "should raise InvalidUriException for invalid url" do
    url = "just a string of stuff"
    expect { SmtpURL::Parser.new(url).parse }.to raise_error(SmtpURL::InvalidUrlException, "Could not parse SMTP_URL env var")
  end

  it "should raise InvalidUriException if url is not smtp" do
    url = "http://test.com"
    expect { SmtpURL::Parser.new(url).parse }.to raise_error(SmtpURL::InvalidUrlException, "Improper format of SMTP_URL env var, must be smtp://")
  end
end
