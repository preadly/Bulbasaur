require 'spec_helper'

RSpec.describe Bulbasaur::NormalizeImageSources do
  subject { described_class.new(html, target_attrs).call }

  describe '#call' do
    let(:html) { '<img src="http://somewhere.to/get/a-pixel.gif" data-lazy-src="http://somewhere.to/get/the-real-image.jpg" alt="Image" width="800" height="1200"><img src="http://somewhere.to/get/another-pixel.gif" data-image="http://somewhere.to/get/the-other-real-image.jpg"><img src="http://somewhere.to/get/a-third-pixel.gif" data-src="get/the-third-real-image.jpg"><img src="otherplace.to/load/a-fourth-pixel.gif" lazy-data="otherplace.to/load/the-fourth-real-image.jpg">' }

    context 'when there are no target attributes' do
      let(:target_attrs) { [] }

      it 'returns the HTML code as it was before' do
        expect(subject).to eq html
      end
    end

    context 'when there are target attributes' do
      let(:target_attrs) { %w(data-lazy-src data-image) }

      it 'returns the HTML code with the specified image tags adjusted' do
        expect(subject).to eq '<img src="http://somewhere.to/get/the-real-image.jpg" alt="Image" width="800" height="1200"><img src="http://somewhere.to/get/the-other-real-image.jpg"><img src="http://somewhere.to/get/a-third-pixel.gif" data-src="get/the-third-real-image.jpg"><img src="otherplace.to/load/a-fourth-pixel.gif" lazy-data="otherplace.to/load/the-fourth-real-image.jpg">'
      end
    end

    context 'when there are target attributes with relative path' do
      let(:target_attrs) { %w(data-lazy-src data-image data-src lazy-data) }

      it 'returns the HTML code with the involved image tags fixed with domain and path' do
        expect(subject).to eq '<img src="http://somewhere.to/get/the-real-image.jpg" alt="Image" width="800" height="1200"><img src="http://somewhere.to/get/the-other-real-image.jpg"><img src="http://somewhere.to/get/the-third-real-image.jpg"><img src="otherplace.to/load/the-fourth-real-image.jpg">'
      end
    end
  end
end