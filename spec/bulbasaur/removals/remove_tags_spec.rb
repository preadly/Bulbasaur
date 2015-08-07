require 'spec_helper'

RSpec.describe Bulbasaur::RemoveTags do
  subject { described_class.new(html, banned_tags).call }

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
        <p>hello!</p>
      ]
    end

    context 'when there are no banned tags' do
      let(:banned_tags) { [] }

      it 'returns the HTML code as it was before' do
        expect(subject).to eq html
      end
    end

    context 'when there are banned tags' do
      let(:banned_tags) { %w(form style) }

      it 'returns the HTML code without the banned tags' do
        expect(subject.strip.gsub(/\n/, '').squeeze ' ').to eq %[
          <div style="height: 100px; width: 100px;"></div>
          <p>hello!</p>
        ].strip.gsub(/\n/, '').squeeze ' '
      end
    end
  end
end