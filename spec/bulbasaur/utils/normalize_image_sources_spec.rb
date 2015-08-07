require 'spec_helper'

RSpec.describe Bulbasaur::NormalizeImageSources do
  subject { described_class.new(html, target_attrs).call }

  describe '#call' do
    let(:html) { '<img src="http://somewhere.to/get/a-pixel.gif" data-lazy-src="http://somewhere.to/get/the-real-image.jpg" alt="Image" width="800" height="1200">' }

    context 'when there are no target attributes' do
      let(:target_attrs) { [] }

      it 'returns the HTML code as it was before' do
        expect(subject).to eq html
      end
    end

    context 'when there are target attributes' do
      let(:target_attrs) { %w(data-lazy-src) }

      it 'returns the HTML code with the image tags adjusted' do
        expect(subject).to eq '<img src="http://somewhere.to/get/the-real-image.jpg" alt="Image" width="800" height="1200">'
      end
    end
  end
end