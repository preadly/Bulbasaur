require 'spec_helper'

RSpec.describe Bulbasaur::ExtractImagesFromYoutube do

  subject do
    described_class.new(html).call
  end

  describe "#call" do
    
    context "When there is not youtube images" do
    
      let(:html) do
        "<p>Lorem ipsum dolor sit amet</p>"
      end

      it "Does return empty array" do
        expect(subject.size).to be_zero 
      end
    end

    context "When has one youtube video" do

      let(:html) do
        %Q(<iframe width="560" height="315" src="https://www.youtube.com/embed/123idfake321" frameborder="0" allowfullscreen></iframe>)
      end

      it "Does return array with 1 image" do
        expect(subject.size).to eq 1
      end

      it "Does return youtube url" do
        expect(subject.first[:url]).to eq "http://img.youtube.com/vi/123idfake321/maxresdefault.jpg"
      end
      
      it "Does return youtube url fallback" do
        expect(subject.first[:url_fallback]).to eq "http://img.youtube.com/vi/123idfake321/0.jpg"
      end
    end

    context "When has on youtube video with path 'v'" do

      let(:html) do
          %Q(<iframe width="560" height="315" src="https://www.youtube-nocookie.com/v/video-1" frameborder="0" allowfullscreen></iframe>)
      end

      it "Does return array with 1 image" do
        expect(subject.size).to eq 1
      end

      it "Does return youtube url" do
        expect(subject.first[:url]).to eq "http://img.youtube.com/vi/video-1/maxresdefault.jpg"
      end
      
      it "Does return youtube url fallback" do
        expect(subject.first[:url_fallback]).to eq "http://img.youtube.com/vi/video-1/0.jpg"
      end
    end

    context "When has on youtube video with domais no-cookies" do

      let(:html) do
          %Q(<iframe width="560" height="315" src="https://www.youtube-nocookie.com/v/video-6" frameborder="0" allowfullscreen></iframe>)
      end

      it "Does return array with 1 image" do
        expect(subject.size).to eq 1
      end

      it "Does return youtube url" do
        expect(subject.first[:url]).to eq "http://img.youtube.com/vi/video-6/maxresdefault.jpg"
      end
      
      it "Does return youtube url fallback" do
        expect(subject.first[:url_fallback]).to eq "http://img.youtube.com/vi/video-6/0.jpg"
      end
    end
    
    context "When many youtube video" do

      let(:html) do
        %Q(
          <p>
            <iframe width="560" height="315" src="https://www.youtube.com/embed/video0" frameborder="0" allowfullscreen></iframe>
          </p>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/video1" frameborder="0" allowfullscreen></iframe>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/video2" frameborder="0" allowfullscreen></iframe>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/video3" frameborder="0" allowfullscreen></iframe>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/video-4" frameborder="0" allowfullscreen></iframe>
          <iframe width="560" height="315" src="https://www.youtube.com/v/video-5" frameborder="0" allowfullscreen></iframe>
          <iframe width="560" height="315" src="https://www.youtube-nocookie.com/v/video-6" frameborder="0" allowfullscreen></iframe>
        )
      end

      it "Does return array with 7 images" do
        expect(subject.size).to eq 7
      end

      it "Does return youtube urls" do
        expect(subject.map{ |video| video[:url] }).to include(
          "http://img.youtube.com/vi/video0/maxresdefault.jpg",  
          "http://img.youtube.com/vi/video1/maxresdefault.jpg",  
          "http://img.youtube.com/vi/video2/maxresdefault.jpg", 
          "http://img.youtube.com/vi/video3/maxresdefault.jpg", 
          "http://img.youtube.com/vi/video-4/maxresdefault.jpg", 
          "http://img.youtube.com/vi/video-4/maxresdefault.jpg", 
          "http://img.youtube.com/vi/video-6/maxresdefault.jpg")
      end
      
      it "Does return youtube urls fallback" do
        expect(subject.map{ |video| video[:url_fallback] }).to include(
          "http://img.youtube.com/vi/video0/0.jpg",  
          "http://img.youtube.com/vi/video1/0.jpg",  
          "http://img.youtube.com/vi/video2/0.jpg", 
          "http://img.youtube.com/vi/video3/0.jpg", 
          "http://img.youtube.com/vi/video-4/0.jpg", 
          "http://img.youtube.com/vi/video-4/0.jpg", 
          "http://img.youtube.com/vi/video-6/0.jpg")
      end
    end
  end
end
