require "spec_helper"

RSpec.describe Bulbasaur::ExtractImagesFromAllResources do

  subject do
    described_class.new(html).call
  end
  
  before do
    stub_request(:get, /\.youtube\.com/).to_return(status: 200)
  end

  describe "#call" do
    
    let(:html) do
        %Q(
          <p>
            <iframe width="560" height="315" src="https://www.youtube.com/embed/video0" frameborder="0" allowfullscreen></iframe>
          </p>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/video1" frameborder="0" allowfullscreen></iframe>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/video2" frameborder="0" allowfullscreen></iframe>
          <iframe width="560" height="315" src="https://www.youtube.com/embed/video3" frameborder="0" allowfullscreen></iframe>
          <p>
            <iframe src="https://player.vimeo.com/video/test0" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
            <iframe width="560" height="315" src="https://www.youtube.com/embed/video0" frameborder="0" allowfullscreen></iframe>
          </p>
          <iframe src="https://player.vimeo.com/video/test1" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
          <iframe src="https://player.vimeo.com/video/test2" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
          <iframe src="https://player.vimeo.com/video/test3" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
          <p>Hello world</p>
           <img src='image-0.jpg' alt='image-0' />
          <img src='image-1.png' alt='image-1' />
          <div style='backgroung-image: url(image-2.jpg)'>
            hello Ruby
            <img src='image-3.png' alt='image-3' />
          </div>
          <div style='background: url(image-4.png)'></div> 
          <img src='image-5.png' alt='image-5' />"
        )
    end

    it "Does return 15 itens" do
      expect(subject.size).to eq 15
    end
  end
end
