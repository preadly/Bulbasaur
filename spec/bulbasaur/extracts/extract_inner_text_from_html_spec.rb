require "spec_helper"

RSpec.describe Bulbasaur::ExtractInnerTextFromHTML do

  subject do
    described_class.new(html).call
  end

  describe "#call" do
    
    context "When simple paragraph html" do
    
      let(:html) do
        "<p>Hello Preadly</p>"
      end

      it "Does return text 'Hello Preadly'" do
        expect(subject).to eq "Hello Preadly"
      end
    end

    context "When use complexy html" do

      let(:html) do
        "<p><p>Hello Preadly</p><img src='test.jpg' alt='hello' > <span>welcome</span></p>"
      end

      it "Does return only text inner master paragraph" do
        expect(subject).to eq "Hello Preadly welcome"
      end
    end
  end
end
