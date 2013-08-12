require 'spec_helper'

describe Reindeer do

  let(:example) { Class.new { extend Reindeer } }

  it 'can be extended' do
    expect { example }.to_not raise_error
  end

  context 'when extended' do
    it 'provides a has class method' do
      expect(example.methods).to include(:has)
    end
  end
end
