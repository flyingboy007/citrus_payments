require_relative '../spec_helper'

describe CitrusPayments::Configuration do
  context 'with configuration block' do
    it 'returns the correct citrus vanity_url' do
      expect(CitrusPayments.configuration.vanity_url).to eq(ENV['CITRUS_VANITY_URL'])
    end
    it 'returns the correct citrus base_url' do
      expect(CitrusPayments.configuration.base_url).to eq(ENV['CITRUS_BASE_URL'])
    end
    it 'returns the correct citrus access_key' do
      expect(CitrusPayments.configuration.access_key).to eq(ENV['CITRUS_ACCESS_KEY'])
    end
    it 'returns the correct citrus secret_key' do
      expect(CitrusPayments.configuration.secret_key).to eq(ENV['CITRUS_SECRET_KEY'])
    end
  end

  context '#reset' do
    it 'resets configured values' do
      expect(CitrusPayments.configuration.access_key).to eq(ENV['CITRUS_ACCESS_KEY'])
      expect(CitrusPayments.configuration.secret_key).to eq(ENV['CITRUS_SECRET_KEY'])

      CitrusPayments.reset
      expect { CitrusPayments.configuration.access_key }.to raise_error(CitrusPayments::Errors::Configuration)
      expect { CitrusPayments.configuration.secret_key }.to raise_error(CitrusPayments::Errors::Configuration)
    end
  end

  context 'without configuration block' do
    before do
      CitrusPayments.reset
    end

    it 'raises a configuration error for access_key' do
      expect { CitrusPayments.configuration.access_key }.to raise_error(CitrusPayments::Errors::Configuration)
    end

    it 'raises a configuration error for secret_key' do
      expect { CitrusPayments.configuration.secret_key }.to raise_error(CitrusPayments::Errors::Configuration)
    end
  end


end