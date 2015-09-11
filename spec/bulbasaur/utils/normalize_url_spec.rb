require "spec_helper"

RSpec.describe Bulbasaur::NormalizeURL do

  subject do
    described_class.new(base_url, context_url).call
  end

  let(:base_url) do
    "http://pread.ly"
  end

  let(:context_url) do
    "http://www.test.com/hello.jpg"
  end

  describe "#call" do

    context "When use url normalized url: http://www.test.com/hello.jpg" do

      it "Does return url normalized: http://www.test.com/hello.jpg" do
        expect(subject).to eq "http://www.test.com/hello.jpg"
      end
    end

    context "When use url unnormalized url: test.jpg" do

      let(:context_url) do
        "test.jpg"
      end

      it "Does return url normalized: http://pread.ly/test.jpg" do
        expect(subject).to eq "http://pread.ly/test.jpg"
      end
    end

    context "When use url https normalized: https://www.test.com/hello.jpg" do

      let(:context_url) do
        "https://www.test.com/hello.jpg"
      end

      it "Does return url https normalized: https://www.test.com/hello.jpg" do
        expect(subject).to eq "https://www.test.com/hello.jpg"
      end
    end

    context 'When using an encoded URL' do
      let(:context_url) { 'http://www.test.com/Hello%C3%A7a_9.jpg~original' }

      it 'returns the normalized URL' do
        expect(subject).to eq 'http://www.test.com/Hello%C3%A7a_9.jpg~original'
      end
    end

    context "When use url not normalized with slash on base: hello.jpg" do

      let(:base_url) do
        "https://www.test.com/"
      end

      let(:context_url) do
        "hello.jpg"
      end

      it "Does return url normalized: https://www.test.com/hello.jpg" do
        expect(subject).to eq "https://www.test.com/hello.jpg"
      end
    end

    context "When base_url contains path" do
      let!(:base_url) do
        "http://pread.ly/other-path/"
      end

      let!(:context_url) do
        "test.jpg"
      end

      it "Does return url normalized: http://pread.ly/test.jpg" do
        expect(subject).to eq "http://pread.ly/test.jpg"
      end
    end

    context "When base_url contains query string" do
      let!(:base_url) do
        "http://pread.ly/?page=1"
      end

      let!(:context_url) do
        "test.jpg"
      end

      it "Does return url normalized: http://pread.ly/test.jpg" do
        expect(subject).to eq "http://pread.ly/test.jpg"
      end
    end

    context "When base url not valid" do

      let(:base_url) do
        "test/httml"
      end

      let(:context_url) do
        "hello.html"
      end

      it "Does throws exception argument error" do
        expect{subject}.to raise_error ArgumentError
      end
    end

  end
end
