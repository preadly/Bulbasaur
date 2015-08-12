require "spec_helper"

RSpec.describe Bulbasaur::ExtractMetaInformationsFromHTML do
  let(:html) { %Q(<head><meta name="description" content="test-description"><meta property="keywords" value="test-keywords"><meta NAME="author" VALUE="test-author"><link rel="canonical" href="test-canonical"></head>) }

  subject do
    described_class.new(html).call
  end

  describe '#call' do
    it 'should extract meta informations from html' do
      meta_names = subject.map {|h| h[:name]}
      meta_values = subject.map {|h| h[:value]}
      expect(meta_names).to include 'description', 'keywords', 'author', 'canonical'
      expect(meta_values).to include 'test-description', 'test-keywords', 'test-author', 'test-canonical'
    end
  end
end