require "spec_helper"

RSpec.describe Bulbasaur::NormalizeImageSrcSet do

  subject do
    described_class.new(html).call
  end

  describe "#call" do
    
    context "When there are no srcset attribute" do
    
      let(:html) do
        <<-HTML
        <img src="http://somewhere.to/get/a-pixel.gif" data-lazy-src="http://somewhere.to/get/the-real-image.jpg" alt="Image" width="800" height="1200">
        <img lazy-data="https://place.where/an-image/has/no-src-tag.jpg">
        HTML
      end
    
      it "Does returns the HTML code as it was before" do
        expect(subject).to eq(html)
      end 
    end
    
    context "When there are srcset attribute without size defined" do
    
      let(:html) do
        <<-HTML
        <img src="http://somewhere.to/get/a-pixel.gif" srcset="http://bulbasaur.com/imageA.jpg" alt="Image" width="800" height="1200">
        <img srcset="http://bulbasaur.com/imageB.jpg">
        <img srcset="http://bulbasaur.com/imageC.jpg,http://bulbasaur.com/imageC.jpg,http://bulbasaur.com/imageD.jpg">
        HTML
      end
      
      let(:html_normalized) do
        <<-HTML
        <img src="http://bulbasaur.com/imageA.jpg" srcset="http://bulbasaur.com/imageA.jpg" alt="Image" width="800" height="1200">
        <img srcset="http://bulbasaur.com/imageB.jpg" src="http://bulbasaur.com/imageB.jpg">
        <img srcset="http://bulbasaur.com/imageC.jpg,http://bulbasaur.com/imageC.jpg,http://bulbasaur.com/imageD.jpg" src="http://bulbasaur.com/imageC.jpg">
        HTML
      end
    
      it "Does returns the HTML code with src replaced by srcset attribute" do
        expect(subject).to eq(html_normalized)
      end
    end
    
    context "When there are srcset attribute with size defined" do
    
      let(:html) do
        <<-HTML
        <img src="http://somewhere.to/get/a-pixel.gif" srcset="http://bulbasaur.com/imageA.jpg 100w" alt="Image" width="800" height="1200">
        <img srcset="http://bulbasaur.com/imageB.jpg 200w">
        <img srcset="http://bulbasaur.com/imageB.jpg 200h">
        <img srcset="http://bulbasaur.com/imageB.jpg 20w 30h">
        <img srcset="http://bulbasaur.com/imageB.jpg 2x">
        <img srcset="http://bulbasaur.com/imageB.jpg 200W 100H">
        <img srcset="http://bulbasaur.com/imageC.jpg 100w,http://bulbasaur.com/imageC.jpg 200w,http://bulbasaur.com/imageD.jpg 300w">
        HTML
      end
      
      let(:html_normalized) do
        <<-HTML
        <img src="http://bulbasaur.com/imageA.jpg" srcset="http://bulbasaur.com/imageA.jpg 100w" alt="Image" width="100" height="1200">
        <img srcset="http://bulbasaur.com/imageB.jpg 200w" src="http://bulbasaur.com/imageB.jpg" width="200">
        <img srcset="http://bulbasaur.com/imageB.jpg 200h" src="http://bulbasaur.com/imageB.jpg" height="200">
        <img srcset="http://bulbasaur.com/imageB.jpg 20w 30h" src="http://bulbasaur.com/imageB.jpg" width="20" height="30">
        <img srcset="http://bulbasaur.com/imageB.jpg 2x" src="http://bulbasaur.com/imageB.jpg">
        <img srcset="http://bulbasaur.com/imageB.jpg 200W 100H" src="http://bulbasaur.com/imageB.jpg" width="200" height="100">
        <img srcset="http://bulbasaur.com/imageC.jpg 100w,http://bulbasaur.com/imageC.jpg 200w,http://bulbasaur.com/imageD.jpg 300w" src="http://bulbasaur.com/imageD.jpg" width="300">
        HTML
      end
    
      it "Does return the HTML code with src and with definitions" do
        expect(subject).to eq(html_normalized)
      end
    end
    
    context "When there are no valid params on srcset" do
      
      let(:html) do
        <<-HTML
        <img srcset="http://bulbasaur.com/imageA.jpg 100w 200H 12h asd hausd  uahsd 12813nusda" alt="Image">
        <img srcset="http://bulbasaur.com/imageB.jpg 200w 1x 10x">
        <img srcset="http://bulbasaur.com/imageC.jpg 100w 50h,http://bulbasaur.com/imageC.jpg 600w 500h,http://bulbasaur.com/imageD.jpg 300w 400h">
        HTML
      end
    
      let(:html_normalized) do
        <<-HTML
        <img srcset="http://bulbasaur.com/imageA.jpg 100w 200H 12h asd hausd  uahsd 12813nusda" alt="Image" src="http://bulbasaur.com/imageA.jpg" width="100" height="200">
        <img srcset="http://bulbasaur.com/imageB.jpg 200w 1x 10x" src="http://bulbasaur.com/imageB.jpg" width="200">
        <img srcset="http://bulbasaur.com/imageC.jpg 100w 50h,http://bulbasaur.com/imageC.jpg 600w 500h,http://bulbasaur.com/imageD.jpg 300w 400h" src="http://bulbasaur.com/imageC.jpg" width="600" height="500">
        HTML
      end
      
      it "Does returns the HTML code and ignores invalid params" do
        expect(subject).to eq(html_normalized)
      end
    end
    
    context "When there are diferents sizes to the same image" do
      
      let(:html) do
        <<-HTML
        <img srcset="http://bulbasaur.com/imageC.jpg 100w 50h,http://bulbasaur.com/imageC.jpg 200w 300h,http://bulbasaur.com/imageD.jpg 300w 400h">
        HTML
      end
      
      let(:html_normalized_) do
        <<-HTML
        <img srcset="http://bulbasaur.com/imageC.jpg 100w 50h,http://bulbasaur.com/imageC.jpg 200w 300h,http://bulbasaur.com/imageD.jpg 300w 400h" src="http://bulbasaur.com/imageD.jpg" width="300" height="400">
        HTML
      end
      
      it "Does returns the HTML code with better image" do
        expect(subject).to eq(html_normalized_)
      end
    end
    
  end
end
