require 'spec_helper'

RSpec.describe Bulbasaur::RemoveTags do
  
  subject do 
    described_class.new(html, banned_tags, empty_tags).call
  end

  describe '#call' do
    
    let(:empty_tags) do
      false
    end
    
    let(:html) do
      %[
        <style>
          div { color: green; width: 1024px; }
        </style>
        <div style="height: 100px; width: 100px;"></div>
        <form>
          <input type="text">
        </form>
        <p>hello!</p>
        <div class="inner top"> 
          <p></p>
          <div> </div>
        </div>
        <div></div>
        <p></p>
      ]
    end

    context 'when there are no banned tags' do
      
      let(:banned_tags) do
        []
      end
    
      it 'returns the HTML code as it was before' do
        expect(subject).to eq html
      end
    end
    
    context 'when there are banned tags' do
      
      let(:banned_tags) do
        %w(form style)
      end
    
      it 'returns the HTML code without the banned tags' do
        expect(subject.strip.gsub(/\n/, '').squeeze ' ').to eq %[
          <div style="height: 100px; width: 100px;"></div>
          <p>hello!</p>
          <div class="inner top"> 
            <p></p>
            <div> </div>
          </div>
          <div></div>
          <p></p>
        ].strip.gsub(/\n/, '').squeeze ' '
      end
    end
    
    context 'when the HTML code with the banned tags and defined no empty tags' do
    
      let(:html) do
      %[
        <style>
          div { color: green; width: 1024px; }
        </style>
        <div style="height: 100px; width: 100px;"></div>
        <form>
          <input type="text">
        </form>
        <p>hello!</p>
        <div class="inner top"> 
          <p></p>
          <div><img src='test.jpg'></div>
        </div>
        <div></div>
        <p>        </p>
        <div class="helo">         </div>
        <p></p>
      ]
     end
    
      let(:banned_tags) do
        %w(form style)
      end

      let(:empty_tags) do
        true
      end
    
      it 'returns the HTML code without the banned tags and without empty tags' do
        expect(subject.strip.gsub(/\n/, '').squeeze ' ').to eq %[
          <p>hello!</p>
          <div class="inner top"> 
          <div><img src="test.jpg"></div>
          </div>
        ].strip.gsub(/\n/, '').squeeze ' '
      end
    end
  end
end
