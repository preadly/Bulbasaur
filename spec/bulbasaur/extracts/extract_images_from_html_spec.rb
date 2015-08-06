require "spec_helper"

RSpec.describe Bulbasaur::ExtractImagesFromHTML do

  subject do
    described_class.new(html).call
  end

  describe "#call" do
    
    context "When send html without images" do
    
      let(:html) do
        "<p>Hello world</p>"
      end

      it "Does return nil object" do
        expect(subject.size).to be_zero
      end
    end

    context "When send html with a image tag" do
      
      let(:html) do
        "<p>Hello world</p>
        <img src='image-name.jpg' alt='image alt test' />"
      end

      it "Does return a image array with 1 item" do
        expect(subject.size).to eq 1
      end

      it "Does return the image url" do
        expect(subject.first[:url]).to eq "image-name.jpg"
      end

      it "Does return the image alt" do
        expect(subject.first[:alt]).to eq "image alt test"
      end
    end
    
    context "When send html with a image style inline" do
      
      let(:html) do
        "<p>Hello world</p>
        <div style='backgroung-image: url(inline-image.jpg)'>
          hello Ruby
        </div>"
      end

      it "Does return a image array with 1 item" do
        expect(subject.size).to eq 1
      end

      it "Does return the image url" do
        expect(subject.first[:url]).to eq "inline-image.jpg"
      end

      it "Does return the image alt" do
        expect(subject.first[:alt]).to be_nil
      end
    end

    context 'When sending HTML with a link pointing to an image' do
      let(:html) do
        '<p>
          <a href="http://somewhere.to/get/the_original_image.jpg">
            Click here to see the original image.
          </a>
          <a href="http://somewhere.to/get/the_original_image.jpg?width=400&height=400">
            Click here to see the original image.
          </a>
          <a href="http://somewhere.to/get/the_original_image.jpg~original">
            Click here to see the original image.
          </a>
          <a href="http://somewhere.to/get/The_Original_Image%C3%A7a_3.JPG">
            Click here to see the original image.
          </a>
          <a href="http://somewhere.to/go/to/another_page.html">
            Click here to go to another page.
          </a>
          <a href="http://somewhere.to/get/the_original_image.jpg.exe">
            Click here to get a virus.
          </a>
        </p>'
      end

      it 'Does return an image array with 4 items' do
        expect(subject.size).to eq 4
      end

      it 'Does return the image URL with parameters' do
        expect(subject).to include Hash url: 'http://somewhere.to/get/the_original_image.jpg?width=400&height=400', alt: nil
      end

      it 'Does return the image URL without parameters' do
        expect(subject).to include Hash url: 'http://somewhere.to/get/the_original_image.jpg', alt: nil
      end

      it 'Does return the image URL with tilde parameters' do
        expect(subject).to include Hash url: 'http://somewhere.to/get/the_original_image.jpg~original', alt: nil
      end

      it 'Does return the image URL with upcased and special characters' do
        expect(subject).to include Hash url: 'http://somewhere.to/get/The_Original_Image%C3%A7a_3.JPG', alt: nil
      end

      it 'Does return the image alt' do
        expect(subject.first[:alt]).to be_nil
      end

      it 'Does not include links other than for images' do
        expect(subject).not_to include Hash url: 'http://somewhere.to/get/the_original_image.jpg.exe', alt: nil
        expect(subject).not_to include Hash url: 'http://somewhere.to/go/to/another_page.html', alt: nil
      end
    end
    
    context "When send html with many images" do
      
      let(:html) do
        "<p>Hello world</p>
        <img src='image-0.jpg' alt='image-0' />
        <img src='image-1.png' alt='image-1' />
        <div style='backgroung-image: url(image-2.jpg)'>
          hello Ruby
          <img src='image-3.png' alt='image-3' />
        </div>
        <div style='background: url(image-4.png)'></div> 
        <img src='image-5.png' alt='image-5' />"
      end

      it "Does return a image array with 6 items" do
        expect(subject.size).to eq 6
      end

      it "Does return the image url of 6 itens" do
        expect(subject.map { |item| item[:url] }).to include "image-0.jpg", "image-1.png", "image-2.jpg", "image-3.png", "image-4.png", "image-5.png"
      end

      it "Does return the image alt of 4 itens" do
        expect(subject.map { |item| item[:alt] }).to include "image-0", "image-1", "image-3", "image-5"
      end
    end
  end
end
