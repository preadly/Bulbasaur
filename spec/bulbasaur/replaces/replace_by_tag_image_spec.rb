require "spec_helper"

RSpec.describe Bulbasaur::ReplaceByTagImage do

  subject do
    described_class.new(html, image_replaces).call
  end

  describe "#call" do

    context "When there is not tag img" do

      let(:html) do
        "<p>Hello</p><div> Welcome </div>"
      end
      
      let(:image_replaces) do
        [{original_image_url:"test.jpg", url: "new-image.png"}]
      end

      it "Does return html" do
        expect(subject).to eq "<p>Hello</p><div> Welcome </div>"
      end
    end

    context "When there are many img tags" do

      let(:html) do
        "<p>Lorem inpsu</p><img src='test.jpg' alt='hello' />"
      end

      let(:image_replaces) do
        [{original_image_url:"test.jpg", url: "new-image.png"}]
      end

      it "Does return html parsed" do
        expect(subject).to eq "<p>Lorem inpsu</p><img src=\"new-image.png\" alt=\"hello\">"
      end
    end

  end

end
