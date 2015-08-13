require 'spec_helper'

RSpec.describe Bulbasaur::RemoveAttributes do
  
  subject do 
    described_class.new(html, banned_attrs).call 
  end

  describe '#call' do
    
    let(:html) do
      %[
        <style>
          div { color: green; width: 1024px; }
        </style>
        <div style="height: 100px; width: 100px;"></div>
        <form>
          <input type="text">
        </form>
        <p style="font-size: x-large">hello!</p>
      ]
    end

    context 'when there are no banned attributes' do
      
      let(:banned_attrs) do
        [] 
      end

      it 'returns the HTML code as it was before' do
        expect(subject).to eq html
      end
    end

    context 'when there are banned attributes' do
      
      let(:banned_attrs) do
        %w(style)
      end

      it 'returns the HTML code without the banned attributes' do
        expect(subject.strip.gsub(/\n/, '').squeeze ' ').to eq %[
          <style>
            div { color: green; width: 1024px; }
          </style>
          <div></div>
          <form>
            <input type="text">
          </form>
          <p>hello!</p>
        ].strip.gsub(/\n/, '').squeeze ' '
      end
    end
  end

end
