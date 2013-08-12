require 'spec_helper'

describe Reindeer do

  let(:instance) { example_class.new }

  context 'method availability' do
    let(:example_class) do
      Class.new { extend Reindeer }
    end

    it { class_has_a :before }
    it { class_has_a :after  }
    it { class_has_a :around }
  end

  describe :before do
    let(:example_class) do
      Class.new do
        extend Reindeer

        def frobinicate
        end

        before :frobinicate do
          @called_before = true
        end
      end
    end

    it 'executes before block for modified method' do
      expect {
        instance.frobinicate
        puts instance.send(:methods).sort
      }.to change { instance.instance_variable_get :@called_before }.to true
    end
  end

  describe :after do
  end

  describe :around do
  end
end
