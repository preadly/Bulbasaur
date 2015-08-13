require 'spec_helper'

RSpec.describe Bulbasaur::NormalizeImageSources do
  
  subject do
    described_class.new(html, target_attrs).call
  end

  describe "#call" do
    
    let(:html) do 
      %Q(
        <img src="http://somewhere.to/get/a-pixel.gif" data-lazy-src="http://somewhere.to/get/the-real-image.jpg" alt="Image" width="800" height="1200">
        <img src="http://somewhere.to/get/another-pixel.gif" data-image="http://somewhere.to/get/the-other-real-image.jpg">
        <img src="http://somewhere.to/get/a-third-pixel.gif" data-src="get/the-third-real-image.jpg">
        <img src="otherplace.to/load/a-fourth-pixel.gif" lazy-data="otherplace.to/load/the-fourth-real-image.jpg">
        )
    end
    
    context "When there are no target attributes" do
      
      let(:target_attrs) do 
        []
      end

      it "Returns the HTML code as it was before" do
        expect(subject).to eq html
      end
    end

    context "When there are target attributes" do
      
      let(:target_attrs) do
        %w(data-lazy-src data-image)
      end
    
      let(:html_parsed) do
        %Q(
          <img src="http://somewhere.to/get/the-real-image.jpg" alt="Image" width="800" height="1200">
          <img src="http://somewhere.to/get/the-other-real-image.jpg">
          <img src="http://somewhere.to/get/a-third-pixel.gif" data-src="get/the-third-real-image.jpg">
          <img src="otherplace.to/load/a-fourth-pixel.gif" lazy-data="otherplace.to/load/the-fourth-real-image.jpg">
          )
      end

      it "Returns the HTML code with the specified image tags adjusted" do
        expect(subject.delete(" ")).to eq html_parsed.delete(" ")
      end
    end

    context "When there are target attributes with relative path" do
      
      let(:target_attrs) do
        %w(data-lazy-src data-image data-src lazy-data)
      end
    
      let(:html_parsed) do
        %Q(
          <img src="http://somewhere.to/get/the-real-image.jpg" alt="Image" width="800" height="1200">
          <img src="http://somewhere.to/get/the-other-real-image.jpg">
          <img src="http://somewhere.to/get/the-third-real-image.jpg">
          <img src="otherplace.to/load/the-fourth-real-image.jpg">
        )
      end

      it "Returns the HTML code with the involved image tags fixed with domain and path" do
        expect(subject.delete(" ")).to eq html_parsed.delete(" ")
      end
    end
  end

end
