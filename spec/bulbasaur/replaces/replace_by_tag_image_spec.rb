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
        "<p>Lorem inpsu</p>
        <img src='test-0.jpg' alt='hello'>
        <img src='test-1.jpg' alt='hello'>
        <img src='test-1.jpg' alt='hello'>
        <img src='test-3.jpg' alt='hello'>
        <img src='test-2.jpg' alt='hello'>".gsub(/\n/," ")
      end

      let(:image_replaces) do
        [
         {original_image_url:"test-0.jpg", url: "new-image-0.png"}, 
         {original_image_url:"test-1.jpg", url: "new-image-1.png"},
         {original_image_url:"test-2.jpg", url: "new-image-2.png"}
        ]
      end

      it "Does return html parsed" do
        expect(subject).to eq(
        '<p>Lorem inpsu</p>
        <img src="new-image-0.png" alt="hello">
        <img src="new-image-1.png" alt="hello">
        <img src="new-image-1.png" alt="hello">
        <img src="test-3.jpg" alt="hello">
        <img src="new-image-2.png" alt="hello">'.gsub(/\n/," "))
      end
    end

  end

end
