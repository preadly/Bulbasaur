require "spec_helper"

RSpec.describe Bulbasaur::ExtractMetaInformationsFromHTML do
  
  subject do
    described_class.new(html).call
  end
  
  let(:html) do
    %Q(
      <head>
        <meta name="description" content="test-description">
        <meta property="keywords" value="test-keywords">
        <meta NAME="author" VALUE="test-author">
        <link rel="canonical" href="test-canonical">
      </head>
    ) 
  end

  describe "#call" do

    let(:meta_names) do
      subject.map {|h| h[:name]}
    end
    
    let(:meta_values) do
      subject.map {|h| h[:value]}
    end
    
    it "Does extract meta names informations from html" do
      expect(meta_names).to include "description", "keywords", "author", "canonical"
    end
    
    it "Does extract meta values informations from html" do
      expect(meta_values).to include "test-description", "test-keywords", "test-author", "test-canonical"
    end
  end
end
