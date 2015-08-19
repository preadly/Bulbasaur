require 'spec_helper'

RSpec.describe Bulbasaur::ExtractImagesFromMeta do
  subject { described_class.new(html).call }

  describe '#call' do
    context 'when there are no image meta tags' do
      let(:html) { %Q(<meta property="og:description" content="Just a RSpec test." />) }

      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end

    context 'when there is one image meta tag' do
      let :html do
        %Q(
        <meta property="og:image" content="http://somewhere.to/get/an_image.jpg" />
        <meta property="og:description" content="Just a RSpec test." />
        )
      end

      it 'returns the image URL found' do
        expect(subject.count).to be 1
        expect(subject).to include Hash url: 'http://somewhere.to/get/an_image.jpg', source: 'meta'
      end
    end

    context 'when there are multiple image meta tags' do
      let :html do
        %Q(
        <meta property="og:image" content="http://somewhere.to/get/an_image.jpg" />
        <meta property="og:image" content="http://somewhere.to/get/another_image.jpg" />
        <meta property="og:image" content="http://somewhere.to/get/a_third_image.jpg" />
        <meta property="og:description" content="Just a RSpec test." />
        )
      end

      it 'returns the image URLs found' do
        expect(subject.count).to be 3
        expect(subject.map { |meta| meta[:url] }).to include 'http://somewhere.to/get/an_image.jpg', 'http://somewhere.to/get/another_image.jpg', 'http://somewhere.to/get/a_third_image.jpg'
      end
    end
  end
end