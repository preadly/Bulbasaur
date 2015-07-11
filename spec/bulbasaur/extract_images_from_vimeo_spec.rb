require 'spec_helper'

RSpec.describe Bulbasaur::ExtractImagesFromVimeo do

  subject do
    described_class.new(html).call
  end

  describe "#call" do
    
    context "When there is not vimeo images" do
    
      let(:html) do
        "<p>Lorem ipsum dolor sit amet</p>"
      end

      it "Does return empty array" do
        expect(subject.size).to be_zero 
      end
    end

    context "When has one vimeo video" do

      let(:html) do
        %Q(<iframe src="https://player.vimeo.com/video/123456789" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>)
      end

      it "Does return array with 1 image" do
        expect(subject.size).to eq 1
      end

      it "Does return vime url" do
        expect(subject.first[:url]).to eq "https://i.vimeocdn.com/video/123456789_640.webp"
      end
    end
    
    context "When many vimeo videos" do

      let(:html) do
        %Q(
          <p>
            <iframe src="https://player.vimeo.com/video/test0" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
            <iframe width="560" height="315" src="https://www.youtube.com/embed/video0" frameborder="0" allowfullscreen></iframe>
          </p>
          <iframe src="https://player.vimeo.com/video/test1" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
          <iframe src="https://player.vimeo.com/video/test2" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
          <iframe src="https://player.vimeo.com/video/test3" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
        )
      end

      it "Does return array with 4 images" do
        expect(subject.size).to eq 4
      end

      it "Does return vimeo urls" do
        expect(subject.map{ |video| video[:url] }).to include "https://i.vimeocdn.com/video/test0_640.webp",  "https://i.vimeocdn.com/video/test1_640.webp",  "https://i.vimeocdn.com/video/test2_640.webp", "https://i.vimeocdn.com/video/test3_640.webp"
      end
    end
  end
end
