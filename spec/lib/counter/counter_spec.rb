require 'spec_helper'
require 'countdown/counter'

RSpec.describe Countdown::Counter do

  describe '.valid?' do
    it "allows mm:ss" do
      expect(Countdown::Counter.valid?('12:56')).to eq(true)
    end

    it "allows hh:mm:ss" do
      expect(Countdown::Counter.valid?('13:12:56')).to eq(true)
    end

    it "ensures there are not more than 24 hours" do
      expect(Countdown::Counter.valid?('55:12:56')).to eq(false)
    end

    it "ensures there are not more than 60 minutes" do
      expect(Countdown::Counter.valid?('12:99:56')).to eq(false)
    end

    it "ensures there are not more than 60 seconds" do
      expect(Countdown::Counter.valid?('12:23:67')).to eq(false)
    end
  end

  describe 'initialization' do
    it 'will raise ArgumentError if input is invalid' do
      expect {
        expect( Countdown::Counter.new('asdasd') )
      }.to raise_error "asdasd is not a valid time code string."
    end

    it "allows creation from an integer" do
      expect( Countdown::Counter.new(10).seconds ).to eq 10
    end

    it "allows creation from an hash" do
      expect( Countdown::Counter.new(minutes: 1, seconds: 2).seconds ).to eq 62
      expect( Countdown::Counter.new(hours: 1, seconds: 2).seconds ).to eq 3602
    end
  end

  describe '#to_s' do
    it "formats a countdown" do
      expect( Countdown::Counter.new('12:56').to_s ).to eq('00:12:56')
    end

    it "can output a short MM:SS format" do
      expect( Countdown::Counter.new('12:56').to_s(short_format: true) ).to eq('12:56')
    end
  end
  describe "#to_i" do
    it "outputs the total seconds" do
      expect( Countdown::Counter.new('1:20').to_i ).to eq(80)
      expect( Countdown::Counter.new('01:01:20').to_i ).to eq(3680)
    end
  end
  describe "#seconds" do
    it "outputs the total seconds" do
      expect( Countdown::Counter.new('1:22').seconds ).to eq(82)
    end
  end
  describe "#minutes" do
    it "outputs the time expressed in minutes decimal" do
      expect( Countdown::Counter.new('1:30').minutes ).to eq(1.5)
    end
  end
  describe "#hours" do
    it "outputs the time expressed in hours decimal" do
      expect( Countdown::Counter.new('01:30:00').hours ).to eq(1.5)
    end
  end
  describe "#to_h" do
    it "outputs the time as a hash" do
      input = {
        seconds: 1,
        minutes: 2,
        hours: 1
      }
      expect( Countdown::Counter.new(input).to_h ).to eq input
    end
  end
end