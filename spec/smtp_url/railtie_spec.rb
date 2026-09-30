require 'spec_helper'
require 'smtp_url/railtie'

RSpec.describe SmtpURL::Railtie do
  let(:action_mailer) { double('action_mailer').as_null_object }
  let(:logger) { instance_double(Logger, warn: nil) }

  # run_initializers runs them only once per railtie: run them directly instead
  def run_initializers
    SmtpURL::Railtie.instance.initializers.each(&:run)
  end

  before do
    allow_any_instance_of(Rails::Railtie::Configuration).to receive(:action_mailer).and_return(action_mailer)
    allow(Rails).to receive(:logger).and_return(logger)
  end

  around do |example|
    smtp_url = ENV['SMTP_URL']
    example.run
  ensure
    ENV['SMTP_URL'] = smtp_url
  end

  context 'with SMTP_URL defined' do
    before { ENV['SMTP_URL'] = 'smtp://localhost:1025' }

    it 'should setup action_mailer settings when SMTP_URL is set' do
      expect(action_mailer).to receive(:delivery_method=).with(:smtp)
      expect(action_mailer).to receive(:smtp_settings=).with({ address: 'localhost', port: 1025 })
      run_initializers
    end
  end

  context 'without SMTP_URL defined' do
    before { ENV.delete('SMTP_URL') }

    it 'should log a warning if SMTP_URL is not set' do
      expect(logger).to receive(:warn).with('SmtpURL did not setup your email delivery because the SMTP_URL env var was missing')
      run_initializers
    end
  end
end
